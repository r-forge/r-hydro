## FUSE Soil Moisture Accounting model
# Author: Claudia Vitolo
#
# Args:
#   DATA:                          matrix containing 3 columns called: P (precipitation), E (potential evapotranspiration) and Q (observed streamflow discharge, optional)
#   mid:                           model id 
#   modlist:                       list of model structures ordered by model id
#   states:                        boolean. If states=TRUE, the output contains the list of state variables
#   fluxes:                        boolean. If fluxes=TRUE, the output contains the list of fluxes (last element of the list is U)
#   fracstate...qb_powr:           model parameters (collected as mparam)
#
# Returns:
#   U:                             Instantaneous runoff      
#   s:                             (optional) list of state variables 
#   f:                             (optional) list of fluxes (containing also U)

fusesma.sim <- function(DATA,mid,modlist,deltim,states=FALSE,fluxes=FALSE,
                        fracstate0=0.25,rferr_add=0,rferr_mlt=1,
                        frchzne,fracten,maxwatr_1,percfrac,fprimqb,qbrate_2a,qbrate_2b,
                        qb_prms,maxwatr_2,baserte,rtfrac1,percrte,percexp,sacpmlt,
                        sacpexp,iflwrte,axv_bexp,sareamax,loglamb,tishape,qb_powr) {              
    DATA                        
    stopifnot(c("P","E") %in% colnames(DATA))
    P <- DATA[,"P"]
    E <- DATA[,"E"]
    ## skip over missing values
    #bad <- is.na(P) | is.na(E)
    #P[bad] <- 0
    #E[bad] <- 0
    
    # Read model structure [LIST]
    smodl <- list("rferr"=modlist[mid,2],
                "arch1"=modlist[mid,3],
                "arch2"=modlist[mid,4],
                "qsurf"=modlist[mid,5],
                "qperc"=modlist[mid,6],
                "esoil"=modlist[mid,7],
                "qintf"=modlist[mid,8],
                "q_tdh"=modlist[mid,9])
       
    # All model parameters [LIST]
    mparam <- list("rferr_add" = rferr_add,
                    "rferr_mlt" = rferr_mlt,
                    "frchzne"   = frchzne,
                    "fracten"   = fracten,
                    "maxwatr_1" = maxwatr_1,
                    "percfrac"  = percfrac,
                    "fprimqb"   = fprimqb,
                    "qbrate_2a" = qbrate_2a,
                    "qbrate_2b" = qbrate_2b,
                    "qb_prms"   = qb_prms,
                    "maxwatr_2" = maxwatr_2,
                    "baserte"   = baserte,
                    "rtfrac1"   = rtfrac1,
                    "percrte"   = percrte,
                    "percexp"   = percexp,
                    "sacpmlt"   = sacpmlt,
                    "sacpexp"   = sacpexp,
                    "iflwrte"   = iflwrte,
                    "axv_bexp"  = axv_bexp,
                    "sareamax"  = sareamax,
                    "loglamb"   = loglamb,
                    "tishape"   = tishape,
                    "qb_powr"   = qb_powr 
                    )
    
    # compute derived parameters (bucket sizes, etc.) [LIST]
    dparam <- par_derive(smodl,mparam)                 
    
    # initialize model states (upper layer and lower layer) 
    state0 <- initstates(smodl,mparam,dparam,fracstate0)    
    
    # Solve derivatives
    times      <- seq(1, length(P), by = 1) 

    parameters <- list("mparam" = mparam,"dparam" = dparam) 
    
    print("computing state variables ...")
    state1 <- ode("y" = state0, 
                  "times" = times, 
                  "func" = mstate_eqn, 
                  "parms" = parameters, 
                  "ppt" = P, 
                  "pet" = E, 
                  "smodl" = smodl, 
                  "deltim" = deltim,
                  atol = 1e-3, rtol = 1e-3)

    state2 <- data.frame("tens_1a" = state1[,"states.tens_1a"],
                "tens_1b" = state1[,"states.tens_1b"],
                "tens_1"  = state1[,"states.tens_1"],
                "free_1"  = state1[,"states.free_1"],
                "watr_1"  = state1[,"states.watr_1"],
                "tens_2"  = state1[,"states.tens_2"],
                "free_2a" = state1[,"states.free_2a"],
                "free_2b" = state1[,"states.free_2b"],
                "watr_2"  = state1[,"states.watr_2"],
                "free_2"  = state1[,"states.free_2"]  )

    print("computing fluxes ...")
    allfluxes <- outfluxes(smodl,P,E,mparam,dparam,state2)
    
    # print("converting effective rainfall into zoo object ...")
    # make it a time series object again
    # attributes(U) <- attributes(P)
    # re-insert missing values
    # U[bad] <- NA

    if (states == FALSE && fluxes == FALSE) results <- allfluxes$U
    if (states == TRUE  && fluxes == FALSE) results <- list("s"=state2,"U"=allfluxes$U)
    if (states == FALSE && fluxes == TRUE)  results <- allfluxes
    if (states == TRUE  && fluxes == TRUE)  results <- list("s"=state2,"f"=allfluxes)

    return(results)
}

fusesma.ranges <- function() {
    list("rferr_add" = c(0, 0),                      # additive rainfall error (mm)
         "rferr_mlt" = c(1, 1),                      # multiplicative rainfall error (-)
         "maxwatr_1" = c(25, 500),                   # depth of the upper soil layer (mm)
         "maxwatr_2" = c(50, 5000),                  # depth of the lower soil layer (mm)
         "fracten"   = c(0.05, 0.95),                # fraction total storage in tension storage (-)
         "frchzne"   = c(0.05, 0.95),                # fraction tension storage in recharge zone (-)
         "fprimqb"   = c(0.05, 0.95),                # fraction storage in 1st baseflow reservoir (-)
         "rtfrac1"   = c(0.05, 0.95),                # fraction of roots in the upper layer (-)
         "percrte"   = c(0.01, 1000),                # percolation rate (mm day-1)                           
         "percexp"   = c(1, 20),                     # percolation exponent (-)
         "sacpmlt"   = c(1, 250),                    # SAC model percltn mult for dry soil layer (-)
         "sacpexp"   = c(1, 5),                      # SAC model percltn exp for dry soil layer (-)
         "percfrac"  = c(0.05, 0.95),                # fraction of percltn to tension storage (-)
         "iflwrte"   = c(0.01, 1000),                # interflow rate (mm day-1)                              
         "baserte"   = c(0.001, 1000),               # baseflow rate (mm day-1)                               
         "qb_powr"   = c(1, 10),                     # baseflow exponent (-)
         "qb_prms"   = c(0.001, 0.25),               # baseflow depletion rate (day-1)                        
         "qbrate_2a" = c(0.001, 0.25),               # baseflow depletion rate 1st reservoir (day-1)          
         "qbrate_2b" = c(0.001, 0.25),               # baseflow depletion rate 2nd reservoir (day-1)          
         "sareamax"  = c(0.05, 0.95),                # maximum saturated area (-)
         "axv_bexp"  = c(0.001, 3),                  # ARNO/VIC "b" exponent (-)
         "loglamb"   = c(5, 10),                     # mean value of the topographic index (m)
         "tishape"   = c(2, 5))                      # shape param for the topo index Gamma dist (-) 
         #"timedelay" = c(0.01, 5),                  # time delay in runoff (days) ---> moved to "fuserouting.R"
                
}

