\name{HydroRun.details}
\alias{HydroRun.details}
\alias{get.data.types}
\alias{get.stations}
\alias{get.names}
\alias{validity.check}
\alias{get.runCount}
\title{ Extract details from HydroRun object }
\description{
\code{get.data.types} extracts a list of data.types stored in a \code{\linkS4class{HydroRun}} object.
\code{get.stations} extracts a list of stations for which data is available.
\code{get.runCount} returns the number of runs stored in the object.
}
\usage{
get.names(object, ...)
validity.check(object)
get.data.types(object, type = factor(c("flux", "state")),
 		origin = factor(c("simulated", "measured")), 
		runs = 1:max(object@metadata$run.ID))

get.stations(object, type = factor(c("flux", "state")), 
		origin = factor(c("simulated", "measured")), 
		data.types = get.data.types(object, type = type, origin = origin),
                 runs = 1:max(object@metadata$run.ID), unique = TRUE)

get.runCount(object)
}
\arguments{
  \item{object}{ a \code{\linkS4class{HydroRun}} object }
  \item{type}{ ToDo }
  \item{origin}{ ToDo }
  \item{unique}{ ToDo }
  \item{...}{ Optional arguments for the get.names function  }
  \item{data.types}{ List of strings with the data.types for which to obtain information}
  \item{stations}{ List of strings with the stations for which to obtain information}
  \item{runs}{ Vector of run-indizes for which to get information}
}
\value{
   A list of strings  is returned.
}
\references{ thePaper }
\author{ Dominik Reusser, Wouter Buytaert }
\examples{
library(RHydroWasimData)
file=system.file("controllfile.$$$", package="RHydroWasimData")

object <- wasim.read.Run(file)
get.data.types(object)
get.stations(object)
}
\keyword{ utilities }
