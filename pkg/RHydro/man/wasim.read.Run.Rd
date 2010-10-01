\name{wasim.read.Run}
\alias{wasim.read.Run}
\title{ Read WaSiM data for a model run }
\description{
  Functionality to process input data and results for a WaSiM model run.
}
\usage{
wasim.read.Run(files)
}
\arguments{
  \item{files}{ vector of paths to a WaSiM \$\$\$-files (The parsed control file). }
}
\details{
  ToDo: Check if correct for wasim.read.Run
  A data.frame defining the data to be read must be stored as \code{\link{wasim.data.types}}. RHydro comes with a default definition for this data.frame 

  If files points to multiple WaSiM \$\$\$-files, each is added as seperate run.
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

object <- wasim.read.Run(file)
plot(object, hydro.plot.type="rainfall-runoff")
plot(object, hydro.plot.type="balance")

}
\keyword{ utilities }
\keyword{ models }
\keyword{ ts }
