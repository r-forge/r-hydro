\name{addSpatialReferences}
\alias{addSpatialReferences}
\title{
Add spatial reference system
}
\description{
Add a term to the spatial references controlled vocabularies. The better way is to 
have CUASHI add the term to the official vocabulary through their webpage:
http://his.cuahsi.org/mastercvreg/
}
\usage{
addSpatialReferences(ID, SRSID, Name, IsGeographic, Notes)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{ID}{
Unique ID. 
}
  \item{SRSID}{
Integer identifier for the Spatial 
Reference System from 
http://www.epsg.org/ 
}
  \item{Name}{
Name of the Spatial Reference System. 
}
  \item{IsGeographic}{
Boolean, indicating whether the spatial 
reference system uses geographic 
coordinates 
}
  \item{Notes}{
Descriptive information about the Spatial 
Reference System.  
}
}
\value{
Nothing returned
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
addSpatialReferences(ID=4269,SRSID=4269, Name="NAD83", 
	IsGeographic=TRUE, Notes="todo: include notes in this example") 
}
\keyword{ utilities }
