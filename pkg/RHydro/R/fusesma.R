## hydromad: Hydrological Modelling and Analysis of Data
## FUSE Soil Moisture Accounting model
# Author: Claudia Vitolo
# Date: 14-11-2011
                 
fusesma.sim <- function(DATA,mid,modlist,
                        deltim=1,fracstate0=0.25,rferr_add=0,rferr_mlt=1,
                        frchzne,fracten,maxwatr_1,percfrac,fprimqb,qbrate_2a,qbrate_2b,
                        qb_prms,maxwatr_2,baserte,rtfrac1,percrte,percexp,sacpmlt,
                        sacpexp,iflwrte,axv_bexp,sareamax,loglamb,tishape,qb_powr)
{    
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
       
    # All the model parameters [LIST]
    mparam0 <- list("rferr_add" = rferr_add,
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
                    "qb_powr"   = qb_powr #,
                    ##"timedelay" = timedelay
                    )
    
    # Isolate model parameters to use for this run [LIST]
    mparam <- assign_par(smodl, mparam0)
    
    # compute derived parameters (bucket sizes, etc.) [LIST]
    dparam <- par_derive(smodl,mparam)                 
    
    # initialize model states (upper layer and lower layer) 
    state0 <- initstates(smodl,mparam,dparam,fracstate0)    
    
    # Solve derivatives
    times      <- seq(1, length(P), by = 1) # by = 1 means that solver timestep = data timestep

    parameters <- c("deltim" = deltim) # standard deltim = 1 (daily time step), 1/24 (hourly time step), 1/24/4 (15 min time step)
    
    print("computing state variables ...")
    # the solver returns a matrix nrows x ncols
    # ncols = 11 (time, tens_1a, tens_1b,  tens_1,  free_1,  watr_1,  tens_2, free_2a, free_2b,  watr_2, free_2)
    # nrows = length(P)
    state1 <- ode("y" = state0, 
                  "times" = times, 
                  "func" = mstate_eqn, 
                  "parms" = deltim, 
                  "ppt" = P, 
                  "pet" = E, 
                  "smodl" = smodl, 
                  "mparam" = mparam, 
                  "dparam" = dparam)  #default: method="rk"
    
    #Update fluxes
    state1 <- updatestates(smodl,mparam,dparam,state1)
    
    print("computing fluxes ...")
    U <- rep(0,length(P)) 
    fluxes <- matrix(0,nrow=length(P),ncol=17)                         # to output fluxes
    for (index in seq(along = P)) { 
     w_flux   <- compute_fluxes(deltim,smodl,P[index],E[index],mparam,dparam,state1[index,2:11])
     for (cindex in 1:17)  fluxes[index,cindex] <- w_flux[[cindex]]    # to output fluxes
     # compute effective rainfall (sum of surface runoff, overflow, interflow, and baseflow)
     U[index] <- w_flux$qrunoff + w_flux$oflow_1 + w_flux$qintf_1 + w_flux$oflow_2 + w_flux$qbase_2
    }
    
    #print("converting effective rainfall into zoo object ...")
    # make it a time series object again
    #attributes(U) <- attributes(P)
    # re-insert missing values
    #U[bad] <- NA
    return(U)
}


fusesma.ranges <- function() {
    list("rferr_add" = c(0, 0),
         "rferr_mlt" = c(1, 1),
         "frchzne"   = c(0.05, 0.95),
         "fracten"   = c(0.05, 0.95),
         "maxwatr_1" = c(25, 500),
         "percfrac"  = c(0.05, 0.95),
         "fprimqb"   = c(0.05, 0.95),
         "qbrate_2a" = c(0.001, 0.25),
         "qbrate_2b" = c(0.001, 0.25),
         "qb_prms"   = c(0.001, 0.25),
         "maxwatr_2" = c(50, 5000),
         "baserte"   = c(0.001, 1000),
         "rtfrac1"   = c(0.05, 0.95),
         "percrte"   = c(0.01, 1000),
         "percexp"   = c(1, 20),
         "sacpmlt"   = c(1, 250),
         "sacpexp"   = c(1, 5),
         "iflwrte"   = c(0.01, 1000),
         "axv_bexp"  = c(0.001, 3),
         "sareamax"  = c(0.05, 0.95),
         "loglamb"   = c(5, 10),
         "tishape"   = c(2, 5),
         "qb_powr"   = c(1, 10))

}
