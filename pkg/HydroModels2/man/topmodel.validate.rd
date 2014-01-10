

\name{validate}
\docType{methods}
\alias{validate.topmodel}



\title{Validation function for topmodel-objects}
\description{
This is the validation function for an object of type topmodel.}
\usage{
validate.topmodel(object)
}
\arguments{
  \item{object}{An object of class HM}
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
