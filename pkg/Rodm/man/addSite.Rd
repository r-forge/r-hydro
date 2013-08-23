\name{addSite}
\alias{addSite}
\title{
Add detail information about the observation site
}
\description{
Information about the spatial location at which data values have been collected.
}
\usage{
addSite(Code, Name, x, y, Elevation = rep(0, length(Code)),
                 LatLongDatum, LocalProjection = NULL, isLocal = NULL,
                 VerticalDatum = NULL, PositionAccuracy = rep(0,
                 length(Code)), State = NULL, County = NULL, Comment = NULL)
}
\arguments{
  \item{Code}{
Code used by organization that collects the data to identify the site 
}
  \item{Name}{
Full name of the sampling site. 
}
  \item{x}{
x coordiante
}
  \item{y}{
y coordiante
}
  \item{Elevation}{
Elevation of sampling location 
(in m).  
}
  \item{LatLongDatum}{
Spatial Reference System of the latitude and longitude coordinates  
}
  \item{LocalProjection}{
Spatial Reference System of 
the local coordinates  
}
  \item{isLocal}{
Boolean, indicating if x and y are inthe lat/long or local coordiante system.
}
  \item{VerticalDatum}{
Vertical datum of the elevation.
}
  \item{PositionAccuracy}{
Value giving the accuracy with 
which the positional 
information is specified in 
meters. 
}
  \item{State}{
Name of state in which the 
monitoring site is located. 
}
  \item{County}{
Name of county in which the 
monitoring site is located. 
}
  \item{Comment}{
Additional comments for the location.
}
}
\value{
Nothing  is returned.
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
addSite(Code="10109000", Name="LOGAN RIVER ABOVE STATE DAM, NEAR LOGAN,UT", 
	x=-100.47, y= 45.32, LatLongDatum="WGS84", Elevation="1432", 
	VerticalDatum="NAVD88", PositionAccuracy=100, Stat="Utah")

getMetadata(table="Site", Name="LOGAN")
}
\keyword{ utilities }
