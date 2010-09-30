\name{HydroTS-class}
\docType{class}
\alias{HydroTS-class}
\alias{coerce,HydroTS,numeric-method}
\alias{coerce,numeric,HydroTS-method}
\alias{HydroState-class}
\alias{plot,HydroTS,ANY-method}
\alias{print,HydroTS-method}
\alias{length,HydroTS-method}
\alias{max,HydroTS-method}
\alias{min,HydroTS-method}
\alias{range,HydroTS-method}
\alias{validity.check,HydroTS-method}

\title{Class "HydroTS" }
\description{	The HydroTS class represents a hydrological time series. }
\section{Objects from the Class}{
Objects can be created by calls of the form \code{new("HydroTS", ToDo)}
and \code{new("HydroState", ToDo)}.

They consist of a \code{zoo} time series and a \code{Spatial} object, combined with
slots for the origin, accuracy, units and type (modelled or observed) of the
data. The \code{Spatial} object can either be a spatial point, pixel or
polygon, depending on the support of the data. Each HydroTS-Object can contain multiple time series.	  

HydroState extends HydroTS directly, without additional functionality at this moment.
}
\section{Slots}{
	 \describe{
    \item{\code{magnitude}:}{Object of class \code{"zoo"}. The time series itself }
    \item{\code{location.name}:}{Object of class \code{"character"}. Name of the location }
    \item{\code{coordinate}:}{Object of class \code{"Spatial"}. Coordinates of the location }
    \item{\code{TSorigin}:}{Object of class \code{"character"}. "recorded" or "generated" }
    \item{\code{accuracy}:}{Object of class \code{"character"}. Information about the accuracy }
    \item{\code{units}:}{Object of class \code{"character"}. Units of the time series }
    \item{\code{type}:}{Object of class \code{"character"}. Type of the time series as defined in \code{\link{rhydro.data.types}}}
  }
}
\section{Methods}{
  \describe{
    \item{plot}{\code{signature(x = "HydroTS", y = "ANY")}: ToDo }
    \item{print}{\code{signature(x = "HydroTS")}: ToDo }
    \item{length}{\code{signature(x = "HydroTS")}: ToDo }
    \item{max}{\code{signature(x = "HydroTS")}: ToDo }
    \item{min}{\code{signature(x = "HydroTS")}: ToDo }
    \item{range}{\code{signature(x = "HydroTS")}: ToDo }
    \item{validity.check}{\code{signature(x = "HydroTS")}: ToDo }
    \item{coerce}{\code{signature(from = "HydroTS", to = "numeric")}: ToDo }
    \item{coerce}{\code{signature(from = "numeric", to = "HydroTS")}: ToDo }
	 }
}
\author{ Dominik Reusser, Wouter Buytaert }


\seealso{
	 \code{\linkS4class{HydroFlux}}, \code{\linkS4class{HydroState}}
}
\examples{
showClass("HydroTS")
}
\keyword{classes}
