\name{HydroRun-class}
\docType{class}
\alias{HydroRun-class}
\alias{HydroModel-class}
\alias{$.HydroRun}
\alias{print,HydroRun-method}
\alias{predict,HydroModel-method}
\alias{get.names,HydroRun-method}
\alias{subset,HydroRun-method}
\alias{validity.check,HydroRun-method}
\alias{merge,HydroRun,HydroRun-method}
\alias{NSeff,HydroRun,missing-method}
\alias{plot,HydroRun,ANY-method}


\title{Class "HydroRun" and "HydroModel" (to be merged) }
\description{	 The HydroRun class is capable of holding data for several simulation runs}
\section{Objects from the Class}{
Objects are created by calling a hydrological model implemented in R
or an import routine for hydrological modelling results from an
external model.

Objects from this class provide common plotting and evaluation
functionality. Time series can be plotted for representations:
rainfall-runoff-plots, plots sorted by data type or by station and
time series that help to check the mass or energy balance. Further
evaluation methods will be added in future versions. 
}
\section{Slots}{
	 \describe{
    \item{\code{parameters}:}{Object of class \code{\linkS4class{HydroModelParameters}}  }
    \item{\code{GIS}:}{ ToDo }
    \item{\code{metadata}:}{data.frame with columns  "ID",        "param.ID",  "GIS.ID",    "type",      "name",      "flux",     "origin",    "dimension", and "run.ID"}
    \item{\code{ts}:}{ToDo}
    \item{\code{performanceMeasures}:}{\code{"data.frame"} of performance measures - one data set each run. }
    \item{\code{modelSupportData}:}{List of additional data required for the model to run - usually spatial data}
    \item{\code{call}:}{Call that returned this object }
  }
}
\section{Methods}{
  \describe{
    \item{plot}{\code{signature(x = "HydroRun", y = "ANY")}: see ToDo for more details. 
    }
              
    \item{print}{\code{signature(x = "HydroRun")}: ... }
    \item{predict}{\code{signature(x = "HydroModel")}: ... }
    \item{get.names}{\code{signature(object = "HydroRun")}: Obtain list of names that can be accessed with $ }
    \item{subset}{\code{signature(x = "HydroRun")}: select a subset of the data ToDo: Improve documentation  }
    \item{validitiy.check}{\code{signature(x = "HydroRun")}: run validity checks on data ToDo: implement and improve documentation  }
    \item{NSeff}{\code{signature(x = "HydroRun", y="missing")}: Return the \code{\link{NSeff}} for the HydroRun Object.  }
	 }
}
\references{ thePaper }
\author{ Dominik Reusser, Wouter Buytaert }
\section{Implementation Details}{
ToDo How are multiple runs stored, how does it work with different
data sets, what are reserved data.types
}

\seealso{
	 \code{\link{HydroRun.details}},\code{\link{topmodel}}
	
}
\examples{
showClass("HydroRun")

data(huagrahuma)
attach(huagrahuma)

output <- topmodel(parameters[1:9], inputs, topidx, delay)

detach(huagrahuma)

\dontrun{
library(RHydroWasimData)
file=system.file("controllfile.$$$", package="RHydroWasimData")

object <- wasim.read.Run(file)
class(object)
plot(object, hydro.plot.type="rainfall-runoff")
show(object)
print(object)
summary(object)
}

}
\keyword{classes}
