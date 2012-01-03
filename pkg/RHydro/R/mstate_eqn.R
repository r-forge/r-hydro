mstate_eqn <- function(t, state, parameters, ppt, pet, smodl, mparam, dparam)     {
   # Model's Differential Equations
   # Author: Claudia Vitolo
   # Date: 24-11-2011
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
  
   #with(as.list(c(state, parameters)), {
  
      deltim <- as.numeric(parameters[1])
  
      # compute fluxes:
      mppt   <- as.numeric(ppt[t])
      mpet   <- as.numeric(pet[t])
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

      # compute derivatives for states in the upper layer
      if(smodl$arch1 == 23) {                        # tension storage sub-divided into recharge and excess
        dtens_1a <- m_flux$eff_ppt     - m_flux$qrunoff  - m_flux$evap_1a     - m_flux$rchr2excs
        dtens_1b <- m_flux$rchr2excs   - m_flux$evap_1b  - m_flux$tens2free_1
        dfree_1  <- m_flux$tens2free_1 - m_flux$qperc_12 - m_flux$qintf_1     - m_flux$oflow_1
        dtens_1  <- dtens_1a + dtens_1b
        dwatr_1  <- dtens_1  + dfree_1
      }
      
      if(smodl$arch1 == 22) {                        # upper layer broken up into tension and free storage
        dtens_1  <- m_flux$eff_ppt     - m_flux$qrunoff    - m_flux$evap_1  - m_flux$tens2free_1
        dfree_1  <- m_flux$tens2free_1 - m_flux$qperc_12 - m_flux$qintf_1 - m_flux$oflow_1
        dwatr_1  <- dtens_1 + dfree_1
      }
      
      if(smodl$arch1 == 21) {                        # upper layer defined by a single state variable
        dwatr_1  <- m_flux$eff_ppt    - m_flux$qrunoff    - m_flux$evap_1  - m_flux$qperc_12 - m_flux$qintf_1 - m_flux$oflow_1
      }

      # compute derivatives for states in the lower layer
      if(smodl$arch2 == 32) {                        # tension reservoir plus two parallel tanks
        dtens_2  <- m_flux$qperc_12*(1-mparam$percfrac) - m_flux$evap_2        - m_flux$tens2free_2
        dfree_2a <- m_flux$qperc_12*(mparam$percfrac/2) + m_flux$tens2free_2/2 - m_flux$qbase_2a    - m_flux$oflow_2a
        dfree_2b <- m_flux$qperc_12*(mparam$percfrac/2) + m_flux$tens2free_2/2 - m_flux$qbase_2b    - m_flux$oflow_2b
        dfree_2  <- dfree_2a + dfree_2b
        dwatr_2  <- dtens_2  + dfree_2
      }

      # single state
      if(smodl$arch2 == 31 || smodl$arch2 == 33 || smodl$arch2 == 34 || smodl$arch2 == 35) { 
        dwatr_2  <- m_flux$qperc_12 - m_flux$evap_2 - m_flux$qbase_2 - m_flux$oflow_2
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
   #})

}

