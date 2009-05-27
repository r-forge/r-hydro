\name{NSeff}
\alias{NSeff}
\title{Calculation of the Nash-Sutcliffe efficiency}
\description{Calculation of the Nash-Sutcliffe efficiency}
\usage{NSeff(Qobs,Qsim)}

\arguments{
  \item{Qobs}{A vector with observed discharges}
  \item{Qsim}{A vector with simulated discharges of the same length as Qobs}
}

\details{
  Qobs and Qsim should have the same dimensions. Both can contain NA values.
}
\value{ The Nash-Suttcliffe coefficient}
\references{
thePaper

Nash, J. & Sutcliffe, J. River flow forecasting through conceptual models part I -- A discussion of principles. Journal of Hydrology, 1970 , 10 , 282-290
}
\author{Wouter Buytaert, Imperial College London}

\seealso{\code{\link{topmodel}}}
\examples{
}
\keyword{models}
