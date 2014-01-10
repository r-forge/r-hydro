\name{RHydro}
\docType{methods}
\alias{RHydro}
\alias{RHydro,HM,list-method}
\alias{RHydro,character,ANY-method}


\title{Function to create HM-objects}
\description{
This is a function to create \code{\link{HM-class}} objects to be used with the RHydro framework
}
	

\usage{
\S4method{RHydro}{HM,list}(object,newval,...)
\S4method{RHydro}{character,ANY}(object,newval,...)
}

\arguments{
  \item{object}{Either: An object of class HM, deriving from 
                the \code{\link{HM-class}}
                
                Or: The name of the hydrological model to be used with this 
                object.}
  \item{newval}{list of values to add to the object. See \link{HM} 
                 for more details.}
  \item{...}{Instead of adding everything to the newval-list, the slots
             of the HM-object can also be updated/added by referring to them directly.}
}
\details{
This function is used for creating or updating a \link{HM-class}object.

If the object in the function call is the name of a hydrological model,
called model, 
the function creates an object of class \code{HMmodel}, inheriting from
\code{\link{HM-class}} and \code{model-class}, where the last one is a virtual
class created by the model. 

If the object of the function call is already a \code{HMmodel-class} object, 
the function will add or change the elements in \code{newval} or \code{...} to the object.
This can either be used to update the elements of the object, or to add
elements. This is typically used to change parameters, or to add the results of predictions
to the object, although it is also possible to add or modify observations.
}
\value{
An object of \code{HMmodel-class}, inheriting from \code{\link{HM-class}} and 
\code{model-class}}


\examples{
library(HydroModels)
data(huagrahuma)
attach(huagrahuma)
options(error = recover)
#HMObject = RHydro("topmodel", Temporal = list(data = inputs),
#    Parameters = as.list(parameters[1:9]), Dots = list(top = topidx, del = delay))
HMObject = RHydro("topmodel", newval = list(Obs = list(Temporal = list(data = inputs)),
    Parameters = list(param = parameters[1:9], top = topidx, del = delay)))

HMObject1 = RHydro("topmodel", list(Obs = list(Temporal = list(data = inputs)),
    Parameters = list(param = parameters[1:9], top = topidx, del = delay)))

HMObject2 = RHydro("topmodel", Obs = list(Temporal = list(data = inputs)),
    Parameters = list(param = parameters[1:9], top = topidx, del = delay))

HMObject3 = RHydro("topmodel", Temporal = list(data = inputs),
    Parameters = list(param = parameters[1:9], top = topidx, del = delay))
}


\keyword{models}
