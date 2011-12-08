\name{HydroModelParameters-class}
\docType{class}
\alias{HydroModelParameters-class}
\alias{HydroWasimParameters-class}
\alias{coerce,numeric,HydroModelParameters-method}
\alias{coerce,data.frame,HydroModelParameters-method}
\alias{coerce,matrix,HydroModelParameters-method}
\alias{coerce,HydroModelParameters,data.frame-method}
\alias{coerce,HydroModelParameters,matrix-method}
\alias{coerce,list,HydroWasimParameters-method}
\alias{coerce,list,HydroModelParameters-method}
\alias{plot,HydroModelParameters,ANY-method}
\alias{print,HydroModelParameters-method}
\alias{names,HydroModelParameters-method}

\title{Class "HydroModelParameters" }
\description{	 The class HydroModelParameters contains a dataframe with a collection of parameter sets for running a hydrological model}
\section{Objects from the Class}{
Objects can be created by calls of the form
\code{new("HydroModelParameters", ...)}. But usually, objects of
specific subclasses are created.

HydroModelParameters as such has little direct relevance, it is a superclass for a specific models. For instances, topmodel uses the specific class HydroTopmodelParameters, which checks parameters for irrealistic values that may result in anomalous model behaviour.
}
\section{Slots}{
	 \describe{
    \item{\code{parameters}:}{Object of class \code{"data.frame"}.
data.frame with a list of model parameters }
    \item{\code{modelID}:}{Object of class \code{"character"}. Name of
the specific model }
  }
}
\section{Methods}{
  \describe{
    \item{plot}{\code{signature(x = "HydroModelParameters", y = "ANY")}: ... }
    \item{print}{\code{signature(x = "HydroModelParameters")}: ... }
    \item{names}{\code{signature(x = "HydroModelParameters")}: ... }
    \item{coerce}{\code{signature(from = "numeric", to = "HydroModelParameters")}: ... }
    \item{coerce}{\code{signature(from = "data.frame", to = "HydroModelParameters")}: ... }
    \item{coerce}{\code{signature(from = "matrix", to = "HydroModelParameters")}: ... }
    \item{coerce}{\code{signature(from = "HydroModelParameters", to = "data.frame")}: ... }
    \item{coerce}{\code{signature(from = "HydroModelParameters", to = "matrix")}: ... }
    \item{coerce}{\code{signature(from = "list", to = "HydroWasimParameters")}: ... }
    \item{coerce}{\code{signature(from = "list", to = "HydroModelParameters")}: ... }
	 }
}
\references{ thePaper }
\author{ Dominik Reusser, Wouter Buytaert }

\seealso{
	\code{\linkS4class{HydroRun}} 
	\code{\linkS4class{HydroTopmodelParameters}} 
	\code{\linkS4class{HydroWasimParameters}} 
}
\examples{
showClass("HydroModelParameters")
}
\keyword{classes}
