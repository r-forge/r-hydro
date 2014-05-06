\name{addDataValues}
\alias{addDataValues}
\alias{deleteDataValues}
\alias{updateDataValues}
\title{
Add, delete or modify data to the observations database
}
\description{
Add, delete or modify data to the observations database. The add function takes either a xts object or values and a date vector as sperate objects. Entries for metadata can be provided  
either corresponding to the columns, the rows or each entry (as matrix) of values.
See the CUASHI observations data model (ODM) for more information about the data model.
}
\usage{
addDataValues(DataZoo = NULL, Date = NULL, Value = NULL, 
	ValueAccuracy = rep(NA, NCOL(DataZoo)), Site, Variable, 
	Offset = rep(NA, NCOL(DataZoo)), OffsetType = rep("No", NCOL(DataZoo)), 
	CensorCode = rep("nc", NCOL(DataZoo)), 
	Qualifier = rep("No", NCOL(DataZoo)), 
	Method = rep("No", NCOL(DataZoo)), Source, 
	Sample = rep("No", NCOL(DataZoo)),
	DerivedFrom = NULL, QualityControlLevel, tolerance = 0)

deleteDataValues(ID = NULL, reason = NULL)

updateDataValues(getDataResult, reason = NULL)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{DataZoo}{
  A xts object containing the data. Multiple columns are possible. Either DataZoo or Date and Value needs to be supplied.
}
  \item{Date}{
  A object of class \code{\link{POSIXct}} containing the time information. Either DataZoo or Date and Value needs to be supplied.
}
  \item{Value}{
  A matrix of  containing the values. Either DataZoo or Date and Value needs to be supplied.
}
  \item{ValueAccuracy}{
 Information about the accuracy of the data. 
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
 Information about the cesor used for the observation.  
}
  \item{Qualifier}{
Qualifying information that can note anything unusual or
problematic about individual observations such as, for example, 'holding time for analysis exceeded' or 'incomplete or inexact daily total.'
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
Information about physical samples analyzed in a laboratory to obtain an observation.
}
  \item{DerivedFrom}{
Reference to another record in the database, from which a value was derived.
}
  \item{QualityControlLevel}{
Level of quality controlled applied to a dataset.
}
  \item{tolerance}{
Upon import, it is checked whether a dataset already exists. Tolerance gives the allowed difference between existing and new record, in order to judge them to be the same.
}
  \item{getDataResult}{
A list obtained from getDataResults for updating. The returned results can be modified before resubmitting to the database. If version managament is implemented, deleted and previous versions of records are still available with \code{\link{getDataVersions}}.
}
  \item{ID}{
 Vector of the IDs of the records to be deleted or a list obtained from getDataResults that contains exactly the records to be deleted.
}
  \item{reason}{
 The reason why the records are deleted in plain text.
}
}
\details{
ToDo: write about version management.
To be written. Tell me (see maintainer) if something is missing.
}
\value{
nothing returned
}
\author{
Dominik Reusser
}
\seealso{
To retrieve data from the database, see \code{\link{getDataValues}} and \code{\link{getDataMatrix}}. \code{\link{getDataVersions}} allows to access previous versions of a record, if Version management is implemented by the database system.
}
\examples{
#connect to database
getDefaultDB()

\dontrun{
#connect to postgreSQL database
require("RObsDat")
require("RPostgreSQL")
m <- dbDriver("PostgreSQL")
con <- dbConnect(m, user="a_user", password="secret", dbname="obsdat")
sqhandler <-  new("odm1_1Ver", con=con)
options(odm.handler=sqhandler)

#connect to MySQL database
require("RObsDat")
require("RMySQL")
m <- dbDriver("MySQL")
con <- dbConnect(m, user="a_user", password="secret", dbname="obsdat")
sqhandler <-  new("odm1_1Ver", con=con)
options(odm.handler=sqhandler)

#connect to SQLite database
require("RObsDat")
require("RSQLite")
m <- dbDriver("SQLite")
dbname = "database.db"
con <- dbConnect(m, dbname = dbname)
sqhandler <-  new("odm1_1Ver", con=con)
options(odm.handler=sqhandler)

}

#Store metadata in database
addSite(Code="test", Name="Virtual test site", x=-5, y=46,
	LatLongDatum="WGS84", Elevation=1500, State="Germany")
addVariable(Name="Distance", Unit="cm", ValueType="Field Observation",
	GeneralCategory="Instrumentation", Code="test_dist")
addQualityControlLevel(ID=6,Code="ok", Definition="The default")

addISOMetadata(TopicCategory="Unknown", Title="Testdata",
	Abstract="This data is created to test the functions of RObsDat")
addSource(Organization="Your Org", SourceDescription="Madeup data", 
	SourceLink="RObsDat Documentation", ContactName="Yourself",
	Metadata="Testdata")

library(xts)

example.data <- xts(1:366, seq(as.POSIXct("2010-01-01", tz="UTC"), 
		as.POSIXct("2011-01-01", tz="UTC"), length.out=366))
example.data[50] <- 100
example.data[200] <- 40

addDataValues(example.data[1:100], Site="test", Variable="test_dist",  
	Source="Madeup", QualityControlLevel="ok")
#Avoid duplicates autmatically
addDataValues(example.data, Site="test", Variable="test_dist",  
	Source="Madeup", QualityControlLevel="ok")
inDB <- getDataValues(Site="test")
plot(inDB)

#Version management
to.correct <- which(inDB@values < 100 & 
	index(inDB@values) > as.POSIXct("2010-06-01"))
inDB@values[to.correct] <- 200
inDB@values[50] <- 50

updateDataValues(inDB, "Correction of wrong value")

ver2 <- inDB
ver2@values[50:60] <- 90
updateDataValues(ver2, "Changing more data")

ver3 <- inDB
ver3@values[50:60] <- 190
updateDataValues(ver3, "Ups, I used 90 instead of 190 by mistake")

deleteDataValues(inDB[250],  "And finally remove a value")

getDataVersions()

versionQuery <- getDataValues(Site=1, VersionID=1)

plot(versionQuery)
versionQuery <- getDataValues(Site=1, VersionID=2)
plot(versionQuery)

}
\keyword{ utilities }
