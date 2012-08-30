\name{perfindices}
\alias{perfindices}
\title{Calculate 10 indices}
\description{This routine calculates 10 indices}
\usage{perfindices(Po,Qo,Qs,Qb)}
\arguments{
  \item{Po}{observed precipitation [mm/timestep]}
  \item{Qo}{observed streamflow    [mm/timestep]}
  \item{Qs}{simulated streamflow   [mm/timestep]}
  \item{Qb}{simulated base flow    [mm/timestep]}
}

\details{perfindices() calculates 5 performance measures and 5 catchment descriptors. It uses simulated and observed streamflow, observed precipitation (to calculate the rainfall-runoff coefficient) and simulated baseflow (to calculate the baseflow index).

The 5 performance measures are:
 \itemize{
    \item LAGTIME between observed and simulated discharge (from package tiger)
    \item MEAN ERROR between observed and simulated discharge
    \item MEAN ABSOLUTE ORDINAL ERROR between observed and simulated discharge (from package qualV)
    \item Complement to 1 of NASH-SUTCLIFFE EFFICIENCY between observed and simulated discharge (from package qualV)
    \item ROOT MEAN SQUARE ERROR between observed and simulated discharge (from package qualV)
 }
All the above measures tend to zero.

The 5 catchment descriptors are:
 \itemize{
    \item RAINFALL_RUNOFF coefficient
    \item BASEFLOW INDEX
    \item SLOPE of FLOW DURATION CURVE
    \item STREAMFLOW ELASTICITY
    \item Difference in HIGH PULSE COUNT between observed and simulated discharge
 }
}

\value{The function returns a list of 10 indices.}

%%\references{}

\author{Claudia Vitolo, Imperial College London}
%%\note{}
%%\seealso{}

\examples{
data(modlist)
data(mopex)

mid <- 5
deltim <- 1
fracstate0 <- 0.25

# returns the instantaneous runoff
X <- fusesma.sim (fuse.DATA,mid,modlist,fracstate0,
                      states=FALSE,fluxes=TRUE,
                      fuse.parameters$rferr_add,fuse.parameters$rferr_mlt,
                      fuse.parameters$frchzne,fuse.parameters$fracten,
                      fuse.parameters$maxwatr_1,fuse.parameters$percfrac,
                      fuse.parameters$fprimqb,fuse.parameters$qbrate_2a,
                      fuse.parameters$qbrate_2b,fuse.parameters$qb_prms,
                      fuse.parameters$maxwatr_2,fuse.parameters$baserte,
                      fuse.parameters$rtfrac1,fuse.parameters$percrte,
                      fuse.parameters$percexp,fuse.parameters$sacpmlt,
                      fuse.parameters$sacpexp,fuse.parameters$iflwrte,
                      fuse.parameters$axv_bexp,fuse.parameters$sareamax,
                      fuse.parameters$loglamb,fuse.parameters$tishape,
                      fuse.parameters$qb_powr)
                        
# returns the routed runoff
Qrout <- fuserouting.sim(X$U, mid, modlist, deltim, fuse.parameters$timedelay)

Po <- fuse.DATA[,"P"]
Qo <- fuse.DATA[,"Q"]
Qs <- Qrout
Qb <- X$qbase_2
  
indices   <- perfindices(Po,Qo,Qs,Qb)

}

\keyword{fuse}
\keyword{indices}
\keyword{performances}

