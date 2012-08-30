outfluxes <- function(smodl,P,E,mparam,dparam,state1) {
   # Output Fluxes
   # Author: Claudia Vitolo
   #
   # Args:
   #   smodl:                         list of model components
   #   P:                             rain+snow melt time series 
   #   E:                             potential evapotranspiration time series
   #   mparam:                        model parameters
   #   dparam:                        derived model parameters
   #   state1:                        state variables
   #
   # Returns:
   #   All the fluxes + effective rainfall (or instantaneous discharge)

   # set all fluxes to zero at the start of time step
   eff_ppt     <- rep(0,length(P))
   satarea     <- rep(0,length(P))
   qrunoff     <- rep(0,length(P))   
   evap_1a     <- rep(0,length(P))   
   evap_1b     <- rep(0,length(P))  
   evap_1      <- rep(0,length(P))   
   evap_2      <- rep(0,length(P))   
   rchr2excs   <- rep(0,length(P))
   tens2free_1 <- rep(0,length(P))
   tens2free_2 <- rep(0,length(P))
   qintf_1     <- rep(0,length(P))
   qperc_12    <- rep(0,length(P))
   qbase_2     <- rep(0,length(P))
   qbase_2a    <- rep(0,length(P))
   qbase_2b    <- rep(0,length(P))
   oflow_1     <- rep(0,length(P))
   oflow_2     <- rep(0,length(P))
   oflow_2a    <- rep(0,length(P))
   oflow_2b    <- rep(0,length(P))
 
   U           <- rep(0,length(P))     # effective rainfall
   
   for (index in seq(along = P)) { 
       #if (index == 720) browser()
       w_flux   <- compute_fluxes(smodl,P[index],E[index],mparam,dparam,state1[index,2:11])
       eff_ppt[index]     <- w_flux$eff_ppt
       satarea[index]     <- w_flux$satarea
       qrunoff[index]     <- w_flux$qrunoff 
       evap_1a[index]     <- w_flux$evap_1a   
       evap_1b[index]     <- w_flux$evap_1b  
       evap_1[index]      <- w_flux$evap_1   
       evap_2[index]      <- w_flux$evap_2   
       rchr2excs[index]   <- w_flux$rchr2excs
       tens2free_1[index] <- w_flux$tens2free_1
       tens2free_2[index] <- w_flux$tens2free_2
       qintf_1[index]     <- w_flux$qintf_1
       qperc_12[index]    <- w_flux$qperc_12
       qbase_2[index]     <- w_flux$qbase_2
       qbase_2a[index]    <- w_flux$qbase_2a
       qbase_2b[index]    <- w_flux$qbase_2b
       oflow_1[index]     <- w_flux$oflow_1
       oflow_2[index]     <- w_flux$oflow_2
       oflow_2a[index]    <- w_flux$oflow_2a
       oflow_2b[index]    <- w_flux$oflow_2b
       # compute effective rainfall (sum of surface runoff, overflow, interflow, and baseflow)
       U[index] <- w_flux$qrunoff + w_flux$oflow_1 + w_flux$qintf_1 + w_flux$oflow_2 + w_flux$qbase_2
   }

   allfluxes <- list("eff_ppt"     = eff_ppt,
                 "satarea"     = satarea,
                 "qrunoff"     = qrunoff,
                 "evap_1a"     = evap_1a,
                 "evap_1b"     = evap_1b,
                 "evap_1"      = evap_1,
                 "evap_2"      = evap_2,
                 "rchr2excs"   = rchr2excs,
                 "tens2free_1" = tens2free_1,
                 "oflow_1"     = oflow_1,
                 "tens2free_2" = tens2free_2,
                 "qintf_1"     = qintf_1,
                 "qperc_12"    = qperc_12,
                 "qbase_2"     = qbase_2,
                 "qbase_2a"    = qbase_2a,
                 "qbase_2b"    = qbase_2b,
                 "oflow_2"     = oflow_2,
                 "oflow_2a"    = oflow_2a,
                 "oflow_2b"    = oflow_2b,
                 "U" = U)
   
   return(allfluxes)

}

