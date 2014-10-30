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
See the CUAHSI observations data model (ODM) for more information about the data model.
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
 Information about the censor used for the observation.  
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
Information about physical samples analysed in a laboratory to obtain an observation.
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
A object obtained from getDataResults for updating. The returned results can be modified before resubmitting to the database. By using version management, deleted and previous versions of records are still available with \code{\link{getDataVersions}}.
}
  \item{ID}{
 Vector of the IDs of the records to be deleted or an object obtained from getDataResults that contains exactly the records to be deleted.
}
  \item{reason}{
 The reason why the records are deleted in plain text.
}
}
\details{
Raw data often needs to be cleaned before it can
be used. RObsDat supports this and allows to
reconstruct data modification operations by use of version management.
This is valid for deleted and previous versions.
To be written. Tell me (see maintainer) if something is missing.
}
\value{
nothing returned
}
\author{
Dominik Reusser
}
\seealso{
To retrieve data from the database, see \code{\link{getDataValues}} and \code{\link{getDataValues}}. \code{\link{getDataVersions}} allows to access previous versions of a record, if Version management is implemented by the database system.
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
addQualityControlLevel(ID=6,Code="test_ok", Definition="The default")

addISOMetadata(TopicCategory="Unknown", Title="Testdata",
	Abstract="This data is created to test the functions of RObsDat")
addSource(Organization="Your Org", SourceDescription="Madeup data", 
	SourceLink="RObsDat Documentation", ContactName="Yourself",
	Metadata="Testdata")

library(xts)
library(spacetime)

example.data <- xts(1:40, seq(as.POSIXct("2014-01-01", tz="UTC"), 
		as.POSIXct("2014-02-09", tz="UTC"), length.out=40))
example.data[40] <- 30
example.data[35] <- 22

addDataValues(example.data[1:20], Site="Virtual test site", Variable="test_dist",  
	Source="Madeup", QualityControlLevel="test_ok")
#Avoid duplicates automatically
example.data[15] <- 30
addDataValues(example.data, Site="Virtual test site", Variable="test_dist",  
	Source="Madeup", QualityControlLevel="test_ok")
inDB <- getDataValues(Site="test")
stplot(inDB, mode="ts")

#Version management
inDB <- getDataValues(Site="test")
to.correct <- which(inDB@data > 30)
inDB@data[to.correct,] <- 20
if(NROW(inDB@data)>=30){
   inDB@data[30,] <- 32
   updateDataValues(inDB, "Correction of wrong value")
}

ver2 <- inDB
if(NROW(ver2@data)>=13){
    ver2@data[10:13,] <- 60
    updateDataValues(ver2, "Changing more data")
}

inDB <- getDataValues(Site="test")
ver3 <- inDB
if(NROW(ver3@data)>=32){
   ver3@data[30:32,] <- 33
   updateDataValues(ver3, "Ups, I used 60 instead of 33 by mistake")
}

#If only one time point or one location is selected you have to use '@ValueIDs' in addition.
if(dim(inDB@ValueIDs)[2]>=29) deleteDataValues(inDB@ValueIDs[,29],  "Remove a value")
if(dim(inDB@ValueIDs)[2]>=14) deleteDataValues(inDB@ValueIDs[,10:14],  "Remove several values")

# When more than one spatial point and times are given, then use the usually selection without 'ValueIDs'.
# deleteDataValues(testSiteData[2,20:24],  "Remove several values.")

getDataVersions()

versionQuery1 <- getDataValues(Site=1, VersionID=1)
stplot(versionQuery1, mode="ts")

versionQuery2 <- getDataValues(Site=1, VersionID=2)
stplot(versionQuery2, mode="ts")

}
\keyword{ utilities }
