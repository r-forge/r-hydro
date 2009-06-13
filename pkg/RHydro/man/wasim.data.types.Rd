\name{wasim.data.types}
\alias{wasim.data.types}
\docType{data}
\title{ WaSiM data type definition}
\description{
 data.frame that defines what data is defined at which position in the
WaSiM control file.
}
\format{
  A data frame with observations on the following 6 variables.
  \describe{
    \item{\code{par_block}}{name of the parameter block (marked by \[\])}
    \item{\code{block_position}}{line within the parameter block}
    \item{\code{is_flux}}{boolean indicating whether data is a state or a flux}
    \item{\code{is_recorded}}{boolean indicating whether data is recorded or generated}
    \item{\code{units}}{units of the data}
    \item{\code{type}}{name of the data. For types with special meaning see \code{\linkS4class{HydroModelRun}} }
  }
}
\references{
Schulla, J. & Jasper, K. Model Description WaSiM-ETH 2001
}
#\examples{
#}
\keyword{datasets}
