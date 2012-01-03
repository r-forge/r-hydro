assign_par <- function(smodl,mparam0) {
   # Extract useful parameters from Contraints table
   # Author: Claudia Vitolo
   # Date: 23-11-2011
   #
   # Args:
   #   smodl:                         list of model components
   #   constr:                        set of parameters (table)
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
   #timedelay <- -999 # use a gamma distribution with shape parameter <- 2.5

   # (1) rainfall errors
   if(smodl$rferr == 11) rferr_add <- mparam0$rferr_add
   if(smodl$rferr == 12) rferr_mlt <- mparam0$rferr_mlt

   # (2) upper-layer architecture
  if(smodl$arch1 == 21 || smodl$arch1 == 22) {
      fracten   <- mparam0$fracten
      maxwatr_1 <- mparam0$maxwatr_1
   }
   
   if(smodl$arch1 == 23) {
      frchzne   <- mparam0$frchzne
      fracten   <- mparam0$fracten
      maxwatr_1 <- mparam0$maxwatr_1
   }

   # (3) lower-layer architecture / baseflow
  if(smodl$arch2 == 31) { # power-law relation (no parameters needed for the topo index distribution)
     maxwatr_2 <- mparam0$maxwatr_2
     baserte   <- mparam0$baserte
     qb_powr   <- mparam0$qb_powr
   }
   
   if(smodl$arch2 == 32) {       # tension reservoir plus two parallel tank
      percfrac  <- mparam0$percfrac
      fprimqb   <- mparam0$fprimqb
      maxwatr_2 <- mparam0$maxwatr_2
      qbrate_2a <- mparam0$qbrate_2a
      qbrate_2b <- mparam0$qbrate_2b
   }

   if(smodl$arch2 == 33) {        # baseflow resvr of unlimited size (0-huge), frac rate
     maxwatr_2 <- mparam0$maxwatr_2
     qb_prms   <- mparam0$qb_prms
   }
   
  if(smodl$arch2 == 34) {        # topmodel options
     maxwatr_2 <- mparam0$maxwatr_2
     baserte   <- mparam0$baserte
     loglamb   <- mparam0$loglamb
     tishape   <- mparam0$tishape
     qb_powr   <- mparam0$qb_powr
   }

   if(smodl$arch2 == 35) {        # topmodel options
     maxwatr_2 <- mparam0$maxwatr_2
     baserte   <- mparam0$baserte
     loglamb   <- mparam0$loglamb
     tishape   <- mparam0$tishape
   }



   # (4) surface runoff
   if(smodl$qsurf == 41) axv_bexp <- mparam0$axv_bexp # arno/xzang/vic parameterization (upper zone control)
   if(smodl$qsurf == 42) sareamax <- mparam0$sareamax # prms variant (fraction of upper tension storage)
   if(smodl$qsurf == 43) {                                                                     # topmodel parameterization
     if(smodl$arch2 == 32 || smodl$arch2 == 33 || smodl$arch2 == 31) {     # need the topographic index if we don't have it for baseflow
       loglamb   <- mparam0$loglamb
       tishape   <- mparam0$tishape
     }
     if(smodl$arch2 == 32 || smodl$arch2 == 33 || smodl$arch2 == 35) qb_powr   <- mparam0$qb_powr # need the topmodel power if we don't have it for baseflow # baseflow exponent (-), used to modify the topographic
   }
   
   # (5) percolation
   if(smodl$qperc == 51||smodl$qperc == 53) { # standard equation k(theta)**c
     percrte   <- mparam0$percrte
     percexp   <- mparam0$percexp
   }

   if(smodl$qperc == 52) { # perc defined by moisture content in lower layer (sac)
     sacpmlt   <- mparam0$sacpmlt
     sacpexp   <- mparam0$sacpexp
   }

   # (6) evaporation
   if(smodl$esoil == 61) rtfrac1 <- mparam0$rtfrac1

   # (7) interflow
   if(smodl$qintf == 72) iflwrte <- mparam0$iflwrte

   # (8) time delay in runoff
   #if(smodl$q_tdh == 82) timedelay <- mparam0$timedelay

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
                  "qb_powr"   = qb_powr  #,
                  #"timedelay" = timedelay
                  )

   return(params)
}

