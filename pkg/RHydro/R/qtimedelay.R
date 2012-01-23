qtimedelay <- function(timedelay, deltim, size_frac_future) {
   # Computes the fraction of runoff in future time steps
   # Author: Claudia Vitolo
   #
   # Args:
   #   timedelay:                     mparam$timedelay
   #   deltim:                        time step in days
   #   size_frac_future:              maximum number of future time steps
   #
   # Returns:
   #   Fraction of runoff in future time steps.

   frac_future <- rep(0, size_frac_future)
   
   alpha <- 2.5                                          # shape parameter
   alamb <- alpha/timedelay                              # scale parameter
   psave <- 0.0                                          # cumulative probability at jtim-1

   # loop through time steps and compute the fraction of runoff in future time steps
   for (jtim in seq(along = frac_future)) {
        tfuture <- jtim  * deltim                        # future time (units of days)
        cumprob <- pgamma(alamb*tfuture,alpha)           # cumulative probability at jtim
        frac_future[jtim]  <- max(0, cumprob-psave)      # probability between jtim-1 and jtim
        psave   <- cumprob                               # cumulative probability at jtim-1
   }
      
   # ensure that the fractions sum to 1.0 (account for rounding errors, and not enough bins)
   frac_future <- frac_future / sum(frac_future)

   return(frac_future)

}

