\name{odm1_1-class}
\Rdversion{1.1}
\docType{class}
\alias{odm1_1-class}
\alias{IaddCV,odm1_1-method}
\alias{IaddDataValues,odm1_1-method}
\alias{IaddDataVersion,odm1_1-method}
\alias{IaddISOMetadata,odm1_1-method}
\alias{IaddSite,odm1_1-method}
\alias{IaddSource,odm1_1-method}
\alias{IaddSpatialReferences,odm1_1-method}
\alias{IaddSynonym,odm1_1-method}
\alias{IaddUnits,odm1_1-method}
\alias{IaddVariable,odm1_1-method}
\alias{IarchiveDataValues,odm1_1-method}
\alias{IdbState,odm1_1-method}
\alias{IdeleteDataValues,odm1_1-method}
\alias{IgetCensorCode,odm1_1-method}
\alias{IgetCurrentDataVersion,odm1_1-method}
\alias{IgetCV,odm1_1-method}
\alias{IgetDataType,odm1_1-method}
\alias{IgetDataValues,odm1_1-method}
\alias{IgetDataVersions,odm1_1-method}
\alias{IgetGeneralCategory,odm1_1-method}
\alias{IgetISOMetadata,odm1_1-method}
\alias{IgetMethods,odm1_1-method}
\alias{IgetNo,odm1_1-method}
\alias{IgetOffsetTypes,odm1_1-method}
\alias{IgetOldDataValues,odm1_1-method}
\alias{IgetQualifiers,odm1_1-method}
\alias{IgetQualityControlLevels,odm1_1-method}
\alias{IgetSampleMedium,odm1_1-method}
\alias{IgetSamples,odm1_1-method}
\alias{IgetSampleType,odm1_1-method}
\alias{IgetSite,odm1_1-method}
\alias{IgetSource,odm1_1-method}
\alias{IgetSpatialReferences,odm1_1-method}
\alias{IgetSpeciation,odm1_1-method}
\alias{IgetSynonymID,odm1_1-method}
\alias{IgetTopicCategory,odm1_1-method}
\alias{IgetUnits,odm1_1-method}
\alias{IgetValueType,odm1_1-method}
\alias{IgetVariable,odm1_1-method}
\alias{IgetVariableName,odm1_1-method}
\alias{IgetVerticalDatum,odm1_1-method}
\alias{IupdateDataValues,odm1_1-method}
\alias{odm1_1Ver-class}
\alias{IaddDataVersion,odm1_1Ver-method}
\alias{IarchiveDataValues,odm1_1Ver-method}
\alias{IdbState,odm1_1Ver-method}
\alias{IgetCurrentDataVersion,odm1_1Ver-method}
\alias{IgetDataVersions,odm1_1Ver-method}
\alias{IgetOldDataValues,odm1_1Ver-method}


