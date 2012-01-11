\name{getDataMatrix}
\alias{getDataMatrix}
\alias{getDataValues}
\alias{getDataVersions}
\title{
Retrieve data from the observations database
}
\description{
getDataValues allows to query data from the database. 

getDataMatrix obtaines data for a certain variable for all sites.

getDataVersions displays all the versions available in the database.
}
\usage{
getDataValues(ID = NULL, from = NULL, to = NULL, SiteID = NULL, VariableID = NULL, Offset = NULL, OffsetTypeID = NULL, CensorCode = NULL, QualifierID = NULL, MethodID = NULL, SourceID = NULL, SampleID = NULL, DerivedFromID = NULL, QualityControlLevelID = NULL, VersionID = NULL, VersionDate = NULL, show.deleted=FALSE)

getDataMatrix(variables, warn.missing = FALSE)

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
  \item{SiteID}{
 Information about the Site at which the data was observed. 
}
  \item{VariableID}{
 Information about what variable was observed. 
}
  \item{Offset}{
 Information about the offset of the observation. See also OffsetType. 
}
  \item{OffsetTypeID}{
 Information about the type of the offset as defined in the OffsetTypes table. See also \code{\link{addOffsetType}}. 
}
  \item{CensorCode}{
 Information about the cesor used for the observation. 
}
  \item{QualifierID}{
Qualifying information that can note anything unusual or
problematic about individual observations such as, for example, 'holding time for analysis
exceeded' or 'incomplete or inexact daily total.'
}
  \item{MethodID}{
 The method of field data collection, which may specify 'how' a physical
observation was made or collected
}
  \item{SourceID}{
Reference to the original sources of the data, providing information sufficient to
retrieve and reconstruct the data value from the original data files
}
  \item{SampleID}{
Information about physical samples analyzed in a laboratory to obtain an observation.
}
  \item{DerivedFromID}{
Reference to another record in the database, from which a value was derived.
}
  \item{QualityControlLevelID}{
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

  \item{variables}{
name of the variables for which to retrieve a data matrix.
}
  \item{warn.missing}{
Boolean indicating if missing information should be reported.
}
}
\details{
ToDo: Details about Version Management
What do you want to know in addition?
}
\value{
ToDo: describe return values
}
\author{
Dominik Reusser
}

\seealso{
For information how to insert data into the database \code{\link{addDataValues}}
}
\examples{
}
\keyword{ utilities }
