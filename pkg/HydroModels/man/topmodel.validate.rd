

\name{validate}
\docType{methods}
\alias{validate}
\alias{validate,topmodel-method}



\title{Validation function for topmodel-objects}
\description{
This is the validation function for an object of type topmodel.}
\usage{
\S4method{validate}{topmodel}(object)
}
\arguments{
  \item{object}{An object of class HMtopmodel, deriving from 
                the superclass \code{\link[Hydro:HM-classes]{HM}} and the virtual class \code{topmodel},
                created automatically by \code{\link[Hydro]{RHydro}}.}
}                                                          
\details{
This is a function which validates an object to be used in \code{\link{topmodel}} simulation of 
runoff. 
The function checks if the parameters are within the predefined limits.

This function is normally not called by the user, it is used automatically when the model is created. 
}
\value{
TRUE if the object is ok, an exception is thrown otherwise.
}


\keyword{models}
