qbsaturatn <- function(arch_2,mparam,maxfree_2a,maxfree_2b,powlamb) {
   # Computes baseflow at saturation (used in the sac percolation model)
   # Author: Claudia Vitolo
   #
   # Args:
   #   arch_2:                        architecture of upper soil layer
   #   mparam:                        list of model parameters
   #   maxfree_2a:                    model parameter (for a description see par_derive.R)
   #   maxfree_2b:                    model parameter (for a description see par_derive.R)
   #   powlamb:                       model parameter (for a description see par_derive.R)
   #
   # Returns:
   #   Baseflow at saturation.

   if(arch_2 == 31) qbsat <- mparam$baserte                                                 # baseflow reservoir of fixed size
   
   if(arch_2 == 32) qbsat <- mparam$qbrate_2a * maxfree_2a + mparam$qbrate_2b * maxfree_2b  # tension reservoir plus two parallel tanks
   
   if(arch_2 == 33) qbsat <- mparam$qb_prms * mparam$maxwatr_2                              # baseflow resvr of unlimited size
     
   if(arch_2 == 34) {                                                                       # topmodel power-law transmissivity profile
     # this is a bit tricky.  the capacity of the aquifer is m*n, where m is a scaling parameter.  
     # we have the capacity, i.e., maxwatr_2/1000., and need the topmodel "m" parameter
     topmdm <- (mparam$maxwatr_2 / 1000) / mparam$qb_powr
     qbsat  <- mparam$baserte * ( topmdm / (powlamb ** mparam$qb_powr) ) # compute baseflow
   }
   
   if(arch_2 == 35) {                                                                       # topmodel exponential transmissivity profile  
     topmdm <- mparam$maxwatr_2 / 1000                                   # for simplicity we use the capacity as the topmodel scaling parameter         
     qbsat  <- mparam$baserte * topmdm * exp(-mparam$loglamb)            # compute baseflow
   }
   
   return(qbsat)

}

