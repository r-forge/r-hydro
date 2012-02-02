mstate_eqn <- function(t, state, parameters, ppt, pet, smodl, mparam, dparam)     {
   # Model's Differential Equations
   # Author: Claudia Vitolo
   #
   # Args:
   #   t:                             time
   #   state:                         model states at time "t" 
   #   parameters:                    parameters for differential equations
   #   ppt:                           rain+snow melt time series 
   #   pet:                           potential evapotranspiration time series
   #   smodl:                         list of model components
   #   mparam:                        model parameters
   #   dparam:                        derived model parameters
   #
   # Returns:
   #   List of parameters.
  
   deltim <- as.numeric(parameters[1])
  
   # compute fluxes:
   mppt   <- as.numeric(ppt[t])
   mpet   <- as.numeric(pet[t])
   state  <- upstates(smodl,mparam,dparam,state)
   m_flux <- compute_fluxes(deltim,smodl,mppt,mpet,mparam,dparam,state)

   # computes derivatives (rate of change) of all states for all model combinations
   dtens_1a <- 0
   dtens_1b <- 0
   dfree_1  <- 0
   dtens_1  <- 0
   dwatr_1  <- 0
   dtens_2  <- 0
   dfree_2a <- 0
   dfree_2b <- 0
   dwatr_2  <- 0
   dfree_2  <- 0

   # compute derivatives for states in the upper layer*********************************************************************
  # upper layer defined by a single state variable
   if(smodl$arch1 == 21) {                       
     dwatr_1  <- m_flux$eff_ppt    - m_flux$qrunoff    - m_flux$evap_1  - m_flux$qperc_12 - m_flux$qintf_1 - m_flux$oflow_1
     if (state[["tens_1"]] == dparam$maxtens_1){
       dtens_1  <- 0
       dfree_1  <- dwatr_1
     }else{
       dtens_1  <- dwatr_1
       dfree_1  <- 0
     }
   }
   # upper layer broken up into tension and free storage
   if(smodl$arch1 == 22) {                        
     dtens_1  <- m_flux$eff_ppt     - m_flux$qrunoff    - m_flux$evap_1  - m_flux$tens2free_1
     dfree_1  <- m_flux$tens2free_1 - m_flux$qperc_12 - m_flux$qintf_1 - m_flux$oflow_1
     dwatr_1  <- dtens_1 + dfree_1
   }
   # tension storage sub-divided into recharge and excess
   if(smodl$arch1 == 23) {                        
     dtens_1a <- m_flux$eff_ppt     - m_flux$qrunoff  - m_flux$evap_1a     - m_flux$rchr2excs
     dtens_1b <- m_flux$rchr2excs   - m_flux$evap_1b  - m_flux$tens2free_1
     dfree_1  <- m_flux$tens2free_1 - m_flux$qperc_12 - m_flux$qintf_1     - m_flux$oflow_1
     dtens_1  <- dtens_1a + dtens_1b
     dwatr_1  <- dtens_1  + dfree_1
   }

   # compute derivatives for states in the lower layer************************************************************
   # single state
   if(smodl$arch2 == 31 || smodl$arch2 == 33 || smodl$arch2 == 34 || smodl$arch2 == 35) { 
     dwatr_2  <- m_flux$qperc_12 - m_flux$evap_2 - m_flux$qbase_2 - m_flux$oflow_2
     if (state[["tens_2"]] == dparam$maxtens_2){
       dtens_2  <- 0
       dfree_2  <- dwatr_2
     }else{
       dtens_2  <- dwatr_2
       dfree_2  <- 0
     }
   }
   # tension reservoir plus two parallel tanks
   if(smodl$arch2 == 32) {                        
     dtens_2  <- m_flux$qperc_12*(1-mparam$percfrac) - m_flux$evap_2        - m_flux$tens2free_2
     dfree_2a <- m_flux$qperc_12*(mparam$percfrac/2) + m_flux$tens2free_2/2 - m_flux$qbase_2a    - m_flux$oflow_2a
     dfree_2b <- m_flux$qperc_12*(mparam$percfrac/2) + m_flux$tens2free_2/2 - m_flux$qbase_2b    - m_flux$oflow_2b
     dfree_2  <- dfree_2a + dfree_2b
     dwatr_2  <- dtens_2  + dfree_2
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
                 "dfree_2"  = dfree_2   )))
                 
}

