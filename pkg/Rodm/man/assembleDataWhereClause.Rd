\name{assembleDataWhereClause}
\alias{assembleDataWhereClause}
\alias{expand.where}
\title{
Internal functions to generate a where clause for access to the DataValues table.
}
\description{
These functions is used to avoid code repetition
}
\usage{
assembleDataWhereClause(ID = NULL, from = NULL, to = NULL, SiteID = NULL, VariableID = NULL, Offset = NULL, OffsetTypeID = NULL, CensorCode = NULL, QualifierID = NULL, MethodID = NULL, SourceID = NULL, SampleID = NULL, DerivedFromID = NULL, QualityControlLevelID = NULL, exact = FALSE)

expand.where(w.o, var, var.name, exact = TRUE, isnumeric=FALSE)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{ID}{
  RecordID
}
  \item{from}{
 Start date
}
  \item{to}{
 End date
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
  \item{exact}{
Boolean indicating if search terms should be matched exactly or used as partial search terms (like \%\% notation in SQL). Actually, this has no influence on assembleDataWhereClause.
}
  \item{w.o}{
  DataFrame with the "where object" (see code)
}
  \item{var}{
  The value of the variable
}
  \item{var.name}{
  The name of the variable
}
  \item{isnumeric}{
  Boolean indicating if variable is of type numeric (and does not need to be quoted)
}
}
\details{
What to add?
}
\value{
assembleDataWhereClause returns the where clause string including the WHERE statement.

exand.where returns the updated w.o.
}
\author{
Dominik Reusser
}

\seealso{
See Also as \code{\link{odm1_1-class}}
}
\examples{
#See code
}
\keyword{ utilities }
\keyword{ internal }
