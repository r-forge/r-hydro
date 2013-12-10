assign_par <- function(smodl,mparam0) {
   # Extract useful parameters from input parameter list
   # Author: Claudia Vitolo
   #
   # Args:
   #   smodl:                         list of model components
   #   mparam0:                       initial parameter list 
   #
   # Returns:
   #   List of parameters.

   rferr_add <- -999 # additive rainfall error (mm day-1)
   rferr_mlt <- -999 # multiplicative rainfall error (-)
   frchzne   <- -999 # prms: frac tension storage in recharge zone (-)
   fracten   <- -999 # frac total storage as tension storage (-)
   maxwatr_1 <- -999 # maximum total storage in layer1 (mm)
   percfrac  <- -999 # fraction of percolation to tension storage (-)
   fprimqb   <- -999 # sac: fraction of baseflow in primary resvr (-)
   qbrate_2a <- -999 # baseflow depletion rate for primary resvr (day-1)
   qbrate_2b <- -999 # baseflow depletion rate for secondary resvr (day-1)
   qb_prms   <- -999 # baseflow depletion rate (day-1)
   maxwatr_2 <- -999 # maximum total storage in layer2 (mm)
   baserte   <- -999 # baseflow rate (mm day-1)
   rtfrac1   <- -999 # fraction of roots in the upper layer (-)
   percrte   <- -999 # percolation rate (mm day-1)
   percexp   <- -999 # percolation exponent (-)
   sacpmlt   <- -999 # multiplier in the sac model for dry lower layer (-)
   sacpexp   <- -999 # exponent in the sac model for dry lower layer (-)
   iflwrte   <- -999 # interflow rate (mm day-1)
   axv_bexp  <- -999 # arno/vic "b" exponent
   sareamax  <- -999 # maximum saturated area
   loglamb   <- -999 # mean value of the log-transformed topographic index (m)
   tishape   <- -999 # shape parameter for the topo index gamma distribution (-)
   qb_powr   <- -999 # baseflow exponent (-)

   # (1) rainfall errors
   if(smodl$rferr == 11) rferr_add <- mparam0$rferr_add   # additive_e
   if(smodl$rferr == 12) rferr_mlt <- mparam0$rferr_mlt   # multiplc_e

   # (2) upper-layer architecture
  if(smodl$arch1 == 21 || smodl$arch1 == 22) {   # onestate_1, tension1_1 (need to define tension and free storage -- even if one state)
      fracten   <- mparam0$fracten   # frac total storage as tension storage (-)
      maxwatr_1 <- mparam0$maxwatr_1 # maximum total storage in layer1 (mm)
   }
   
   if(smodl$arch1 == 23) {                       # tension2_1 (tension storage sub-divided into recharge and excess)
      frchzne   <- mparam0$frchzne   # PRMS: frac tension storage in recharge zone (-)
      fracten   <- mparam0$fracten   # frac total storage as tension storage (-)
      maxwatr_1 <- mparam0$maxwatr_1 # maximum total storage in layer1 (mm)
      #fraclowz  <- mparam0$fraclowz # fraction of soil excess to lower zone (-) # NOT USED
   }

   # (3) lower-layer architecture / baseflow
  if(smodl$arch2 == 31) {             # fixedsiz_2 (power-law relation (no parameters needed for the topo index distribution))
     maxwatr_2 <- mparam0$maxwatr_2
     baserte   <- mparam0$baserte
     qb_powr   <- mparam0$qb_powr
   }
   
   if(smodl$arch2 == 32) {            # tens2pll_2 (tension reservoir plus two parallel tanks)
      percfrac  <- mparam0$percfrac   # fraction of percolation to tension storage (-)
      fprimqb   <- mparam0$fprimqb    # SAC: fraction of baseflow in primary resvr (-)
      maxwatr_2 <- mparam0$maxwatr_2  # maximum total storage in layer2 (mm)
      qbrate_2a <- mparam0$qbrate_2a  # baseflow depletion rate for primary resvr (day-1)
      qbrate_2b <- mparam0$qbrate_2b  # baseflow depletion rate for secondary resvr (day-1)
   }

   if(smodl$arch2 == 33) {            # unlimfrc_2 (baseflow resvr of unlimited size (0-huge), frac rate)
     maxwatr_2 <- mparam0$maxwatr_2   # maximum total storage in layer2 (mm)
     qb_prms   <- mparam0$qb_prms     # baseflow depletion rate (day-1)
   }
   
  if(smodl$arch2 == 34) {             # unlimpow_2 (topmodel option = power-law transmissivity profile)
     maxwatr_2 <- mparam0$maxwatr_2   # maximum total storage in layer2 (mm)
     baserte   <- mparam0$baserte     # baseflow rate (mm day-1)
     loglamb   <- mparam0$loglamb     # mean value of the log-transformed topographic index (m)
     tishape   <- mparam0$tishape     # shape parameter for the topo index Gamma distribution (-)
     qb_powr   <- mparam0$qb_powr     # baseflow exponent (-)
   }

   if(smodl$arch2 == 35) {            # topmdexp_2 = old topmodel option, this which was something lingering from initial development.. not used because the exponential case can be very similar to the power case for given parameter values
     maxwatr_2 <- mparam0$maxwatr_2   # maximum total storage in layer2 (mm)
     baserte   <- mparam0$baserte     # baseflow rate (mm day-1)
     loglamb   <- mparam0$loglamb     # mean value of the log-transformed topographic index (m)
     tishape   <- mparam0$tishape     # shape parameter for the topo index Gamma distribution (-)
   }

   # (4) surface runoff
   if(smodl$qsurf == 41) axv_bexp <- mparam0$axv_bexp # arno_x_vic = arno/xzang/vic parameterization (upper zone control)
   if(smodl$qsurf == 42) sareamax <- mparam0$sareamax # prms_varnt = prms variant (fraction of upper tension storage)
   if(smodl$qsurf == 43) {                            # tmdl_param = topmodel parameterization
     if(smodl$arch2 == 32 || smodl$arch2 == 33 || smodl$arch2 == 31) {     # need the topographic index if we don't have it for baseflow
       loglamb   <- mparam0$loglamb
       tishape   <- mparam0$tishape
     }
     if(smodl$arch2 == 32 || smodl$arch2 == 33 || smodl$arch2 == 35) qb_powr   <- mparam0$qb_powr # need the topmodel power if we don't have it for baseflow # baseflow exponent (-), used to modify the topographic
   }
   
   # (5) percolation
   if(smodl$qperc == 51||smodl$qperc == 53) { # perc_f2sat, perc_w2sat = standard equation k(theta)**c
     percrte   <- mparam0$percrte             # percolation rate (mm day-1)
     percexp   <- mparam0$percexp             # percolation exponent (-)
   }

   if(smodl$qperc == 52) { # perc_lower = perc defined by moisture content in lower layer (sac)
     sacpmlt   <- mparam0$sacpmlt             # multiplier in the SAC model for dry lower layer (-)
     sacpexp   <- mparam0$sacpexp             # exponent in the SAC model for dry lower layer (-)
   }

   # (6) evaporation
   if(smodl$esoil == 61) rtfrac1 <- mparam0$rtfrac1   # fraction of roots in the upper layer (-)

   # (7) interflow
   if(smodl$qintf == 72) iflwrte <- mparam0$iflwrte   # interflow rate (mm day-1)

   params <- list("rferr_add" = rferr_add,
                  "rferr_mlt" = rferr_mlt,
                  "frchzne"   = frchzne  ,
                  "fracten"   = fracten  ,
                  "maxwatr_1" = maxwatr_1,
                  "percfrac"  = percfrac ,
                  "fprimqb"   = fprimqb  ,
                  "qbrate_2a" = qbrate_2a,
                  "qbrate_2b" = qbrate_2b,
                  "qb_prms"   = qb_prms  ,
                  "maxwatr_2" = maxwatr_2,
                  "baserte"   = baserte  ,
                  "rtfrac1"   = rtfrac1  ,
                  "percrte"   = percrte  ,
                  "percexp"   = percexp  ,
                  "sacpmlt"   = sacpmlt  ,
                  "sacpexp"   = sacpexp  ,
                  "iflwrte"   = iflwrte  ,
                  "axv_bexp"  = axv_bexp ,
                  "sareamax"  = sareamax ,
                  "loglamb"   = loglamb  ,
                  "tishape"   = tishape  ,
                  "qb_powr"   = qb_powr  
                  )

   return(params)
}

