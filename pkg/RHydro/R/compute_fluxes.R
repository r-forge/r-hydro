compute_fluxes <- function(smodl,mppt,mpet,mparam,dparam,state) {
   # Compute Fluxes
   # Author: Claudia Vitolo
   #
   # Args:
   #   smodl:                         list of model components
   #   mppt:                          rain+snow melt at time "t"
   #   mpet:                          potential evapotranspiration at time "t"
   #   mparam:                        model parameters
   #   dparam:                        derived model parameters
   #   state:                         model states at time "t" 
   #
   # Returns:
   #   List of fluxes at time "t"

   # set all fluxes to zero at the start of time step
   eff_ppt     <- satarea     <- qrunoff     <- evap_1a     <- evap_1b     <- evap_1      <- evap_2      <- rchr2excs   <- tens2free_1 <- tens2free_2 <- qintf_1     <- qperc_12    <- qbase_2     <- qbase_2a    <- qbase_2b    <- oflow_1     <- oflow_2     <- oflow_2a    <- oflow_2b    <- 0

   # compute effective rainfall
   eff_ppt   <- fluxrain(smodl$rferr,mppt,mparam$rferr_add,mparam$rferr_mlt)      
   
   # compute excess of saturation
   temp      <- fluxqsatexcess(smodl$qsurf,eff_ppt,mparam,dparam,state[["tens_1"]], state[["watr_1"]], state[["watr_2"]])
   satarea   <- temp[[1]]   # saturated area
   qrunoff   <- temp[[2]]   # surface runoff
   
   # compute evaporation
   temp      <- fluxevap(smodl$arch1,smodl$arch2,smodl$esoil,mpet,mparam,dparam,state[["tens_1a"]], state[["tens_1b"]], state[["tens_1"]], state[["tens_2"]])
   evap_1a   <- temp[[1]]
   evap_1b   <- temp[[2]]
   evap_1    <- temp[[3]]
   evap_2    <- temp[[4]]
   
   # compute interflow from free water in the upper layer
   if(smodl$qintf==72) qintf_1 <- mparam$iflwrte * (state[["free_1"]]/dparam$maxfree_1)
   if(smodl$qintf==71) qintf_1 <- 0
   
   # compute percolation from the upper to lower soil layers
   qperc_12 <- fluxperc(smodl$qperc,mparam,dparam,state[["free_1"]], state[["watr_1"]], state[["watr_2"]])
   
   # compute baseflow
   temp <- fluxbaseflow(smodl$arch2,mparam,dparam$qbsat,state[["free_2a"]], state[["free_2b"]], state[["watr_2"]])
   qbase_2a <- temp[[1]]
   qbase_2b <- temp[[2]]
   qbase_2  <- temp[[3]]
   
   # compute overflow (miscellaneous fluxes)
   temp <- fluxqmiscell(smodl$arch1,smodl$arch2,state,mparam,dparam,eff_ppt,qrunoff,qperc_12)
   rchr2excs   <- temp[[1]]
   tens2free_1 <- temp[[2]]
   tens2free_2 <- temp[[3]]
   oflow_1     <- temp[[4]]
   oflow_2     <- temp[[5]]
   oflow_2a    <- temp[[6]]
   oflow_2b    <- temp[[7]]
   
   flux1 <- list("eff_ppt"     = eff_ppt,
                 "satarea"     = satarea,
                 "qrunoff"     = qrunoff,
                 "evap_1a"     = evap_1a,
                 "evap_1b"     = evap_1b,
                 "evap_1"      = evap_1,
                 "evap_2"      = evap_2,
                 "rchr2excs"   = rchr2excs,
                 "tens2free_1" = tens2free_1,
                 "tens2free_2" = tens2free_2,
                 "qintf_1"     = qintf_1,
                 "qperc_12"    = qperc_12,
                 "qbase_2"     = qbase_2,
                 "qbase_2a"    = qbase_2a,
                 "qbase_2b"    = qbase_2b,
                 "oflow_1"     = oflow_1,
                 "oflow_2"     = oflow_2,
                 "oflow_2a"     = oflow_2a,
                 "oflow_2b"     = oflow_2b)

   return(flux1)

}

