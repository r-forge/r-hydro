fluxperc <- function(qperc,mparam,dparam,free_1, watr_1, watr_2) {
   # Compute percolation 
   # Author: Claudia Vitolo
   #
   # Args:
   #   qperc:                         smodl$qperc
   #   mparam:                        model parameters
   #   dparam:                        derived model parameters
   #   free_1:
   #   watr_1:
   #   watr_2:
   #
   # Returns:
   #   Percolation

   
   #qperc_12 <- 0
   
   # CASE('perc_f2sat') = water from (field cap to sat) avail for percolation
   if(qperc == 51) qperc_12 <- mparam$percrte * (free_1/dparam$maxfree_1)^mparam$percexp   
   
   # CASE('perc_lower') = perc defined by moisture content in lower layer (SAC)
   # (compute lower-zone percolation demand -- multiplier on maximum percolation, then percolation)
   if(qperc == 52) {   
      if (watr_2/mparam$maxwatr_2 > 1) {
        lz_pd <- 1 
      } else{
        lz_pd <- 1 + mparam$sacpmlt*(1 - watr_2/mparam$maxwatr_2)^mparam$sacpexp
      } 
      qperc_12 <- dparam$qbsat*lz_pd * (free_1/dparam$maxfree_1)
   }
   
   # CASE('perc_w2sat') = water from (wilt pt to sat) avail for percolation
   if(qperc == 53) qperc_12 <- mparam$percrte * (watr_1/mparam$maxwatr_1)^mparam$percexp   
   
   return(qperc_12)

}

