\name{HydroModelRun-class}
\docType{class}
\alias{HydroModelRun-class}
\alias{print,HydroModelRun-method}

\title{Class "HydroModelRun" }
\description{	 The HydroModelRun class is capable of holding data for several simulation runs}
\section{Objects from the Class}{
Objects are created by calling a hydrological model implemented in R
or an import routine for hydrological modelling results from an
external model.

Objects from this class provide common plotting and evaluation
functionality. Time series can be plotted in for representations:
rainfall-runoff-plots, plots sorted by data type or by station and
time series that help to check the mass or energy balance. Further
evaluation methods will be added in future versions. 
}
\section{Slots}{
	 \describe{
    \item{\code{parameter}:}{Object of class \code{\linkS4class{HydroModelParameters}}  }
    \item{\code{modelledFluxes}:}{ List of \code{\linkS4class{HydroFlux}} objects }
    \item{\code{modelledStates}:}{List of \code{\linkS4class{HydroState}} objects }
    \item{\code{measuredFluxes}:}{List of \code{\linkS4class{HydroFlux}} objects }
    \item{\code{measuredStates}:}{List of \code{\linkS4class{HydroState}} objects }
    \item{\code{performanceMeasures}:}{\code{"data.frame"} of performance measures - one data set each run. }
    \item{\code{modelSupportData}:}{List of additional data required for the model to run - usually spatial data}
    \item{\code{call}:}{Call that returned this object }
  }
}
\section{Methods}{
  \describe{
    \item{plot}{\code{signature(x = "HydroModelRun", y = "ANY")}: see
\code{\link{plot-HydroModelRun}} for more details. 
    }
              
    \item{print}{\code{signature(x = "HydroModelRun")}: ... }
	 }
}
\references{ thePaper }
\author{ Dominik Reusser, Wouter Buytaert }
\section{Implementation Details}{
ToDo How are multiple runs stored, how does it work with different
data sets, what are reserved data.types
}

\seealso{
	 \code{\link{HydroModelRun.details}},\code{\link{topmodel}}
	
}
\examples{
showClass("HydroModelRun")

data(huagrahuma)
attach(huagrahuma)

output <- topmodel(parameters, inputs, topidx, delay)


library(RHydroWasimData)
file=system.file("controllfile.$$$", package="RHydroWasimData")

object <- wasim.read.ModelRun(file)
class(object)
plot(object, hydro.plot.type="rainfall-runoff")
show(object)
print(object)
summary(object)

}
\keyword{classes}
