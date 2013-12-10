\name{HydroTopmodelParameters-class}
\docType{class}
\alias{HydroTopmodelParameters-class}
\alias{plot,HydroTopmodelParameters,ANY-method}
\alias{print,HydroTopmodelParameters-method}
\alias{coerce,numeric,HydroTopmodelParameters-method}
\alias{coerce,matrix,HydroTopmodelParameters-method}
\alias{coerce,HydroModelParameters,HydroTopmodelParameters-method}

\title{Class "HydroTopmodelParameters"}
\description{	 Implementation of
\code{\linkS4class{HydroModelParameters}} for Topmodel }
\section{Objects from the Class}{
Objects can be created by calls of the form \code{new("HydroTopmodelParameters", ...)}.
 
ToDo
}
\section{Slots}{
   see \code{"\linkS4class{HydroModelParameters}"}
	 }
\section{Extends}{
Class \code{"\linkS4class{HydroModelParameters}"}, directly.
}
\section{Methods}{
  \describe{
    \item{plot}{\code{signature(x = "HydroTopmodelParameters", y = "ANY")}: ... }
    \item{print}{\code{signature(x = "HydroTopmodelParameters")}: ... }
    \item{coerce}{\code{signature(from = "numeric", to = "HydroTopmodelParameters")}: ... }
    \item{coerce}{\code{signature(from = "matrix", to = "HydroTopmodelParameters")}: ... }
    \item{coerce}{\code{signature(from = "HydroModelParameters", to = "HydroTopmodelParameters")}: ... }
	 }
}
\references{ thePaper }
\author{ Dominik Reusser, Wouter Buytaert }

\seealso{
	\code{\link{topmodel}}
}
\examples{
showClass("HydroTopmodelParameters")
}
\keyword{classes}
