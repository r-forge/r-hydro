\name{NSeff}
\alias{NSeff}
\title{Calculation of the Nash-Sutcliffe efficiency}
\description{Calculation of the Nash-Sutcliffe efficiency}
\usage{NSeff(object,Qsim)}

\arguments{
  \item{object}{Object with observed discharges}
  \item{Qsim}{Vector with simulated discharges of the same length as Qobs}
}

\details{
  Qobs and Qsim should have the same dimensions. Both can contain NA values.
}
\value{Nash-Suttcliffe coefficient}
\references{Nash, J. & Sutcliffe, J. River flow forecasting through conceptual models part I -- A discussion of principles. Journal of Hydrology, 1970 , 10 , 282-290
}
\author{Wouter Buytaert, Imperial College London}

\seealso{\code{\link{topmodel}}}
\examples{
data(huagrahuma)
attach(huagrahuma)

output <- topmodel(parameters[1:9], inputs, topidx, delay)
#ToDo
#Qsim <- get.HydroTS(output, data.type="discharge", data.class="modelledFluxes")
#NSeff(inputs$Q,Qsim)
}
\keyword{models}
