initstates <- function(smodl,mparam,dparam,fracstate0) {

  xmin <- 1e-06
  
  # initialize model states (upper layer and lower layer)
  tens_1a <- -999
  tens_1b <- -999
  tens_1  <- -999
  free_1  <- -999
  watr_1  <- -999
  tens_2  <- -999
  free_2a <- -999
  free_2b <- -999
  watr_2  <- -999
  free_2  <- -999

  if (mparam$maxwatr_1 != -999) watr_1  <- mparam$maxwatr_1  * fracstate0
  if (smodl$arch1 != 21) {
      free_1  <- dparam$maxfree_1  * fracstate0
  }else{
      free_1  <- xmin
  }
  if (dparam$maxtens_1a != -999) tens_1a <- dparam$maxtens_1a * fracstate0
  if (dparam$maxtens_1b != -999) tens_1b <- dparam$maxtens_1b * fracstate0
  if (dparam$maxtens_1  != -999) tens_1  <- watr_1 - free_1
  #if (tens_1 != tens_1a + tens_1b) print("WARNING: tens_1 != tens_1a + tens_1b")

  if (dparam$maxfree_2a != -999) free_2a <- dparam$maxfree_2a * fracstate0
  if (dparam$maxfree_2b != -999) free_2b <- dparam$maxfree_2b * fracstate0 
  if (smodl$arch2 == 32) {
    free_2  <- free_2a + free_2b
  }else{
    free_2  <- xmin
  }
  if (mparam$maxwatr_2  != -999) watr_2  <- mparam$maxwatr_2 * fracstate0
  if (dparam$maxtens_2  != -999) tens_2  <- watr_2 - free_2
  
  state0    <- c("tens_1a" = tens_1a,
                 "tens_1b" = tens_1b,
                 "tens_1"  = tens_1,
                 "free_1"  = free_1,
                 "watr_1"  = watr_1,
                 "tens_2"  = tens_2,
                 "free_2a" = free_2a,
                 "free_2b" = free_2b,
                 "watr_2"  = watr_2,
                 "free_2"  = free_2  )
  
  return(state0)
}
