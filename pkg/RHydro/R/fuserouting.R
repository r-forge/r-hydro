fuserouting.sim <- function(U, mid, modlist, deltim=1, timedelay, size_frac_future = 500, alpha = 2.5, psave = 0.0) {    
   ## FUSE Routing model
   # Author: Claudia Vitolo
   #
   # Args:
   #   U:                             effective rainfall (sum of surface runoff, overflow, interflow, and baseflow)
   #   qtdh:                          runoff element of the model structure (can be 81 or 82)
   #   size_frac_future:              fraction of runoff in future time steps
   #   deltim:                        time step
   #   timedelay:                     mparam$timedelay (use a gamma distribution with shape parameter <- 2.5)
   #   alpha:                         shape parameter
   #   psave:                         cumulative probability at jtim-1
   #
   # Returns:
   #   X:                             routed runoff
  
   print("routing ...")
   
   # Read model structure
   qtdh <- modlist[mid,9]
   
   # adaptation from parderive/qtimedelay/qoverland
   frac_future <- qtimedelay(timedelay, deltim, size_frac_future)
   
   future   <- X <- rep(0,length(U))
   
   if (qtdh == 81)  X <- U   # no routing
     
   if (qtdh == 82) {         # use a gamma distribution with shape parameter = 2.5

   # Routing
   for (index in seq(along = U)) {
        
        # place a fraction of runoff in future time steps (ntdh = maximum number of future time steps)
        for (jtim in 1:size_frac_future) future[jtim] <- future[jtim] + U[index] * frac_future[jtim]           
        #future <- future + q_instnt[index] * dparam$frac_future
           
        # save the routed runoff
        X[index] <- future[1]
           
        # move array back
        future[1:size_frac_future-1] <- future[2:size_frac_future]
        future[size_frac_future] <- 0

     }
   }

   #attributes(X) <- attributes(U)
 
   return(X)
}

