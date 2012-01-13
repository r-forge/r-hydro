upstates <- function(smodl,mparam,dparam,state) {

  xmin <- 1e-06
  
#   tens_1a <- state[[1]]
#   tens_1b <- state[[2]]
#   tens_1  <- state[[3]]
#   free_1  <- state[[4]]
#   watr_1  <- state[[5]]
#   tens_2  <- state[[6]]
#   free_2a <- state[[7]]
#   free_2b <- state[[8]]
#   watr_2  <- state[[9]]
#   free_2  <- state[[10]]
  
if (smodl$arch1 == 21) {
  # case('onestate_1') # upper layer defined by a single state variable
  free_1  <- max(xmin, state[[5]] - dparam$maxtens_1) # free storage
  tens_1a <- -999                                     # 1st tension store (undefined)
  tens_1b <- -999                                     # 2nd tension store (undefined)
  tens_1  <- min(state[[5]]-free_1, dparam$maxtens_1) # tension storage
  watr_1  <- state[[5]]
}
  
if (smodl$arch1 == 22) {
  # case('tension1_1') # upper layer broken up into tension and free storage
  tens_1a <- -999                              # 1st tension store (undefined)
  tens_1b <- -999                              # 2nd tension store (undefined)
  tens_1  <- state[[3]]                         # tension storage
  free_1  <- state[[4]]                         # free storage
  watr_1  <- tens_1 + free_1                   # total storage
}
  
if (smodl$arch1 == 23) {
  # case('tension2_1') # tension storage sub-divided into recharge and excess
  tens_1a <- state[[1]]
  tens_1b <- state[[2]]
  tens_1  <- tens_1a + tens_1b           # tension storage
  free_1  <- state[[4]]
  watr_1  <- tens_1  + free_1            # total storage
}

# ---------------------------------------------------------------------------------------
if (smodl$arch2 == 32) {  # (lower layer architecture)
  #case('tens2pll_2') # tension reservoir plus two parallel tanks
  free_2a <- state[[7]]
  free_2b <- state[[8]]
  free_2  <- free_2a + free_2b              # free storage
  tens_2  <- state[[6]]
  watr_2  <- tens_2 + free_2                # total storage
}
  
if(smodl$arch2 == 31 || smodl$arch2 == 33 || smodl$arch2 == 34 || smodl$arch2 == 35) { # single baseflow reservoir
  free_2a <- -999                                                                      # primary reservoir (undefined)
  free_2b <- -999                                                                      # secondary reservoir (undefined)
  free_2  <- max(xmin, state[[9]] - dparam$maxtens_2)                                     # free storage
  tens_2  <- min(state[[6]]-free_2, dparam$maxtens_2)                                  # tension storage
  watr_2  <- tens_2  + free_2
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
