\name{wasim.file2HydroTS}
\alias{wasim.file2HydroTS}
\title{ Convert WaSiM input or output file to HydroTS-object }
\description{
Convert WaSiM input or output file to HydroTS-object
}
\usage{
wasim.file2HydroTS(file, is_recorded, is_flux, direction = zoo("out"), units, type,  generated.header.info = NULL)
}
\arguments{
  \item{file}{ path to the WaSiM input or output file }
  \item{is_recorded}{ boolean indicating whether the data is recorded or generated }
  \item{is_flux}{ boolean indicating whether the data is a flux or state }
  \item{direction}{ direction data for fluxes - no meaning for states }
  \item{units}{ units of the data }
  \item{type}{ string describing the type. See also \code{\linkS4class{HydroModelRun}} for "reserved" types }
  \item{generated.header.info}{ \code{\linkS4class{HydroTS}} from measured discharge data from which to extact header information for generated wasim data}
}
\value{
 \code{\linkS4class{HydroTS}} object is returned
}
\references{ thePaper,

Schulla, J. & Jasper, K. Model Description WaSiM-ETH 2001
 }
\author{ Dominik Reusser, University of Potsdam }
\seealso{  \code{\link{wasim.read.Run}} }
\examples{
library(RHydroWasimData)
file=system.file("input/ww100-dhh.txt", package="RHydroWasimData")
data <- wasim.file2HydroTS(file, is_recorded=TRUE, is_flux=FALSE, units="\%", type="rel. humidity")
plot(data)
}
\keyword{ utilities }
\keyword{ models }
\keyword{ ts }
