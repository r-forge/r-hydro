\name{addVariable}
\alias{addVariable}
\title{
Add an entry to the variables table
}
\description{
The Variables table lists the full descriptive information about what variables have been
measured. This functions allows to add an entry.
}
\usage{
addVariable(Code, Name, Speciation = rep("Unknown", NROW(Code)), Unit,
	SampleMedium = rep("Unknown", NROW(Code)), 
	ValueType = rep("Unknown", NROW(Code)), 
	IsRegular = rep("True", NROW(Code)), 
	TimeSupport = rep(0, NROW(Code)), 
	TimeUnits = rep("Julian year", NROW(Code)), 
	DataType = rep("Unknown", NROW(Code)), 
	GeneralCategory = rep("Unknown", NROW(Code)), 
	NoDataValue = rep(-999999, NROW(Code)))
}
\arguments{
  \item{Code}{
Text code used by the 
organization that collects the 
data to identify the variable. 
}
  \item{Name}{
Full text name of the variable 
that was measured, observed, 
modeled. Refers to the controlled vocabulary.
}
  \item{Speciation}{
Text code used to identify how
the data value is expressed (i.e.,
total phosphorus concentration
expressed as P). This should be
from the SpeciationCV
controlled vocabulary table.
}
  \item{Unit}{
the units of the data
values associated with the
variable.
Referes to the Units controled vocabulary.
}
  \item{SampleMedium}{
The medium in which the
sample or observation was taken
or made. This should be from
the SampleMediumCV
controlled vocabulary table.
}
  \item{ValueType}{
Text value indicating what type
of data value is being recorded.
This should be from the
ValueTypeCV controlled
vocabulary table.
}
  \item{IsRegular}{
Value that indicates whether the
data values are from a regularly
sampled time series.
}
  \item{TimeSupport}{
Numerical value that indicates
the time support (or temporal
footprint) of the data values. 0 is
used to indicate data values that
are instantaneous. Other values
indicate the time over which the
data values are implicitly or
explicitly averaged or
aggregated.
}
  \item{TimeUnits}{
Integer identifier that references
the record in the Units table
giving the Units of the time
support. If TimeSupport is 0,
indicating an instantaneous
observation, a unit needs to still
be given for completeness,
although it is somewhat
arbitrary.
}
  \item{DataType}{
Text value that identifies the
data values as one of several
types from the DataTypeCV
controlled vocabulary table.
}
  \item{GeneralCategory}{
General category of the data
values from the
GeneralCategoryCV controlled
vocabulary table.
}
  \item{NoDataValue}{
Numeric value used to encode
no data values for this variable.
}
}
\details{
What is missing?
}
\value{
Nothing is returned
}
\author{
Dominik Reusser
}
\seealso{
 \code{\link{updateCV}} to retrieve the vocabularies from the CUASHI web service and update the database. \code{\link{getMetadata}}  allows to query for meta data.
}
\examples{
#connect to standard database
getDefaultDB()
#add data
addVariable(Code="00060", Name="Discharge", Speciation = "Unknown", 
	Unit="m^3/s", SampleMedium = "Not Relevant", 
	ValueType = "Field Observation", TimeSupport = 0, 
	DataType = "Unknown", GeneralCategory = "Hydrology")
getMetadata("Variable", Name="Discharge")
}
\keyword{ utilities }
