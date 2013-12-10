\name{fuserouting.sim}
\alias{fuserouting.sim}
\title{Implementation of the framework for hydrological modelling FUSE - Routing model}
\description{Routing module derived from the Fortran version of FUSE by Martyn Clark (2011)}
\usage{fuserouting.sim(U, mid, modlist, timedelay, deltim)}
\arguments{
  \item{U}{Instantaneous runoff computed using fusesma.sim}
  \item{mid}{model id number in Model List 2011(see below for details)}
  \item{modlist}{Model List 2011}
  \item{timedelay}{time delay in runoff (days)}
  \item{deltim}{observation time step (days)}
}

\details{fuserouting.sim() is a routing module based on a two parameter Gamma distribution. It takes in input the instantaneous discharge and returns the routed discharge. It is compatible with the HYDROMAD framework (see hydromad package: http://hydromad.catchment.org/).}

\value{The function returns an array of simulated "routed" discharges. It can be used after calculating instantaneous discharges with \code{fusesma.sim}.}

\references{Clark M. P., SlaterA. G., Rupp D. E., Woods R. A., Vrugt J. A., Gupta H. V., Wagener T. and Hay L. E. (2008), Framework for Understanding Structural Errors (FUSE): A modular framework to diagnose differences between hydrological models, Water Resour. Res. 44 p. 91-94 

Clark M. P., McMillan H. K., Collins D. B. G., Kavetski D. and Woods R. A. (2011), Hydrological field data from a modeller's perspective: Part 2: process-based evaluation of model hypotheses. Hydrological Processes, 25: 523-543. doi: 10.1002/hyp.7902}

\author{Claudia Vitolo, Imperial College London}
\seealso{\code{\link{fusesma.sim}}}

\examples{
data(modlist)
data(mopex)

# returns the instantaneous runoff
Qinst <- fusesma.sim (fuse.DATA,mid=5,modlist,deltim=1,
                      states=FALSE,fluxes=FALSE,
                      fracstate0=0.25,
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
Qrout <- fuserouting.sim(Qinst, mid=5, modlist, fuse.parameters$timedelay, deltim=1)

}

\keyword{models}
\keyword{fuse}
\keyword{routing}

