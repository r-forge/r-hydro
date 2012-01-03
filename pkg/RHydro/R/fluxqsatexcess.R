fluxqsatexcess <- function(mqsurf,eff_ppt,mparam,dparam,tens_1, watr_1, watr_2) {
   # Computes the saturated area and surface runoff
   # Author: Claudia Vitolo
   # Date: 28-03-2011
   #
   # Args:
   #   mqsurf:      smodl$qsurf
   #   eff_ppt:     eff_ppt
   #   mparam:      mparam
   #   dparam:      dparam
   #   tens_1:      tens_1
   #   watr_1:      watr_1
   #   watr_2:      watr_2
   #
   # Returns:
   #   Saturated Area and Surface Runoff

   satarea   <- 0
   qrunoff   <- 0 
      
   no_zero   <- 0.00000001  # avoid divide by zero
   
   # saturated area method
   if(mqsurf == 41) satarea <- 1 - ( 1 - min(watr_1/mparam$maxwatr_1, 1) )**mparam$axv_bexp  # arno/xzang/vic parameterization (upper zone control)
  
   if(mqsurf == 42) satarea <- min(tens_1/dparam$maxtens_1, 1) * mparam$sareamax             # prms variant (fraction of upper tension storage)
  
   if(mqsurf == 43) { # topmodel parameterization (only valid for topmodel qb)
      # compute the minimum value of the topographic index where the basin is saturated
      # (this is correct, as maxwatr_2 is m*n -- units are meters**(1/n)
      ti_sat <- dparam$powlamb / (watr_2/mparam$maxwatr_2 + no_zero)
      # compute the saturated area
      if(ti_sat > dparam$maxpow) {
         satarea <- 0 
      } else {
         ti_log  <- log( ti_sat**mparam$qb_powr )                # convert the topographic index to log space, compute the saturated area (note: critical value of the topographic index is in log space)
         ti_off  <- 3                                            # offset in the gamma distribution (the "3rd" parameter)
         ti_shp  <- mparam$tishape                               # shape of the gamma distribution (the "2nd" parameter)
         ti_chi  <- (mparam$loglamb - ti_off) / mparam$tishape   # chi -- loglamb is the first parameter (mean)
         ti_arg  <- max(0, ti_log - ti_off) / ti_chi             # argument to the incomplete gamma function
         satarea <- 1 - pgamma(ti_arg,ti_shp)                    # pgamma is the incomplete gamma function # cv: pgamma(scale,shape)
         #satarea <- 1 - pgamma(ti_arg,ti_shp, lower=FALSE) * gamma(ti_shp)                    # pgamma is the incomplete gamma function # cv: pgamma(scale,shape)
      }
   }

   qrunoff <- eff_ppt * satarea   # compute surface runoff
   
   results <- c(satarea,qrunoff)
   
   return(results)

}

