fluxevap <- function(arch1,arch2,esoil,fpet,mparam,dparam,tens_1a, tens_1b, tens_1, tens_2) {
   # Compute evaporation from the upper layer
   # Author: Claudia Vitolo
   # Date: 28-03-2011
   #
   # Args:
   #   arch1:                         smodl$arch1
   #   arch2:                         smodl$arch2
   #   esoil:                         smodl$esoil
   #   fpet:                          mpet
   #   mparam:                        model parameters
   #   dparam:                        derived model parameters
   #   tens_1a:                       tens_1a
   #   tens_1b:                       tens_1b
   #   tens_1:                        tens_1
   #   tens_2:                        tens_2
   #
   # Returns:
   #   Evaporation from the upper layer
   
   evap_1a <- 0
   evap_1b <- 0
   evap_1  <- 0
   evap_2  <- 0

   if(arch1 == 23) {                                         # tension storage sub-divided into recharge and excess
     if(esoil == 62) {
       evap_1a <- fpet * tens_1a/dparam$maxtens_1a
       evap_1b <- (fpet - evap_1a) * tens_1b/dparam$maxtens_1b
       evap_1  <- evap_1a + evap_1b
     }

     if(esoil == 61) {
       evap_1a <- fpet * mparam$rtfrac1 * tens_1a/dparam$maxtens_1a
       evap_1b <- fpet * dparam$rtfrac2 * tens_1b/dparam$maxtens_1b
       evap_1  <- evap_1a + evap_1b
     }

   }

   if(arch1 == 22 || arch1 == 21) {                # single tension store or single state

     if(esoil==62) {
       evap_1a <- 0
       evap_1b <- 0
       evap_1  <- fpet * tens_1/dparam$maxtens_1
     }

     if(esoil==61) {
       evap_1a <- 0
       evap_1b <- 0
       evap_1  <- fpet * mparam$rtfrac1 * tens_1/dparam$maxtens_1
     }
   }

   # compute evaporation from the lower layer
   if(arch2 == 32 || arch2 == 31) {                # lower layer architecture

     if(arch1 == 22 || arch1 == 21) {              # lower-layer evap is valid
       # use different evaporation schemes for the lower layer
       if(esoil == 62) evap_2 <- (fpet-evap_1) * (tens_2/dparam$maxtens_2)
       if(esoil == 61) evap_2 <- fpet * dparam$rtfrac2 * (tens_2/dparam$maxtens_2)
     }

     if(arch1 == "case('23") evap_2 <- 0                       # lower-layer evap is zero
   }
   
   if(arch2 == 33 || arch2 == 34 || arch2 == 35) evap_2 <- 0

   results <- c(evap_1a,evap_1b,evap_1,evap_2)

   return(results)

}

