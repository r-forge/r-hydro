fuserouting.sim <- function(U, mid, modlist, timedelay, deltim=1) {    
   ## FUSE Routing model
   # Author: Claudia Vitolo
   #
   # Args:
   #   U:                             effective rainfall (sum of surface runoff, overflow, interflow, and baseflow)
   #   mid:                           model id number
   #   modlist:                       list of models
   #   deltim:                        data time step: deltim = 1 (daily time step), 1/24 (hourly time step), 1/24/4 (15 min time step)
   #   timedelay:                     time delay in runoff (days) mparam$timedelay (use a gamma distribution with shape parameter <- 2.5)
   #
   # Returns:
   #   X:                             routed runoff
  
   print("routing ...")
   # Assing standard parameters
   size_frac_future = 500       # fraction of runoff in future time steps
   alpha = 2.5                  # shape parameter
   
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

#fuserouting.ranges <- function(deltim) {
#    list("timedelay" = c(0.01, 5),        # time delay in runoff (days)
#}
    
