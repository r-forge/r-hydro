\name{HydroModelRun.details}
\alias{HydroModelRun.details}
\alias{get.data.types}
\alias{get.stations}
\alias{get.runCount}
\alias{get.HydroTS}
\title{ Extract details from HydroModelRun object }
\description{
\code{get.data.types} extracts a list of data.types stored in a \code{\linkS4class{HydroModelRun}} object.
\code{get.stations} extracts a list of stations for which data is available.
\code{get.runCount} returns the number of runs stored in the object.
\code{get.HydroTS} extracts \code{\linkS4class{HydroTS}} objects from.
}
\usage{
get.data.types(object, data.class = c("modelledFluxes", "modelledStates", "measuredFluxes", "measuredStates"), runs = 1:get.runCount(object))
get.stations(object, 
             data.class = c("modelledFluxes", "modelledStates", "measuredFluxes", "measuredStates"), 
             data.types = get.data.types(object, data.class = data.class), 
             runs = 1:get.runCount(object))
get.runCount(object)
get.HydroTS(object, data.class = c("modelledFluxes", "modelledStates",
"measuredFluxes", "measuredStates"),
            data.types = get.data.types(object, data.class = data.class), 
            stations = get.stations(object, data.class = data.class), 
            runs = 1:get.runCount(object))
}
\arguments{
  \item{object}{ a \code{\linkS4class{HydroModelRun}} object }
  \item{data.class}{ List of strings indicating from which data class(es) to collect the information }
  \item{data.types}{ List of strings with the data.types for which to obtain information}
  \item{stations}{ List of strings with the stations for which to obtain information}
  \item{runs}{ Vector of run-indizes for which to get information}
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
