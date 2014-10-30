\name{addCV}
\alias{addCV}
\alias{updateCV}
\alias{CVtables}
\title{
Extend controlled vocabularies
}
\description{
Add a term to one of the controlled vocabularies. The better way is to 
have CUAHSI add the term to the official vocabulary through their web-page:
http://his.cuahsi.org/mastercvreg/

updateCV queries the official vocabulary again and updates the database tables.

CVtables returns a list of controlled vocabularies.
}
\usage{
addCV(table, term, definition)
updateCV()
CVtables()
}
\arguments{
  \item{table}{
   Character: Name of the controlled vocabulary. Use \code{CVtables} for a list of tables.
}
  \item{term}{
   Character: Term to be added.
}
  \item{definition}{
   Character: Definition of the term 
}
}
\value{
Nothing returned
}
\author{
Dominik Reusser
}

\seealso{
  \code{\link{getMetadata}}  allows to query for meta data.
}
\examples{
#connect to standard database
getDefaultDB()
#add data
\dontrun{ updateCV() }
addCV("VariableName", "test", "Test entry to check the possibility to add a term to a vocabulary.")

getMetadata("VariableName", Term="test")
}
\keyword{utilities }
