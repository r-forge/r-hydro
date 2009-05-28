\name{HydroFlux-class}
\docType{class}
\alias{HydroFlux-class}

\title{Class "HydroFlux"  }
\description{	The HydroFlux class represents a hydrological flux time series. }
\section{Objects from the Class}{
Objects can be created by calls of the form \code{new("HydroFlux", ...)}.
They extend the \code{"\linkS4class{HydroTS}"} class by adding a
direction component.
}
\section{Slots}{

  The class additionally defines
	 \describe{
    \item{\code{direction}:}{Object of class \code{"zoo"}. Defining
the direction of the flux (e.g. "in", "out", wind direction, ... }
    \item{\code{magnitude}:}{Object of class \code{"zoo"}. The time series itself }
    \item{\code{location.name}:}{Object of class \code{"character"}. Name of the location }
    \item{\code{coordinate}:}{Object of class \code{"Spatial"}. Coordinates of the location }
    \item{\code{TSorigin}:}{Object of class \code{"character"}. "recorded" or "generated" }
    \item{\code{accuracy}:}{Object of class \code{"character"}. Information about the accuracy }
    \item{\code{units}:}{Object of class \code{"character"}. Units of the time series }
    \item{\code{type}:}{Object of class \code{"character"}. Type of the time series. Reserved types are: ToDo }
  }
}
\section{Extends}{
Class \code{"\linkS4class{HydroTS}"}, directly.
}
\section{Methods}{
No methods defined with class "HydroFlux" in the signature.
}
\references{ thePaper }
\author{ Dominik Reusser, Wouter Buytaert }

\seealso{
\code{\linkS4class{HydroModelRun}}
}
\examples{
showClass("HydroFlux")
}
\keyword{classes}
