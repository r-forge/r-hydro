\name{addQualityControlLevel}
\alias{addQualityControlLevel}
\title{
	Add Quality metadata vocabulary
}
\description{
	Define the level of quality control
processing that the data value has been subjected to
}
\usage{
addQualityControlLevel(ID, Code, Definition, Explanation = "")
}
\arguments{
  \item{ID}{
	  numerical ID
}
  \item{Code}{
	  Short code for quality control level
}
  \item{Definition}{
	  Exact definition of the level
}
  \item{Explanation}{
	  Further explanations
}
}
\details{
	From QUASHI documentation:
	UAHSI ODM is consistent with the practice of other data systems:

- QualityControlLevelCode = "0" - Raw Data
     Raw data is defined as unprocessed data and data products that have not undergone quality
    control. Depending on the data type and data transmission system, raw data may be available
   within seconds or minutes after real-time. Examples include real time precipitation,
  streamflow and water quality measurements.

- QualityControlLevelCode = "1" - Quality Controlled Data
       Quality controlled data have passed quality assurance procedures such as routine estimation
      of timing and sensor calibration or visual inspection and removal of obvious errors. An
     example is USGS published streamflow records following parsing through USGS quality
    control procedures.
- QualityControlLevelCode = "2" - Derived Products

       Derived products require scientific and technical interpretation and include multiple-sensor
      data. An example might be basin average precipitation derived from rain gages using an
     interpolation procedure.

- QualityControlLevelCode = "3" - Interpreted Products
       These products require researcher (PI) driven analysis and interpretation, model-based
      interpretation using other data and/or strong prior assumptions. An example is basin average
     precipitation derived from the combination of rain gages and radar return data.

- QualityControlLevelCode = "4" - Knowledge Products
       These products require researcher (PI) driven scientific interpretation and multidisciplinary
      data integration and include model-based interpretation using other data and/or strong prior
     assumptions. An example is percentages of old or new water in a hydrograph inferred from
    an isotope analysis.

These definitions for quality control level are stored in the QualityControlLevels table. These
definitions are recommended for use, but users can define their own quality control level system.
The QualityControlLevels table is not a controlled vocabulary, but specification of a quality
control level for each data value is required. 

}
\value{
	Nothing returned
}
\references{
	CUAHSI Community Observations Data Model (ODM), Version 1.1,
Design Specifications

}
\author{
	Dominik Reusser / QUASHI
}

\seealso{
 \code{\link{addDataValues}}
}
\examples{
getDefaultDB()

addQualityControlLevel(ID=1,Code="1", Definition="Quality Controlled Data", 
	Explanation="Quality controlled data have passed quality assurance
	procedures such as routine estimation of timing and sensor calibration
	or visual inspection and removal of obvious errors. An example is USGS
	published streamflow records following parsing through USGS 
	quality control procedures.")
}
\keyword{ utility }
\keyword{ ~odm }% __ONLY ONE__ keyword per line
