\name{chr2date}
\alias{chr2date}
\alias{guess.tz}
\alias{tz2offset}
\title{
Internal: Convert character to date object and guess time zone
}
\description{
Makes sure, character strings are converted to date objects
}
\usage{
chr2date(string, tz)
guess.tz(tz)
tz2offset(tz)
}
\arguments{
  \item{string}{
   The string containing the information about the date.
}
  \item{tz}{
  The time zone
}

}
\details{
What should be here?

guess.tz returns the correct string representation of tz that can be understood by strptime.

tz2offset returns the time difference in hours to GMT.
}
\value{
A POSIXct object with the date information
}
\author{
Dominik Reusser
}

\examples{
#see code
}
\keyword{ utilities }
\keyword{ internal }
