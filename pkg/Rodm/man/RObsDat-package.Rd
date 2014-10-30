\name{RObsDat-package}
\alias{RObsDat-package}
\alias{RObsDat}
\docType{package}
\title{
R-Package to the observations Data Model from CUAHSI
}
\description{
This package provides classes and functions for handling observational (spatio-temporal) data. 

The package provides a number of feature for your convenience:
- Automatic retrieval of standard vocabularies from CUAHSI.
- Fuzzy matching of terms for more convenient insertion.
- Automatic handling of synonyms for more convenient data processing. 

Note: tell me what additional questions should be answered here.

The package has a large number of dependencies. To install, use the following command:

\code{install.packages(c("spacetime", "sp", "testthat","XMLSchema", "SSOAP", "xts", "vwr", "RSQLite"), repos = c("http://www.omegahat.org/R", "http://mirrors.softliste.de/cran"))}
}
\details{
Use \code{\link{addDataValues}} to store data in the database.

Use \code{\link{getMetadata}} and \code{\link{getDataValues}} to retrieve information from the database.
}
\author{
Dominik Reusser

Maintainer: Dominik Reusser <reusser@pik-potsdam.de>
}
\references{
Reusser et al. 2012: Todo add details
}
\keyword{ package }
\examples{
	example(addDataValues)
	example(updateValues)
}
