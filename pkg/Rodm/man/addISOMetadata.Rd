\name{addISOMetadata}
\alias{addISOMetadata}
\alias{addSource}
\title{
Functions to provide reference to data sources
}
\description{
The ISOMetadata table contains dataset and project level metadata required by the CUAHSI HIS
metadata system (http://www.cuahsi.org/his/documentation.html) for compliance with standards
such as the draft ISO 19115 or ISO 8601.

}
\usage{
addISOMetadata(TopicCategory = "Unknown", Title = "Unknown", Abstract = "Unknown", ProfileVersion = "Unknown", MetadataLink = NULL)
addSource(Organization, SourceDescription, SourceLink = NULL, ContactName = "Unknown", Phone = "Unknown", Email = "Unknown", Address = "Unknown", City = "Unknown", State = "Unknown", ZipCode = "Unknown", Citation = "Unknown", Metadata = "Unknown")
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{TopicCategory}{
Reference ot the TopicCategory table, giving the broad ISO19115 
metadata topic category for data from this source. 

}
  \item{Title}{
Title of the data source
}
  \item{Abstract}{
A short abstract characterizing the data source
}
  \item{ProfileVersion}{
Name of the metadata profile used
by the data source
}
  \item{MetadataLink}{
Link to additional metadata
reference material.
}
  \item{Organization}{
Name of the organization that 
collected the data. 
}
  \item{SourceDescription}{
Full text description of the 
source of the data.
}
  \item{SourceLink}{
Link that can be pointed at the
original data file and/or
associated metadata stored in
the digital library or URL of
data source.
}
  \item{ContactName}{
Name of the contact person for
the data source.
}
  \item{Phone}{
Phone number for the contact 
person. 
}
  \item{Email}{
Email address for the contact 
person. 
}
  \item{Address}{
Street address for the contact 
person. 
}
  \item{City}{
City in which the contact 
person is located. 
}
  \item{State}{
State in which the contact 
person is located. Use two 
letter abbreviations for US. 
For other countries give the full 
country name. 
}
  \item{ZipCode}{
US Zip Code or country postal 
code 
}
  \item{Citation}{
Text string that give the 
citation to be used when the 
data from each source are 
referenced. 
}
  \item{Metadata}{
Reference to the metadata table.
}
}
\value{
Nothing is returned
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
addISOMetadata(TopicCategory="inlandWaters", Title="FAOStat land use", MetadataLink="faostat.fao.org/site/377/default.aspx")
addSource(Organization="FAO", SourceDescription="FAO Stat Land Use", SourceLink="http://faostat.fao.org/site/377/default.aspx#ancor", ContactName="AskFAOSTAT: http://www.fao.org/askfao/agriculturalstatisticaldata/en/", Metadata="FAOStat land use")
getMetadata(table="Source", Description="Land Use")
}
\keyword{ utilities }
