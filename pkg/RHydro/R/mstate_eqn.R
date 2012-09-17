mstate_eqn <- function(t, state, parameters, ppt, pet, smodl)     {
   # Model's Differential Equations
   # Author: Claudia Vitolo
   #
   # Args:
   #   t:                             time
   #   state:                         model states at time "t" 
   #   parameters:                    parameters for differential equations: model parameters + derived model parameters
   #   ppt:                           rain+snow melt time series 
   #   pet:                           potential evapotranspiration time series
   #   smodl:                         list of model components
   #
   # Returns:
   #   List of parameters.

   #print(t)   

   mparam <- parameters$mparam
   dparam <- parameters$dparam
   
   # compute fluxes:
   mppt   <- as.numeric(ppt[t])
   mpet   <- as.numeric(pet[t])
   state  <- upstates(smodl,mparam,dparam,state)
   m_flux <- compute_fluxes(smodl,mppt,mpet,mparam,dparam,state)

   # initialize derivatives (rate of change) of all states
   dtens_1a <- dtens_1b <- dfree_1  <- dtens_1  <- dwatr_1  <- dtens_2  <- dfree_2a <- dfree_2b <- dwatr_2  <- dfree_2  <- 0

   # compute derivatives for states in the upper layer*********************************************************************
   # upper layer defined by a single state variable
   if(smodl$arch1 == 21) {                       
     dwatr_1  <- m_flux$eff_ppt    - m_flux$qrunoff    - m_flux$evap_1  - m_flux$qperc_12 - m_flux$qintf_1 - m_flux$oflow_1
   }
   # upper layer broken up into tension and free storage
   if(smodl$arch1 == 22) {                        
     dtens_1  <- m_flux$eff_ppt     - m_flux$qrunoff    - m_flux$evap_1  - m_flux$tens2free_1
     dfree_1  <- m_flux$tens2free_1 - m_flux$qperc_12 - m_flux$qintf_1 - m_flux$oflow_1
     #dwatr_1  <- dtens_1 + dfree_1
   }
   # tension storage sub-divided into recharge and excess
   if(smodl$arch1 == 23) {                        
     dtens_1a <- m_flux$eff_ppt     - m_flux$qrunoff  - m_flux$evap_1a     - m_flux$rchr2excs
     dtens_1b <- m_flux$rchr2excs   - m_flux$evap_1b  - m_flux$tens2free_1
     dfree_1  <- m_flux$tens2free_1 - m_flux$qperc_12 - m_flux$qintf_1     - m_flux$oflow_1
     #dtens_1  <- dtens_1a + dtens_1b
     #dwatr_1  <- dtens_1  + dfree_1
   }

   # compute derivatives for states in the lower layer************************************************************
   # single state
   if(smodl$arch2 == 31 || smodl$arch2 == 33 || smodl$arch2 == 34 || smodl$arch2 == 35) { 
     dwatr_2  <- m_flux$qperc_12 - m_flux$evap_2 - m_flux$qbase_2 - m_flux$oflow_2
   }
   # tension reservoir plus two parallel tanks
   if(smodl$arch2 == 32) {                      
     dtens_2  <- m_flux$qperc_12*(1-mparam$percfrac) - m_flux$evap_2        - m_flux$tens2free_2
     dfree_2a <- m_flux$qperc_12*(mparam$percfrac/2) + m_flux$tens2free_2/2 - m_flux$qbase_2a    - m_flux$oflow_2a
     dfree_2b <- m_flux$qperc_12*(mparam$percfrac/2) + m_flux$tens2free_2/2 - m_flux$qbase_2b    - m_flux$oflow_2b
     #dfree_2  <- dfree_2a + dfree_2b
     #dwatr_2  <- dtens_2  + dfree_2
   }
   
   return(list(c("dtens_1a" = dtens_1a, 
                 "dtens_1b" = dtens_1b, 
                 "dtens_1"  = dtens_1, 
                 "dfree_1"  = dfree_1, 
                 "dwatr_1"  = dwatr_1, 
                 "dtens_2"  = dtens_2, 
                 "dfree_2a" = dfree_2a, 
                 "dfree_2b" = dfree_2b, 
                 "dwatr_2"  = dwatr_2,
                 "dfree_2"  = dfree_2   ),"states"= state ))
                 
}

