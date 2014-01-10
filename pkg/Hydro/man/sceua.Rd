                                                                                                                                         \name{sceua}
\docType{methods}
\alias{sceua}


\title{Shuffle complex evolution}
\description{
R implementation of the Shuffle Complex Evolution (University of Arizona) method
for bounded optimization
}
	

\usage{
sceua(OFUN, pars, lower, upper, maxn = 10000, kstop = 5, pcento = 0.01,
    ngs = 5, npg = 5, nps = 5, nspl = 5, mings = 5, iniflg = 1, iprint = 0, iround = 3, 
    peps = 0.0001, plog = rep(FALSE,length(pars)), implicit = NULL, ...) 
}

\arguments{
  \item{OFUN}{the objective function to be optimized}
  \item{pars}{the initial parameter set}
  \item{lower}{lower limits for the parameters in the optimization process}
  \item{upper}{upper limits for the parameters in the optimization process}
  \item{maxn}{max number of iterations (optimization is done in blocks, so
              the procedure will usually use a few more iterations than \code{maxn}}
  \item{kstop}{number of shuffling loops in which the criterion value can change 
               by a maximum of \code{pcento} before optimization is terminated}
  \item{pcento}{maximum percentage by which the criterion value can change in 
                \code{kstop} number of shuffling loops}
  \item{ngs}{number of complexes in the initial population}
  \item{npg}{number of parameter sets in each complex}
  \item{nps}{total number of parameter sets in initial population \code{(npt=ngs*npg)}}
  \item{nspl}{number of evolution steps allowed for each complex before
              complex shuffling}
  \item{mings}{minimum number of complexes required, if the number of
               complexes is allowed to reduce as the optimization proceeds}
  \item{iniflg}{flag on whether to include the initial point in population
         \itemize{
           \item{0}{not included}
           \item{1}{included}
         }}
  \item{iprint}{ flag for controlling print-out after each shuffling loop
    \itemize{
           \item{0}{print information on the best parameter set of the population}
           \item{1}{print information on every parameter set of the population}
       }}
  \item{iround}{precision of printed output}
  \item{peps}{criterion for convergence of parameter sets}
  \item{plog}{single value or array (equal to length of pars) with TRUE or FALSE,
              indicating whether to optimize the parameters in logspace}
  \item{implicit}{function for implicit boundaries (e.g. sum(par[4]+par[5]) < 1)}
  \item{...}{other arguments for the objective function}
}


\details{
This is a slightly modified R implementation of the Shuffle Complex Evolution method 
from University of Arizona (SCE-UA), described by Duan et al. (1992). The 
implementation is based on the original FORTRAN implementation. 

A few adaptations have been added:
\itemize{
  \item{logarithmic parameters}{this version allows to search in logspace for one, 
                        some or all of the parameters.}
  \item{implicit}{Here it is possible to pass functions for implicit boundaries, 
                  giving TRUE if the parameters are outside the implicit boundaries, 
                  such as:
        
                    implicit = function(pars) (2*pars[4] + pars[5]) > 1
                  
                  }
  }


}

\value{
A list with the best parameter set (bestpar) and the value of the optimization for
this parameter set (value)

}

\references{
Qingyun Duan, Soroosh Sorooshian and Vijai Gupta (1992). Effective and Efficient Global Optimization for Conceptual Rainfall-Runoff Models, Water Resources Research 28(4), pp. 1015-1031.

Qingyun Duan, Soroosh Sorooshian and Vijai Gupta (1994). Optimal use of the SCE-UA global optimization method for calibrating watershed models, Journal of Hydrology 158, pp. 265-284. 
}


\examples{
require(HydroModels)
data(huagrahuma2)
parameters = parameters[1:9]
parlower = parameters*(ifelse(parameters < 0, 4, 0.25))
parupper = parameters*(ifelse(parameters < 0, 0.25, 4))
HMObject = RHydro("topmodel", Temporal = list(data = inputs),
                  Parameters = list(parameters = parameters, 
                                    parlower = parlower, 
                                    parupper = parupper,  
                                    top = topidx, 
                                    del = delay),
                  control = list(dependent = "Q"))
options(error = recover)
best = sceua(HMObjectiveFunction, parameters, parlower, parupper, 
                maxn = 100, object = HMObject)
best

}


\keyword{models}
