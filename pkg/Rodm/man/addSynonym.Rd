\name{addSynonym}
\alias{addSynonym}
\title{
Add a synonym for one of the entries in any meta data table
}
\description{
For more convenience while importing data, synonyms for existing entries can be handeled by the package. This command allows you to add a synonym. Existing synonyms are then used to match the right record when searching and importing data.
}

\usage{
addSynonym(table, phrase, id)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{table}{
Name of the table, in which an entry exists.
}
  \item{phrase}{
The synonym
}
  \item{id}{
Unique ID of the record.
}
}
\details{
Do you need more? Let me know (see package maintainer).
}
\value{
nothing returned
}
\author{
Dominik Reusser
}

\seealso{
 \code{\link{getID}}, \code{\link{exportSynonyms}}
}

\examples{
#connect to standard database
getDefaultDB()
#add data
addSite(Code="10109000", Name="LOGAN RIVER ABOVE STATE DAM, NEAR LOGAN,UT", x=-100.47,
y= 45.32, LatLongDatum="WGS84", Elevation="1432", VerticalDatum="NAVD88", PositionAccuracy=100, Stat="Utah")
theID <- getID(table="Site", "Logan")
addSynonym(table="Site", phrase="logan dam", id=theID)
}
\keyword{ utilities }
