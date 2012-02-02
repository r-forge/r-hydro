fluxbaseflow <- function(arch2,mparam,qbsat,free_2a, free_2b, watr_2) {
   # Compute baseflow from the lower soil layer
   # Author: Claudia Vitolo
   #
   # Args:
   #   arch2:         smodl$arch2
   #   mparam:        useful model parameters
   #   qbsat:         dparam$qbsat
   #   free_2a:       Free Storage Primary Baseflow Reservoir
   #   free_2b:       Free Storage Secondary Baseflow Reservoir
   #   watr_2:        Total Storage Lower Layer
   #
   # Returns:
   #   Baseflow
   
   qbase_2a  <- 0
   qbase_2b  <- 0
   qbase_2   <- 0
   
   # baseflow reservoir of fixed size
   if(arch2 == 31) qbase_2  <- mparam$baserte * (watr_2/mparam$maxwatr_2) ^ mparam$qb_powr 
   
   # tension reservoir plus two parallel tanks
   if(arch2 == 32) {  
      qbase_2a <- mparam$qbrate_2a * free_2a    # qbrate_2a is a fraction (t-1)
      qbase_2b <- mparam$qbrate_2b * free_2b    # qbrate_2b is a fraction (t-1)
      qbase_2  <- qbase_2a + qbase_2b           # total baseflow
   }
   
   # baseflow resvr of unlimited size (0-huge), frac rate # qb_prms is a fraction (t-1)
   if(arch2 == 33) qbase_2  <- mparam$qb_prms * watr_2 
   
   # baseflow resvr of unlimited size (0-huge), power recession
   if(arch2 == 34) qbase_2  <- qbsat * (watr_2/mparam$maxwatr_2)^mparam$qb_powr       
   
   # topmodel exponential reservoir (-huge to huge)
   if(arch2 == 35) qbase_2  <- qbsat * exp( -(1 - watr_2/mparam$maxwatr_2) )              

   results <- c(qbase_2a,qbase_2b,qbase_2)

   return(results)

}

