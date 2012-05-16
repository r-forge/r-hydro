\name{addOffsetType}
\alias{addOffsetType}
\title{
Add detail information about Offset.
}
\description{
OffsetTypes table lists full descriptive information for each of the measurement offsets.
}
\usage{
addOffsetType(Units, Description)
}
\arguments{
  \item{Units}{
Units of the OffsetValue. 
}
  \item{Description}{
Full text description of the offset type. 
}
}
\value{
nothing returned
}
\author{
Dominik Reusser
}
\seealso{
Use \code{\link{getMetadata}} to retrieve values.
}
\examples{
#connect to standard database
getDefaultDB()
#add data
addOffsetType(Units="cm", Description="Above Ground Level")
getMetadata(table="OffsetType", Description="Ground Level")
}
\keyword{ utilities }
