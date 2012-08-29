upstates <- function(smodl,mparam,dparam,state) {
   # Update the state variables "while" solving the differential equations
   # Author: Claudia Vitolo
   #
   # Args:
   #   smodl:                         list of model components
   #   mparam:                        model parameters
   #   dparam:                        derived model parameters
   #   state:                         state variables
   #
   # Returns:
   #   State variables updated
   
   xmin <- 1e-06
   
   # UPPER LAYER------------------------------------------------------------------------
   if (smodl$arch1 == 21) {
     # case('onestate_1'): upper layer defined by a single state variable
     # (update state)
     watr_1  <- max(xmin*mparam$maxwatr_1,state[["watr_1"]])    # total storage
     # (derive state)
     free_1  <- max(xmin, state[["watr_1"]] - dparam$maxtens_1) # free storage
     tens_1a <- -999                                            # 1st tension store (undefined)
     tens_1b <- -999                                            # 2nd tension store (undefined)
     tens_1  <- min(state[["watr_1"]], dparam$maxtens_1) # tension storage 
   }
     
   if (smodl$arch1 == 22) {
     # case('tension1_1'): upper layer broken up into tension and free storage
     # (update state)
     tens_1  <- max(xmin*dparam$maxtens_1,state[["tens_1"]])    # tension storage
     free_1  <- max(xmin*dparam$maxfree_1,state[["free_1"]])    # free storage
     # (derive state)
     tens_1a <- -999                              # 1st tension store (undefined)
     tens_1b <- -999                              # 2nd tension store (undefined)
     watr_1  <- tens_1 + free_1                   # total storage
   }
     
   if (smodl$arch1 == 23) {
     # case('tension2_1') # tension storage sub-divided into recharge and excess
     # (update state)
     tens_1a <- max(xmin*dparam$maxtens_1a,state[["tens_1a"]])         # 1st tension store
     tens_1b <- max(xmin*dparam$maxtens_1b,state[["tens_1b"]])         # 2nd tension store
     free_1  <- max(xmin*dparam$maxfree_1,state[["free_1"]])           # free storage
     # (derive state)
     tens_1  <- tens_1a + tens_1b           # tension storage
     watr_1  <- tens_1  + free_1            # total storage
   }
   
   # LOWER LAYER------------------------------------------------------------------------
   if(smodl$arch2 == 31 || smodl$arch2 == 33 || smodl$arch2 == 34 || smodl$arch2 == 35) {
     #case('unlimfrc_2','unlimpow_2','topmdexp_2','fixedsiz_2') single baseflow reservoir
     # (update state)
     if (smodl$arch2 == 35) {
       watr_2  <- state[["watr_2"]]                             # total storage
     }else{
       watr_2  <- max(xmin*mparam$maxwatr_2,state[["watr_2"]])  # total storage
     }     
     # (derive state)
     free_2a <- -999                                            # primary reservoir (undefined)
     free_2b <- -999                                            # secondary reservoir (undefined)
     free_2  <- max(0, state[["watr_2"]] - dparam$maxtens_2)    # free storage
     tens_2  <- min(state[["watr_2"]]-free_2, dparam$maxtens_2) # tension storage                                                         
   }
   
   if (smodl$arch2 == 32) {  
     #case('tens2pll_2') # tension reservoir plus two parallel tanks
     # (update state)
     free_2a <- max(xmin*dparam$maxfree_2a,state[["free_2a"]])  # primary reservoir
     free_2b <- max(xmin*dparam$maxfree_2b,state[["free_2b"]])  # secondary reservoir 
     tens_2  <- max(xmin*dparam$maxtens_2,state[["tens_2"]])   # tension storage
     # (derive state)
     free_2  <- free_2a + free_2b              # free storage
     watr_2  <- tens_2 + free_2                # total storage
   }
     
     state_new <- c("tens_1a" = tens_1a,
                    "tens_1b" = tens_1b,
                    "tens_1"  = tens_1,
                    "free_1"  = free_1,
                    "watr_1"  = watr_1,
                    "tens_2"  = tens_2,
                    "free_2a" = free_2a,
                    "free_2b" = free_2b,
                    "watr_2"  = watr_2,
                    "free_2"  = free_2  )
     
   return(state_new)
}

