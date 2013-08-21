\name{remove_plateaus}
\alias{remove_plateaus}

\title{
Remove sensor-caused plateaus (steps) in hydrographs.
}
\description{
This filter removes sensor-caused plateaus (steps) in hydrographs, which may have originated from low-resolution sensors. Opposed to other filters, peak values are preserved.
}
\usage{
remove_plateaus(runoff, method="start")
}

\arguments{
  \item{runoff}{
vector of hydrograph
}
  \item{method}{
see details
}
  
}
\details{
\code{remove_plateaus(..., method="start")} eliminates plateaus by interpolating linearly between the start of a plateau and the first following non-plateau-value. \code{remove_plateaus(..., method="center")} tries to include the points before, in the middle and after plateaus in the interpolation. 
}

\value{
Cleansed hydrograph.
}

\author{
Dominik Reusser, Till Francke
}



\examples{

runoff          <- c(rep(1,3), 2, 3, rep(4,4), 5, rep(3,4), rep(NA,2), 4, rep(2,5), rep(1,6))
runoff_cleaned  <- remove_plateaus(runoff)
runoff_cleaned2 <- remove_plateaus(runoff, method="center")

plot(runoff, type="l")
lines(runoff_cleaned, col="red")
lines(runoff_cleaned2, col="green")


}