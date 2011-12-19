fluxrain <- function(rferr,fppt,rferr_add,rferr_mlt) {
   # Compute the "effective" rainfall, following a prescribed error model
   # Author: Claudia Vitolo
   # Date: 28-03-2011
   #
   # PART OF FUSE MODEL (module 6 of XXX)
   #
   # Args:
   #   rferr:        smodl$rferr
   #   fppt:         rain+snow melt at time "t"
   #   rferr_add:    mparam$rferr_add
   #   rferr_mlt:    mparam$rferr_mlt
   #
   # Returns:
   #   Effective rainfall
   
   eff_ppt <- 0
   
   if(rferr == 11) eff_ppt <- max(0, fppt + rferr_add)
   if(rferr == 12) eff_ppt <- fppt * rferr_mlt

   return(eff_ppt)

}

