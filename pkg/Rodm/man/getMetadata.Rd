\name{getMetadata}
\alias{getMetadata}
\alias{getID}
\alias{id2name}
\title{
Get information about metadata
}
\description{
getMetadata allows to query entries from the metadata tables.

getID allows to find the ID for an entry from a metadaa table. A smart matching algorithm is used to retrieve relevant entries.

id2name is an internal function. It takes a dataframe (e.g. returned from IgetDataValues) and converts each column with a name starting with ID to the name or term from the corresponding metadata table.
}
\usage{
getMetadata(table, EXACT = FALSE, ...)
getID(table, value)
id2name(dataframe)
}
\arguments{
  \item{table}{
Table name of the metadata table.
}
  \item{EXACT}{
boolean indicating whether only exact matches should be returned or partial matches of the term should be accepted.
}
  \item{value}{
String describing the entry in the table.
}
  \item{dataframe}{
Dataframe to be converted from ID - columns to names.
}
  \item{\dots}{
Additional columns to filter entries.
}
}
\details{
The matching algorithm of getID first attempts to find exact matches in one of the column. If no result is obtained, partial matches and similar entries based on the Levenstein algorithm are searched.
}
\value{
getID returns a vector of the IDs. getMetadata returns a dataframe representing the metadata table
}
\author{
Dominik Reusser
}
\seealso{
Use \code{\link{CVtables}} to obtain a list of controlled vocabularies. See also the ODM documentation from QUASHI
}
\examples{
#connect to standard database
#this also retrieves the controlled vocabularies from the CUASHI server
try(getID("Site", value="test"))

#retrieve metadata
getMetadata(table="VariableName")
}
\keyword{ utilities }
