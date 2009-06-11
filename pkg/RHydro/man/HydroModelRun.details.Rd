\name{HydroModelRun.details}
\alias{HydroModelRun.details}
\alias{get.data.types}
\alias{get.stations}
\alias{get.HydroTS}
\title{ Extract details from HydroModelRun object }
\description{
\code{get.data.types} extracts a list of data.types stored in a \code{\linkS4class{HydroModelRun}} object.
\code{get.stations} extracts a list of stations for which data is available.
\code{get.HydroTS} extracts \code{\linkS4class{HydroTS}} objects from.
}
\usage{
get.data.types(object, data.class = c("modelledFluxes", "modelledStates", "measuredFluxes", "measuredStates"))
get.stations(object, data.class = c("modelledFluxes", "modelledStates", "measuredFluxes", "measuredStates"))
get.HydroTS(object, data.class = c("modelledFluxes", "modelledStates",
"measuredFluxes", "measuredStates"),
    the.data.types=data.types(object, data.class=data.class))
}
\arguments{
  \item{object}{ a \code{\linkS4class{HydroModelRun}} object }
  \item{data.class}{ List of strings indicating from which data class(es) to collect the information }
  \item{the.data.types}{ List of strings with the data.types for which
to obtain information}
}
\value{
   A list of strings or \code{\linkS4class{HydroTS}} objects is returned.
}
\references{ thePaper }
\author{ Dominik Reusser, Wouter Buytaert }
\examples{
library(RHydroWasimData)
file=system.file("controllfile.$$$", package="RHydroWasimData")

object <- wasim.read.ModelRun(file)
get.data.types(object)
get.stations(object)
get.HydroTS(object, the.data.types="radiation")
}
\keyword{ utilities }
