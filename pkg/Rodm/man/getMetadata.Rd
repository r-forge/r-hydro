\name{getMetadata}
\alias{getMetadata}
\alias{getID}
\alias{id2name}
\title{
Get information about meta data
}
\description{
getMetadata allows to query entries from the meta data tables.

getID allows to find the ID for an entry from a meta table. A smart matching algorithm is used to retrieve relevant entries.

id2name is an internal function. It takes a data frame (e.g. returned from IgetDataValues) and converts each column with a name starting with ID to the name or term from the corresponding meta data table.
}
\usage{
getMetadata(table, EXACT = FALSE, ...)
getID(table, value, remove.special.character=TRUE)
id2name(dataframe)
}
\arguments{
  \item{table}{
Table name of the meta data table.
}
  \item{EXACT}{
boolean indicating whether only exact matches should be returned or partial matches of the term should be accepted.
}
  \item{remove.special.character}{
boolean indicating whether special characters should be removed when comparing. Usually, this should be turned on.
}
  \item{value}{
String describing the entry in the table.
}
  \item{dataframe}{
Data frame to be converted from ID - columns to names.
}
  \item{\dots}{
Additional columns to filter entries.
}
}
\details{
The matching algorithm of getID first attempts to find exact matches in one of the column. If no result is obtained, partial matches and similar entries based on the Levenstein algorithm are searched.

ToDo explain use of synonyms
}
\value{
getID returns a vector of the IDs.
getMetadata returns a data frame representing the meta data table.
}
\author{
Dominik Reusser
}
\seealso{
Use \code{\link{CVtables}} to obtain a list of controlled vocabularies. See also the ODM documentation from CUAHSI
}
\examples{
#connect to standard database
#this also retrieves the controlled vocabularies from the CUAHSI server
getDefaultDB()

#retrieve meta data
getMetadata(table="VariableName")
}
\keyword{ utilities }
