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

   # BUCKETSIZE
   maxtens_1  <- mparam$fracten * mparam$maxwatr_1           # derive maximum tension water in upper layer
   maxfree_1  <- (1-mparam$fracten) * mparam$maxwatr_1       # derive maximum free water in upper layer

   maxtens_2  <- mparam$fracten * mparam$maxwatr_2           # derive maximum tension water in lower layer
   maxfree_2  <- (1-mparam$fracten) * mparam$maxwatr_2       # derive maximum free water in lower layer
   
   # derive capacities of the recharge and lower zone (only used if upper tension is divided in two)
   maxtens_1a <- mparam$frchzne * maxtens_1
   maxtens_1b <- (1-mparam$frchzne) * maxtens_1

   # derive capacities of the primary and secondary parallel baseflow reservoirs
   maxfree_2a <- mparam$fprimqb * maxfree_2
   maxfree_2b <- (1-mparam$fprimqb) * maxfree_2

   # fraction of roots in the lower layer (-)
   rtfrac2 <- 1 - mparam$rtfrac1

   # mean of the power-transformed topographic index
   temp    <- mean_tipow(mparam$tishape, mparam$loglamb, mparam$qb_powr)
   maxpow  <- temp[1]    #in fortran code maxpow/10, why??? 
   powlamb <- temp[2]

   # compute baseflow at saturation (used in the sac percolation model)
   qbsat <- qbsaturatn(smodl$arch2,mparam,maxfree_2a,maxfree_2b,powlamb)

   return(list("maxtens_1"   = maxtens_1,
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
                  "rtfrac2"     = rtfrac2))

}

