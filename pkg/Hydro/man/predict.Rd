\name{predict}
\docType{methods}
\alias{predict}
\alias{predict,HM-method}


\title{RHydro model predictions}
\description{
This is the predict method for HM* objects within the RHydro framework
}
	

\usage{
\S4method{predict}{HM}(object)
}

\arguments{
  \item{object}{An object of class HM, deriving from 
                the \code{\link{HM-class}}}
}
\details{
This is the generic S4 method for hydrological prediction for HMmodel-objects, using the 
model of the \code{\link{HM}}*-object.

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

res = topmodel(HMObject)
res2 = predict(HMObject)
all.equal(res, res2)
}


\keyword{models}
