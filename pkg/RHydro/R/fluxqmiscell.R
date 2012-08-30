fluxqmiscell <- function(arch1,arch2,state,mparam,dparam,eff_ppt,qrunoff,qperc_12,x=1) {
   # Computes miscellaneous fluxes using 2 methods:
   # (x=1) OVERFLOW FLUXES AS A FRACTION OF INFLUXES
   # (x=2) OVERFLOW FLUXES COMPUTED AS A RESIDUAL OF AVAILABLE STORAGE
   # Author: Claudia Vitolo
   #
   # Args:
   #   arch1:                         architecture of the upper soil layer 
   #   arch2:                         architecture of the lower soil layer 
   #   state:                         model states at time "t" 
   #   mparam:                        model parameters
   #   dparam:                        derived model parameters
   #   eff_ppt:                       effective precipitation
   #   qrunoff:                       runoff
   #   qperc_12:                      percolation
   #
   # Returns:
   #   Overflow fluxes:
   #   rchr2excs   <- flow from recharge to excess (mm day-1)
   #   tens2free_1 <- flow from tension storage to free storage in the upper layer (mm day-1)
   #   tens2free_2 <- flow from tension storage to free storage in the lower layer (mm day-1)
   #   oflow_1     <- overflow from the upper soil layer (mm day-1)
   #   oflow_2     <- overflow from the lower soil layer (mm day-1)
   #   oflow_2a     <- overflow from the lower soil layer (mm day-1)
   #   oflow_2b     <- overflow from the lower soil layer (mm day-1)

   rchr2excs   <- 0
   tens2free_1 <- 0
   oflow_1     <- 0
   
   tens2free_2 <- 0
   oflow_2a    <- 0
   oflow_2b    <- 0
   oflow_2     <- 0
   
   switch(x,    
          
    { # (1) OVERFLOW FLUXES AS A FRACTION OF INFLUXES

      if(arch1 == 21) { # upper layer defined by a single state variable
         rchr2excs   <- 0
         tens2free_1 <- 0                                      # no tension stores
         w_func      <- logismooth(state[["watr_1"]],mparam$maxwatr_1)
         oflow_1     <- w_func * (eff_ppt - qrunoff)           # compute over-flow of free water
      }
   
      if(arch1 == 22) { # upper layer broken up into tension and free storage
         rchr2excs   <- 0                                      # no separate recharge zone (flux should never be used)
         w_func      <- logismooth(state[["tens_1"]],dparam$maxtens_1)
         tens2free_1 <- w_func * (eff_ppt - qrunoff)           # compute flow from tension storage to free storage (mm s-1)
         w_func      <- logismooth(state[["free_1"]],dparam$maxfree_1)
         oflow_1     <- w_func * tens2free_1                   # compute over-flow of free water
      }
   
      if(arch1 == 23) { # tension storage sub-divided into recharge and excess
         w_func      <- logismooth(state[["tens_1a"]],dparam$maxtens_1a)
         rchr2excs   <- w_func * (eff_ppt - qrunoff)           # compute flow from recharge to excess (mm s-1)
         w_func      <- logismooth(state[["tens_1b"]],dparam$maxtens_1b)
         tens2free_1 <- w_func * rchr2excs                     # compute flow from tension storage to free storage (mm s-1)
         w_func      <- logismooth(state[["free_1"]],dparam$maxfree_1)
         oflow_1     <- w_func * tens2free_1                   # compute over-flow of free water
      }

      if(arch2 == 31) {
         tens2free_2 <- 0                                       # no tension store
         oflow_2a    <- 0
         oflow_2b    <- 0
         w_func      <- logismooth(state[["watr_2"]],mparam$maxwatr_2)
         oflow_2     <- w_func * qperc_12                       # compute over-flow of free water
      }

      if(arch2 == 32) { # tension reservoir plus two parallel tanks
         w_func      <- logismooth(state[["tens_2"]],dparam$maxtens_2)
         tens2free_2 <- w_func * qperc_12*(1-mparam$percfrac)  # compute flow from tension storage to free storage (mm s-1)
         w_func      <- logismooth(state[["free_2a"]],dparam$maxfree_2a)
         oflow_2a    <- w_func * (qperc_12*(mparam$percfrac/2) + tens2free_2/2) # compute over-flow of free water in the primary reservoir
         w_func      <- logismooth(state[["free_2b"]],dparam$maxfree_2b)
         oflow_2b    <- w_func * (qperc_12*(mparam$percfrac/2) + tens2free_2/2) # compute over-flow of free water in the secondary reservoir
         oflow_2     <- oflow_2a + oflow_2b                                     # compute total overflow
      }

      if(arch2 == 33 || arch2 == 34 || arch2 == 35) { # unlimited size
         tens2free_2 <- 0
         oflow_2     <- 0
         oflow_2a    <- 0
         oflow_2b    <- 0
      }
    },
      
    {  # (2) OVERFLOW FLUXES COMPUTED AS A RESIDUAL OF AVAILABLE STORAGE
    if(arch1 == 21) {          # upper layer defined by a single state variable
       rchr2excs   <- 0
       tens2free_1 <- 0         # no tension stores
       oflow_1     <- max(0, (eff_ppt - qrunoff) - (mparam$maxwatr_1 - state[["watr_1"]])) # compute over-flow of free water
    }
   
    if(arch1 == 22) {          # upper layer broken up into tension and free storage
       rchr2excs   <- 0   # no separate recharge zone (flux should never be used)
       tens2free_1 <- max(0, (eff_ppt - qrunoff) - (dparam$maxtens_1 - state[["tens_1"]])) # compute flow from tension storage to free storage (mm s-1)
       oflow_1     <- max(0,  tens2free_1      - (dparam$maxfree_1 - state[["free_1"]]))   # compute over-flow of free water
    }
   
    if(arch1 == 23) {          # tension storage sub-divided into recharge and excess
       rchr2excs   <- max(0, (eff_ppt - qrunoff) - (dparam$maxtens_1a - state[["tens_1a"]])) # compute flow from recharge to excess (mm s-1)
       tens2free_1 <- max(0,  rchr2excs   - (dparam$maxtens_1b - state[["tens_1b"]]))        # compute flow from tension storage to free storage (mm s-1)
       oflow_1     <- max(0,  tens2free_1 - (dparam$maxfree_1  - state[["free_1"]]))         # compute over-flow of free water
    }

    if(arch2 == 31) {          # no tension store
       tens2free_2 <- 0
       oflow_2a    <- 0
       oflow_2b    <- 0
       oflow_2     <- max(0, qperc_12 - (mparam$maxwatr_2 - state[["watr_2"]])) # compute over-flow of free water
    }   
   
    if(arch2 == 32){           # tension reservoir plus two parallel tanks
       tens2free_2 <- max(0, qperc_12*(1-mparam$percfrac) - (dparam$maxtens_2  - state[["tens_2"]] ))                   # compute flow from tension storage to free storage (mm s-1)
       oflow_2a    <- max(0, (qperc_12*(mparam$percfrac/2) + tens2free_2/2) - (dparam$maxfree_2a - state[["free_2a"]])) # compute over-flow of free water in the primary reservoir
       oflow_2b    <- max(0, (qperc_12*(mparam$percfrac/2) + tens2free_2/2) - (dparam$maxfree_2b - state[["free_2b"]])) # compute over-flow of free water in the secondary reservoir
       oflow_2     <- oflow_2a + oflow_2b   # compute total overflow
    }

    if(arch2 == 33 || arch2 == 34 || arch2==35) { # unlimited size
       tens2free_2 <- 0
       oflow_2     <- 0
       oflow_2a    <- 0
       oflow_2b    <- 0
    } 
  })

   results <- c(rchr2excs,tens2free_1,tens2free_2,oflow_1,oflow_2,oflow_2a,oflow_2b)

   return(results)

}

