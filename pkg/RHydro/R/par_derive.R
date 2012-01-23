par_derive <- function(smodl,mparam) {
   # Computes derived model parameters (bucket sizes, etc.)
   # Author: Claudia Vitolo
   #
   # Args:
   #   smodl:                         list of model components
   #   mparam:                        list of parameters obtained from assign_par
   #
   # Returns:
   #   List of derived parameters.

   maxtens_1   <- -999
   maxtens_2   <- -999
   maxfree_1   <- -999
   maxfree_2   <- -999
   maxtens_1a  <- -999
   maxtens_1b  <- -999
   maxfree_2a  <- -999
   maxfree_2b  <- -999
   maxpow      <- -999
   powlamb     <- -999
   qbsat       <- -999
   rtfrac2     <- -999

   # BUCKETSIZE
   if(mparam$maxwatr_1 != -999 && mparam$fracten != -999) {
      maxtens_1  <- mparam$fracten * mparam$maxwatr_1            # derive maximum tension water in upper layer
      maxfree_1  <- (1-mparam$fracten) * mparam$maxwatr_1        # derive maximum free water in upper layer
   }
   
   if(mparam$maxwatr_2 != -999 && mparam$fracten != -999) {
      maxtens_2  <-  mparam$fracten * mparam$maxwatr_2           # derive maximum tension water in lower layer
      maxfree_2  <-  (1-mparam$fracten) * mparam$maxwatr_2       # derive maximum free water in lower layer
   }
   
   # derive capacities of the recharge and lower zone (only used if upper tension is divided in two)
   if(mparam$frchzne != -999 && maxtens_1 != -999) {
      maxtens_1a <-  mparam$frchzne * maxtens_1
      maxtens_1b <-  (1-mparam$frchzne) * maxtens_1
   }

   # derive capacities of the primary and secondary parallel baseflow reservoirs
   if(mparam$fprimqb != -999 && maxfree_2 != -999) {
      maxfree_2a <- mparam$fprimqb * maxfree_2
      maxfree_2b <- (1-mparam$fprimqb) * maxfree_2
   }

   # fraction of roots in the lower layer (-)
   if (smodl$esoil == 61) rtfrac2 <- 1 - mparam$rtfrac1

   # mean of the power-transformed topographic index
   if(mparam$tishape != -999 && mparam$loglamb != -999 && mparam$qb_powr != -999) {
     temp    <- mean_tipow(mparam$tishape, mparam$loglamb, mparam$qb_powr)
     maxpow  <- temp[1]/10   # not clear why???
     powlamb <- temp[2]
   }

   # compute baseflow at saturation (used in the sac percolation model)
   qbsat <- qbsaturatn(smodl$arch2,mparam,maxfree_2a,maxfree_2b,powlamb)

   dparam <- list("maxtens_1"   = maxtens_1,
                  "maxtens_2"   = maxtens_2,
                  "maxfree_1"   = maxfree_1,
                  "maxfree_2"   = maxfree_2,
                  "maxtens_1a"  = maxtens_1a,
                  "maxtens_1b"  = maxtens_1b,
                  "maxfree_2a"  = maxfree_2a,
                  "maxfree_2b"  = maxfree_2b,
                  "maxpow"      = maxpow,
                  "powlamb"     = powlamb,
                  "qbsat"       = qbsat,
                  "rtfrac2"     = rtfrac2)

   return(dparam)

}

