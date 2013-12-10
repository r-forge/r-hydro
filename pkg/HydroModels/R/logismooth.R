logismooth <- function(statex,maxstatex) {
   # Uses a logistic function to smooth the threshold at the top of a bucket
   # Author: Claudia Vitolo
   #
   # Args:
   #   statex:
   #   maxstatex:
   #
   # Returns:
   #   Threshold at the top of a bucket
   
   psmooth    <- 0.01                   # smoothing parameter
   asmooth    <- psmooth*maxstatex      # actual smoothing
   logismooth <- 1 / ( 1 + exp(-(statex - (maxstatex - asmooth*5) ) / asmooth) )
   
}

