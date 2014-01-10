

\name{validate}
\docType{methods}
\alias{validate}
\alias{validate,HM-method}



\title{Validation function for HM-objects}
\description{
  This is the validation function for HM-object.}
\usage{
\S4method{validate}{HM}(object)
}
\arguments{
  \item{object}{An object of \code{\link{HM-class}} }
}
\details{
This is a function which validates a HM-object. The default version 
is not really useful, this is just to create the generic to be used
by different models.
This function is not called by the user, it is used automatically when the model is created. 
}
\value{
TRUE if the object is ok, an exception is thrown otherwise.
}


\keyword{models}
