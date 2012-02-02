initstates <- function(smodl,mparam,dparam,fracstate0) {
   # Initialize model states (upper layer and lower layer) 
   # Author: Claudia Vitolo
   #
   # Args:
   #   smodl:      model structure
   #   mparam:     initial model parameters
   #   dparam:     derived model parameters
   #   fracstate0: arbitrary value to set initial state variables (default = 0.25)
   #
   # Returns:
   #   Initial condition for state variables

   xmin <- 0 # 1e-06
  
   # initialize model states (upper layer and lower layer)
   tens_1a <- -999   # Excess Tension storage Upper Layer
   tens_1b <- -999   # Recharge Tension storage Upper Layer
   tens_1  <- -999   # Tension storage Upper Layer
   free_1  <- -999   # Free storage Upper Layer
   watr_1  <- -999   # Total Upper Layer Storage
   tens_2  <- -999   # Tension storage Lower Layer
   free_2a <- -999   # Free Storage Primary Baseflow Reservoir
   free_2b <- -999   # Free Storage Secondary Baseflow Reservoir
   watr_2  <- -999   # Total Lower Layer Storage
   free_2  <- -999   # Free Storage Baseflow Reservoir
   
   # UPPER LAYER*****************************************************************   
   if (smodl$arch1 == 21) {         # single state
       watr_1  <- mparam$maxwatr_1  * fracstate0
       free_1  <- xmin
       tens_1  <- watr_1 - free_1
   }else{                           # upper layer broken up into multpiple storages
       free_1  <- dparam$maxfree_1  * fracstate0
       tens_1a <- dparam$maxtens_1a * fracstate0
       tens_1b <- dparam$maxtens_1b * fracstate0
       tens_1  <- tens_1a - tens_1b
       watr_1  <- free_1 + tens_1
   }

   # LOWER LAYER******************************************************************    
   if (smodl$arch2 == 32) {          # tension reservoir plus two parallel tanks
     free_2a <- dparam$maxfree_2a * fracstate0
     free_2b <- dparam$maxfree_2b * fracstate0
     free_2  <- free_2a + free_2b
     watr_2  <- mparam$maxwatr_2 * fracstate0
     tens_2  <- watr_2 - free_2
   }else{                            # single state
     watr_2  <- mparam$maxwatr_2 * fracstate0
     free_2  <- xmin
     tens_2  <- watr_2 - free_2
   }
  
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
