\name{observations-class}
\Rdversion{1.1}
\docType{class}
\alias{observations-class}
\alias{observations}
\alias{==,observations,observations-method}
\alias{[,observations-method}
\title{
Observations class - contains data from odm-database
}
\description{
Results from an observation database are returned as observations-class.
}
\section{Objects from the Class}{
Objects are generaly returned from \code{\link{getDataValues}} and can be modified. These modifications can then be fed back into the database using \code{\link{updateDataValues}} -- very similar to a version management system for text.
}
\section{Slots}{
  \describe{
    \item{\code{values}:}{\code{\link{xts}} Object storing the vlaues. One column for each set of values with common attributes}
    \item{\code{ids}:}{xts Object storing the ID for each value}
    \item{\code{derivedFrom}:}{xts Object storing the ID of a related parent record, from which the value was derived}
    \item{\code{attributes}:}{data.frame with attributes describing the data. Use \code{\link{getMetadata}} to optain more information on the attributes}
  }
}
\section{Methods}{
  \describe{
    \item{==}{\code{signature(x = "observations", y = "observations")}: compares data sets }
    \item{[}{\code{signature(object = "observations")}: allows acces to certain rows of the dataset }
}}

\references{
Reusser et al. 2012 - todo add exact reference
}
\author{
Dominik Reusser
}

\examples{
showClass("observations")
}
\keyword{classes}
