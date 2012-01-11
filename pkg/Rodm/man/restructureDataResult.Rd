\name{restructureDataResult}
\alias{restructureDataResult}
\title{
Internal: Convert database query results
}
\description{
Function to convert database query results into a list of two xts objects, one for numerical and one for character information.
}
\usage{
restructureDataResult(to.ret, value.numeric=TRUE)
}
\arguments{
  \item{to.ret}{
  results returned from IgetDataValues.
}
  \item{value.numeric}{
	  boolean indicating if values should be converted to numeric type (characters can be stored in the database and should not be converted)
}
}
\details{
see code for details.
}
\value{
see code for details.
}
\author{
Dominik Reusser
}
\keyword{ utilities }
\keyword{ internal }
