\name{HydroModelRun.details}
\alias{HydroModelRun.details}
\alias{data.types}
\alias{stations}
\alias{getHydroTS}
\title{ Extract details from HydroModelRun object }
\description{
\code{data.types} extracts a list of data.types stored in a \code{\linkS4class{HydroModelRun}} object.
\code{stations} extracts a list of stations for which data is available.
\code{getHydroTS} extracts \code{\linkS4class{HydroTS}} objects from.
}
\usage{
data.types(object, data.class = c("modelledFluxes", "modelledStates", "measuredFluxes", "measuredStates"))
stations(object, data.class = c("modelledFluxes", "modelledStates", "measuredFluxes", "measuredStates"))
getHydroTS(object, data.class = c("modelledFluxes", "modelledStates",
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
}
\keyword{ utilities }
