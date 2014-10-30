\name{expandVar}
\alias{expandVar}
\title{
Internal: make sure meta data information can be processed in a flexible way.
}
\description{
Converts meta data to a matrix
}
\usage{
expandVar(var, nrow, ncol, checkID = FALSE, table = NULL)
}
\arguments{
  \item{var}{
  The actual meta data information
}
  \item{nrow}{
 expected number of rows
}
  \item{ncol}{
 expected number of columns
}
  \item{checkID}{
 boolean, indicating if data in var should be converted to an ID
}
  \item{table}{
 Name of the meta data table 
}
}
\details{
What do you want to know?
}
\value{
A matrix with the meta data.
}
\author{
Dominik Reusser
}

\seealso{
 \code{\link{addDataValues}}
}
\examples{
#see code
}

\keyword{ utilities }
\keyword{ internal }
