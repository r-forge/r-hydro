\name{NSeff}
\alias{NSeff}
\title{Calculation of the Nash-Sutcliffe efficiency}
\description{Calculation of the Nash-Sutcliffe efficiency}
\usage{NSeff(Qobs,Qsim)}

\arguments{
  \item{Qobs}{Vector with observed discharges}
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

output <- topmodel(parameters, inputs, topidx, delay)
Qsim <- get.HydroTS(output, data.type="discharge", data.class="modelledFluxes")
#ToDo
#NSeff(inputs$Q,Qsim)
}
\keyword{models}
