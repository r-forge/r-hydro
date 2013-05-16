\name{remove_plateaus}
\alias{remove_plateaus}

\title{
Remove sensor-caused plateaus (steps) in hydrographs.
}
\description{
This filter removes sensor-caused plateaus (steps) in hydrographs, which may have originated from low-resolution sensors. Opposed to other filters, peak values are preserved.
}
\usage{
remove_plateaus(runoff)
}

\arguments{
  \item{runoff}{
vector of hydrograph
}
  
}
\details{
\code{remove_plateaus} eliminates plateaus by interpolating linearly between the start of a plateau and the first following non-plateau-value.
}

\value{
Cleansed hydrograph.
}

\author{
Dominik Reusser
}



\examples{

runoff         <- c(rep(1,3), rep(2,2), 4, rep(3,4), rep(2,5), rep(1,6))
runoff_cleaned <- remove_plateaus(runoff)
plot(runoff, type="l")
lines(runoff_cleaned, col="red")

}