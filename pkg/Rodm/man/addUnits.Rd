\name{addUnits}
\alias{addUnits}
\title{
Extend controlled vocabulary for units.
}
\description{
Add a term to the controlled vocabulary for units. The better way is to 
have CUASHI add the term to the official vocabulary through their webpage:
http://his.cuahsi.org/mastercvreg/
}
\usage{
addUnits(ID, Name, Type, Abbreviation)
}
\arguments{
  \item{ID}{
Unique ID
}
  \item{Name}{
Name of the unit. e.g. square meter
}
  \item{Type}{
Type of the unit. e.g. area
}
  \item{Abbreviation}{
SI abbreviation e.g. m^2
}
}
\value{
Nothing returned
}
\author{
Dominik Reusser
}

\seealso{
 \code{\link{updateCV}} to retrieve the vocabularies from the CUASHI web service and update the database. \code{\link{getMetadata}}  allows to query for meta data.
}
\examples{
try(getID("Site", value="test"))
#add data
addUnits(ID="dsm", Name="decisiemens per meter", Type="Electrical Conductivity", Abbreviation="dS/m")
getMetadata("Units", Name="per meter")
}
\keyword{ utilities }