\title{Classes \code{"odm1_1"} and \code{"odm1_1Ver"}}
\description{
Observations data works with a hidden layer, in which the commands are translated into SQL-queries and submitted to the database server. The two classes implement this hidden layer. \code{"odm1_1Ver"} also provides mechanisms to a simple version management system as described in Reusser et. al 2012.
}
\section{Objects from the Class}{
Objects can be created by calls of the form \code{new("odm1_1", con=connection)}and \code{new("odm1_1Ver", con=connection)}.
The objects store the database connection object returned by \code{\link{dbConnect}} in the only slot.
}
\section{Slots}{
  \describe{
    \item{\code{con}:}{Object of class \code{"DBIConnection"} returned by \code{\link{dbConnect}} }
  }
}
\section{Extends}{
odm1_1Ver extends class odm1_1 directly.
}
\section{Methods}{
  \describe{
    \item{IaddCV}{\code{signature(object = "odm1_1")}: ... }
    \item{IaddDataValues}{\code{signature(object = "odm1_1")}: ... }
    \item{IaddDataVersion}{\code{signature(object = "odm1_1")}: ... }
    \item{IaddISOMetadata}{\code{signature(object = "odm1_1")}: ... }
    \item{IaddSite}{\code{signature(object = "odm1_1")}: ... }
    \item{IaddSource}{\code{signature(object = "odm1_1")}: ... }
    \item{IaddSpatialReferences}{\code{signature(object = "odm1_1")}: ... }
    \item{IaddSynonym}{\code{signature(object = "odm1_1")}: ... }
    \item{IaddUnits}{\code{signature(object = "odm1_1")}: ... }
    \item{IaddVariable}{\code{signature(object = "odm1_1")}: ... }
    \item{IarchiveDataValues}{\code{signature(object = "odm1_1")}: ... }
    \item{IdbState}{\code{signature(object = "odm1_1")}: ... }
    \item{IdeleteDataValues}{\code{signature(object = "odm1_1")}: ... }
    \item{IgetCensorCode}{\code{signature(object = "odm1_1")}: ... }
    \item{IgetCurrentDataVersion}{\code{signature(object = "odm1_1")}: ... }
    \item{IgetCV}{\code{signature(object = "odm1_1")}: ... }
    \item{IgetDataType}{\code{signature(object = "odm1_1")}: ... }
    \item{IgetDataValues}{\code{signature(object = "odm1_1")}: ... }
    \item{IgetDataVersions}{\code{signature(object = "odm1_1")}: ... }
    \item{IgetGeneralCategory}{\code{signature(object = "odm1_1")}: ... }
    \item{IgetISOMetadata}{\code{signature(object = "odm1_1")}: ... }
    \item{IgetMethods}{\code{signature(object = "odm1_1")}: ... }
    \item{IgetNo}{\code{signature(object = "odm1_1")}: ... }
    \item{IgetOffsetTypes}{\code{signature(object = "odm1_1")}: ... }
    \item{IgetOldDataValues}{\code{signature(object = "odm1_1")}: ... }
    \item{IgetQualifiers}{\code{signature(object = "odm1_1")}: ... }
    \item{IgetQualityControlLevels}{\code{signature(object = "odm1_1")}: ... }
    \item{IgetSampleMedium}{\code{signature(object = "odm1_1")}: ... }
    \item{IgetSamples}{\code{signature(object = "odm1_1")}: ... }
    \item{IgetSampleType}{\code{signature(object = "odm1_1")}: ... }
    \item{IgetSite}{\code{signature(object = "odm1_1")}: ... }
    \item{IgetSource}{\code{signature(object = "odm1_1")}: ... }
    \item{IgetSpatialReferences}{\code{signature(object = "odm1_1")}: ... }
    \item{IgetSpeciation}{\code{signature(object = "odm1_1")}: ... }
    \item{IgetSynonymID}{\code{signature(object = "odm1_1")}: ... }
    \item{IgetTopicCategory}{\code{signature(object = "odm1_1")}: ... }
    \item{IgetUnits}{\code{signature(object = "odm1_1")}: ... }
    \item{IgetValueType}{\code{signature(object = "odm1_1")}: ... }
    \item{IgetVariable}{\code{signature(object = "odm1_1")}: ... }
    \item{IgetVariableName}{\code{signature(object = "odm1_1")}: ... }
    \item{IgetVerticalDatum}{\code{signature(object = "odm1_1")}: ... }
    \item{IupdateDataValues}{\code{signature(object = "odm1_1")}: ... }
    \item{IaddDataVersion}{\code{signature(object = "odm1_1Ver")}: ... }
    \item{IarchiveDataValues}{\code{signature(object = "odm1_1Ver")}: ... }
    \item{IdbState}{\code{signature(object = "odm1_1Ver")}: ... }
    \item{IgetCurrentDataVersion}{\code{signature(object = "odm1_1Ver")}: ... }
    \item{IgetDataVersions}{\code{signature(object = "odm1_1Ver")}: ... }
    \item{IgetOldDataValues}{\code{signature(object = "odm1_1Ver")}: ... }
	 }
}
\references{
Reusser et al. 2012 - todo add exact reference
}
\author{
Dominik Reusser
}

\examples{
showClass("odm1_1")
showClass("odm1_1Ver")

	require(RSQLite)
	m <- dbDriver("SQLite")
	con <- dbConnect(m, dbname = "RODM.db")

	#dbGetQuery(con, "SELECT * FROM Versions")
	sqhandler <-  new("odm1_1Ver", con=con)
	options(odm.handler=sqhandler)
   
        getMetadata("VariableName")
}
\keyword{classes}
