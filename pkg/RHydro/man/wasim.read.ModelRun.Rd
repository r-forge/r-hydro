\name{wasim.read.ModelRun}
\alias{wasim.read.ModelRun}
\title{ Read WaSiM data for a model run }
\description{
  Functionality to process input data and results for a WaSiM model run.
}
\usage{
wasim.read.ModelRun(file, data.types = wasim.data.types)
}
\arguments{
  \item{file}{ path to a WaSiM \$\$\$-file (The parsed control file) }
  \item{data.types}{ data.frame defining the data to be read - see \code{\link{wasim.data.types}} }
}
\value{
 A \code{\linkS4class{HydroModelRun}} object is returned.
}
\references{ thePaper,

Schulla, J. & Jasper, K. Model Description WaSiM-ETH 2001
 }
\author{ Dominik Reusser, University of Potsdam }
\examples{
library(RHydroWasimData)
file=system.file("controllfile.$$$", package="RHydroWasimData")

object <- wasim.read.ModelRun(file)
plot(object, plot.type="rainfall-runoff")

}
\keyword{ utilities }
\keyword{ models }
\keyword{ ts }
