mean_tipow <- function(ti_shp,log_lamb,qb_pwr) { 
   # Computes the mean of the power-transformed topographic index
   # Author: Claudia Vitolo
   # Date: 28-03-2011
   #
   # PART OF FUSE MODEL (3a of XXX)
   #
   # Args:
   #   ti_shp:
   #   log_lamb:
   #   qb_pwr:
   #
   # Returns:
   #   Mean of the power-transformed topographic index.      
   
   # internal variables
   nbins  <- 2000                                        # number of bins in pdf of topo index
   ti_max <- 50                                          # maximum possible log-transformed index
   
   # preliminaries: get parameters of the gamma distribution [ti_shp = shape of the gamma distribution  (the "2nd" parameter)]
   ti_off <- 3                                           # offset in the gamma distribution (the "3rd" parameter) 
   ti_chi <- (log_lamb - ti_off) / ti_shp  # chi -- loglamb is the first parameter (mean)
   
   # loop through the frequency distribution
   lowerv <- 0
   lowerp <- 0
   avepow <- 0
   for (ibin in 1:nbins) {
      # get probability for the current bin
      upperv <- (ibin/nbins) * ti_max                    # upper value in frequency bin
      gmarg2 <- max(0, upperv - ti_off) / ti_chi         # 1st argument to the gamma function
      upperp <- pgamma(gmarg2,ti_shp)                    # gammp is the incomplete gamma function
      probin <- upperp - lowerp                          # probability of the current bin
      # get the scaled topographic index value
      logval <- 0.5 * (lowerv + upperv)                  # log-transformed index for the current bin
      powval <- (exp(logval))**(1/qb_pwr)                # power-transformed index for the current bin
      avepow <- avepow + powval*probin                   # average power-transformed index
      # save the lower value and probability
      lowerv <- upperv                                   # lower value for the next bin
      lowerp <- upperp                                   # cumulative probability for the next bin
   }

   maxpow  <- powval
   powlamb <- avepow

   results <-c(maxpow,powlamb)
   
   return(results)

}

