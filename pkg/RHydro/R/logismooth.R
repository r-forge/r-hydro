logismooth <- function(state,state_max) {
   # Uses a logistic function to smooth the threshold at the top of a bucket
   # Author: Claudia Vitolo
   # Date: 28-03-2011
   #
   # PART OF FUSE MODEL (module 12a of XXX)
   #
   # Args:
   #   state:
   #   state_max:
   #
   # Returns:
   #   Threshold at the top of a bucket
   
   psmooth    <- 0.01                   # smoothing parameter
   asmooth    <- psmooth*state_max      # actual smoothing
   logismooth <- 1 / ( 1 + exp(-(state - (state_max - asmooth*5) ) / asmooth) )
   
}

