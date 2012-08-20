\name{fusesma.sim}
\alias{fusesma.sim}
\title{Implementation of the framework for hydrological modelling FUSE - Soil Moisture Accounting model}
\description{Loss module derived from the Fortran version of FUSE by Martyn Clark (2011).}
\usage{
fusesma.sim(DATA, mid, modlist, states, fluxes, 
    deltim, fracstate0, rferr_add, rferr_mlt, 
    frchzne,fracten,maxwatr_1,percfrac,fprimqb,qbrate_2a,qbrate_2b,
    qb_prms,maxwatr_2,baserte,rtfrac1,percrte,percexp,sacpmlt,
    sacpexp,iflwrte,axv_bexp,sareamax,loglamb,tishape,qb_powr)
}
\arguments{
  \item{DATA}{data.frame containing observations. It consists of 3 columns: Rainfall (P), Potential Evapo-Transpiration (E) and Streamflow (Q)}
  \item{mid}{model id number in Model List 2011(see below for details)}
  \item{modlist}{list of availabe models}
  \item{states}{list of internal state variables}
  \item{fluxes}{list of fluxes}
  \item{deltim}{observation time step in days}
  \item{fracstate0}{initial store fraction (initialization)}
  \item{rferr_add}{additive rainfall error (mm)}
  \item{rferr_mlt}{multiplicative rainfall error (-)}
  \item{frchzne}{fraction tension storage in recharge zone (-)}
  \item{fracten}{fraction total storage in tension storage (-)}
  \item{maxwatr_1}{depth of the upper soil layer (mm)}
  \item{percfrac}{fraction of percolation to tension storage (-)} 
  \item{fprimqb}{fraction storage in 1st baseflow reservoir (-)}
  \item{qbrate_2a}{baseflow depletion rate 1st reservoir (day-1)}
  \item{qbrate_2b}{baseflow depletion rate 2nd reservoir (day-1)}
  \item{qb_prms}{baseflow depletion rate (day-1)}
  \item{maxwatr_2}{depth of the lower soil layer (mm)}
  \item{baserte}{baseflow rate (mm day-1)}
  \item{rtfrac1}{fraction of roots in the upper layer (-)}
  \item{percrte}{percolation rate (mm day-1)}
  \item{percexp}{percolation exponent (-)}
  \item{sacpmlt}{SAC model percltn mult for dry soil layer (-)}
  \item{sacpexp}{SAC model percltn exp for dry soil layer (-)}
  \item{iflwrte}{interflow rate (mm day-1)}
  \item{axv_bexp}{ARNO/VIC "b" exponent (-)}
  \item{sareamax}{maximum saturated area (-)}
  \item{loglamb}{mean value of the topographic index (m)}
  \item{tishape}{shape param for the topo index Gamma dist (-)}
  \item{qb_powr}{baseflow exponent (-)}
}

