\name{getDataValues}
\alias{getDataValues}
\alias{getDataVersions}
\title{
Retrieve data from the observations database
}
\description{
getDataValues allows to query data from the database. 

getDataVersions displays all the versions available in the database.
}
\usage{
getDataValues(ID = NULL, from = NULL, to = NULL,
		 tz=c("global", "UTC", "GMT", "0", "local"), Site = NULL,
                 Variable = NULL, Offset = NULL, OffsetType = NULL,
                 CensorCode = NULL, Qualifier = NULL, Method = NULL,
                 Source = NULL, Sample = NULL, DerivedFromID = NULL,
                 QualityControlLevel = NULL, VersionID = NULL,
                 VersionDate = NULL, show.deleted = FALSE, 
		 all.ID = FALSE)

getDataVersions()
}
\arguments{
  \item{ID}{
Unique ID of the DataValue
}
  \item{from}{
Starting date of the period for which to retrieve the information
}
  \item{to}{
End date of the period for which to retrieve the information
}
  \item{tz}{
 String indicating whether the data should be obtained in the local or global time zone.
}
  \item{Site}{
 Information about the Site at which the data was observed. 
}
  \item{Variable}{
 Information about what variable was observed. 
}
  \item{Offset}{
 Information about the offset of the observation. See also OffsetType. 
}
  \item{OffsetType}{
 Information about the type of the offset as defined in the OffsetTypes table. See also \code{\link{addOffsetType}}. 
}
  \item{CensorCode}{
 Information about the censor used for the observation. 
}
  \item{Qualifier}{
Qualifying information that can note anything unusual or
problematic about individual observations such as, for example, 'holding time for analysis
exceeded' or 'incomplete or inexact daily total.'
}
  \item{Method}{
 The method of field data collection, which may specify 'how' a physical
observation was made or collected
}
  \item{Source}{
Reference to the original sources of the data, providing information sufficient to
retrieve and reconstruct the data value from the original data files
}
  \item{Sample}{
Information about physical samples analysed in a laboratory to obtain an observation.
}
  \item{DerivedFromID}{
Reference to another record in the database, from which a value was derived.
}
  \item{QualityControlLevel}{
Level of quality controlled applied to a dataset.
}
  \item{VersionID}{
Data version to be retrieved (see details about version management)
}
  \item{VersionDate}{
Creation date of the version to be retrieved (see details about version management)
}
  \item{show.deleted}{
Include records that have been deleted (see details about version management)
}
  \item{all.ID}{
Boolean: Can the function assume that all values are passed as ID. Reduces number of Database queries. Do not use normally, mainly for internal use.
}
}
\details{
Raw data often needs to be cleaned before it can
be used. RObsDat supports this and allows to
reconstruct data modification operations by use of version management.
This is valid for deleted and previous versions.
What do you want to know in addition?
}
\value{
The function 'getDataValues' returns a spacetime object.
Through using the R package spacetime it combine spatial data (sp), time series (xts) and the measurements.
Furthermore they are attached ValueIDs, DerivedFromIDs and Metadata of the spacetime object.
}
\author{
Dominik Reusser
}

\seealso{
For information how to insert data into the database \code{\link{addDataValues}}
}
\examples{
getDefaultDB()

#Put data into the database
example(addDataValues)

# Get a list of available variables with ID's)
getMetadata("Variable")$Name 

# Get ID of variable of interest 
var.id <- getID("Variable", "Distance") 

# Get data
data <- getDataValues(Variable="Distance", Site="test site") 
	# returns data object of class 'spacetime' with 3 slots

# Get data values:
data@data #returns values of spacetime-object

}
\keyword{ utilities }
