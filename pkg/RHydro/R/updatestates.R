updatestates <- function(smodl,mparam,dparam,state1) {

  xmin <- 1e-06
  
#   tens_1a <- state1[,2]
#   tens_1b <- state1[,3]
#   tens_1  <- state1[,4]
#   free_1  <- state1[,5]
#   watr_1  <- state1[,6]
#   tens_2  <- state1[,7]
#   free_2a <- state1[,8]
#   free_2b <- state1[,9]
#   watr_2  <- state1[,10]
#   free_2  <- state1[,11]

state2 <- state1
  
for (r in 1:length(state1[,1])) {
  
if (smodl$arch1 == 21) {
  # case('onestate_1') # upper layer defined by a single state variable
  tens_1a <- -999                               # 1st tension store (undefined)
  tens_1b <- -999                               # 2nd tension store (undefined)
  tens_1  <- min(state1[r,6], dparam$maxtens_1)        # tension storage
  free_1  <- max(xmin, state1[r,6] - dparam$maxtens_1) # free storage
  watr_1  <- state1[r,6]
}
if (smodl$arch1 == 22) {
  # case('tension1_1') # upper layer broken up into tension and free storage
  tens_1a <- -999                              # 1st tension store (undefined)
  tens_1b <- -999                              # 2nd tension store (undefined)
  tens_1  <- state1[r,4]
  free_1  <- state1[r,5]
  watr_1  <- tens_1 + free_1             # total storage
}
if (smodl$arch1 == 23) {
  # case('tension2_1') # tension storage sub-divided into recharge and excess
  tens_1a <- state1[r,2]
  tens_1b <- state1[r,3]
  tens_1  <- tens_1a + tens_1b           # tension storage
  free_1  <- state1[r,5]
  watr_1  <- tens_1  + free_1            # total storage
}

# ---------------------------------------------------------------------------------------
if (smodl$arch2 == 32) {  # (lower layer architecture)
  #case('tens2pll_2') # tension reservoir plus two parallel tanks
  free_2a <- state1[r,8]
  free_2b <- state1[r,9]
  free_2  <- free_2a + free_2b              # free storage
  tens_2  <- state1[r,7]
  watr_2  <- tens_2 + free_2                # total storage
}
if(smodl$arch2 == 31 || smodl$arch2 == 33 || smodl$arch2 == 34 || smodl$arch2 == 35) { # single baseflow reservoir
  free_2a <- -999                                       # primary reservoir (undefined)
  free_2b <- -999                                       # secondary reservoir (undefined)
  free_2  <- max(0, state1[r,10] - dparam$maxtens_2)     # free storage
  tens_2  <- min(state1[r,10], dparam$maxtens_2)         # tension storage
  watr_2  <- tens_2  + free_2
}
  
  state2[r,2:11] <- c(tens_1a,tens_1b,tens_1,free_1,watr_1,tens_2,free_2a,free_2b,watr_2,free_2)
}
  
  return(state2)
}