\details{
fusesma.sim() is a function to generate an ensemble of SOIL MOISTURE ACCOUNTING models. It is compatible with the HYDROMAD framework (see hydromad package: http://hydromad.catchment.org/).

fusesma.sim() can simulate several model structures. The default list is a \code{modlist} dataframe contained in the data folder of this package. 
# TO DO: An alternative list can also be defined by the user.
In modlist each row identifies a model structure, and each column identifies a different element of the model structure:

\tabular{ll}{
first column    \tab mid   = model id number\cr
second column 	\tab rferr = type of rainfall error (optional)\cr
third column	\tab arch1 = architecture of the upper soil layer\cr
fourth column 	\tab arch2 = architecture of the lower soil layer\cr
fifth column 	\tab qsurf = surface runoff\cr
sixth column 	\tab qperc = vertical drainage\cr
seventh column 	\tab esoil = evapotranspiration\cr
eighth column	\tab qintf = interflow\cr
ninth column 	\tab q_tdh = routing\cr
}  

For each element of the model structure, several model decisions can be made (see Clark et al. 2011 for details):
\itemize{
	\item Rainfall error (rferr) \itemize{
	           \item additive = 11
	           \item multiplicative = 12
	           }
	\item Architecture of the upper soil layer (arch1) \itemize{
	            \item Single state = 21
	            \item Separate tension storage = 22
	            \item Cascading buckets = 23
	            }
	\item Architecture of the lower soil layer (arch2) \itemize{
	            \item Baseflow reservoir of fixed size = 31
	            \item Tension reservoir plus two parallel tanks = 32
	            \item Baseflow reservoir of unlimited size (frac rate) = 33
	            \item Baseflow reservoir of unlimited size (power recession) = 34
	            %% \item Topmodel exponential reservoir (no more in the list) = 35
	            }
	\item Runoff (qsurf) \itemize{
	            \item Unsaturated zone Pareto = 41
	            \item Unsaturated zone linear = 42
	            \item Saturated zone topographic = 43
	            }
	\item Percolation (qperc) \itemize{
	            \item Drainage above field capacity = 51
	            \item Gravity drainage = 52
	            \item Saturated zone control = 53
	            }
	\item Evaporation (esoil) \itemize{
	            \item Sequential = 61
	            \item Root weighting = 62
	            } 
	\item Interflows (qintf) \itemize{
	            \item Interflow denied = 71
	            \item Interflow allowed = 72
	            } 
	\item Routing (q_tdh) \itemize{
	            \item Routing denied = 81
	            \item Routing allowed using Gamma distribution = 82
	            }
}

For instance, model 5 is identified by the following string (from the table above reading first the row number then column number for each model decision):
5 11 22 33 41 51 62 71 82

The parameter set varies depending on the selected model structure. Ranges of parameter values are in \code{fusesma.ranges}

Flow can then be routed using the function \code{fuserouting.sim} (which is based on the Gamma function) or any other routing function.

}
\value{
The function returns an array of simulated "instantaneous" discharges. If necessary, \code{fuserouting.sim} can be run to obtain routed discharges using a two parameter Gamma distribution.
}
\references{Clark M. P., SlaterA. G., Rupp D. E., Woods R. A., Vrugt J. A., Gupta H. V., Wagener T. and Hay L. E. (2008), Framework for Understanding Structural Errors (FUSE): A modular framework to diagnose differences between hydrological models, Water Resour. Res. 44 p. 91-94 

Clark M. P., McMillan H. K., Collins D. B. G., Kavetski D. and Woods R. A. (2011), Hydrological field data from a modeller's perspective: Part 2: process-based evaluation of model hypotheses. Hydrological Processes, 25: 523-543. doi: 10.1002/hyp.7902

%See also \url{http://...} for more examples on how to run fuse in R.
}
\author{Claudia Vitolo, Imperial College London}
% \note{}

\seealso{\code{\link{fuserouting.sim}}}
\examples{
data(modlist)
data(mopex)

mid <- 5
deltim <- 1
fracstate0 <- 0.25

# returns the instantaneous runoff
Qinst <- fusesma.sim (fuse.DATA,mid,modlist,deltim,fracstate0,states=FALSE,fluxes=FALSE,
                        fuse.parameters$rferr_add,fuse.parameters$rferr_mlt,fuse.parameters$frchzne,fuse.parameters$fracten,
                        fuse.parameters$maxwatr_1,fuse.parameters$percfrac,fuse.parameters$fprimqb,fuse.parameters$qbrate_2a,
                        fuse.parameters$qbrate_2b,fuse.parameters$qb_prms,fuse.parameters$maxwatr_2,fuse.parameters$baserte,
                        fuse.parameters$rtfrac1,fuse.parameters$percrte,fuse.parameters$percexp,fuse.parameters$sacpmlt,
                        fuse.parameters$sacpexp,fuse.parameters$iflwrte,fuse.parameters$axv_bexp,fuse.parameters$sareamax,
                        fuse.parameters$loglamb,fuse.parameters$tishape,fuse.parameters$qb_powr)
}

\keyword{models}
\keyword{ensemble}
\keyword{fuse}
\keyword{sma}

