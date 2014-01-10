\name{RHydro}
\docType{methods}
\alias{RHydro}


\title{Function to create HM-objects}
\description{
This is a function to create \code{\link{HM-class}} objects to be used with the RHydro framework
}
	

\usage{
RHydro(object, newval, model,  ...) 
}

\arguments{
  \item{object}{An object of class HM, deriving from 
                the \code{\link{HM-class}}, to be updated}
  \item{newval}{list of values to add to the existing or the new object. See \link{HM} 
                 for more details.}
  \item{model}{name of model}
  \item{...}{Instead of adding everything to the newval-list, the slots
             of the HM-object can also be updated/added by referring to them directly.}
}
\details{
This function is used for creating or updating a \link{HM-class}object.

If the object of the function call is already a \code{\link{HM-class}} object, 
the function will add or replace the elements of \code{newval} or \code{...} to the object.
This can either be used to update the elements of the object, or to add
elements. This is typically used to change parameters, or to add the results of predictions
to the object, although it is also possible to add or modify observations.

If \code{object} is not given as argument, the arguments are used to create a new \code{HM}-object.
      

}
\value{
An object of \code{HM-class}}


\examples{
library(HydroModels2)
data(huagrahuma)
attach(huagrahuma)
options(error = recover)
#HMObject = RHydro("topmodel", Temporal = list(data = inputs),
#    Parameters = as.list(parameters[1:9]), Dots = list(top = topidx, del = delay))
HMObject = RHydro(model = "topmodel", newval = list(Obs = list(Temporal = list(data = inputs)),
    Parameters = list(param = data.frame(parameters = parameters[1:9])), Dots = list(top = topidx, del = delay)))

HMObject1 = RHydro(model = "topmodel", newval = list(Obs = list(Temporal = list(data = inputs)),
    Parameters = list(param = data.frame(parameters = parameters[1:9])), Dots = list(top = topidx, del = delay)))

HMObject2 = RHydro(model = "topmodel", Obs = list(Temporal = list(data = inputs)),
    Parameters = list(param = data.frame(parameters = parameters[1:9])), Dots = list( top = topidx, del = delay))

HMObject3 = RHydro(model = "topmodel", Temporal = list(data = inputs),
    Parameters = list(param = data.frame(parameters = parameters[1:9])), Dots = list(top = topidx, del = delay))

}


\keyword{models}
