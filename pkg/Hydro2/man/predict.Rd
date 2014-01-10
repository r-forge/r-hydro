\name{predict}
\docType{methods}
\alias{predict}
\alias{predict,HM-method}


\title{RHydro model predictions}
\description{
This is the predict method for HM* objects within the RHydro framework
}
	

\usage{
\S4method{predict}{HM}(object, model)
}

\arguments{
  \item{object}{An object of class HM, deriving from 
                the \code{\link{HM-class}}}
  \item{model}{When object is a multimodel-object, model specifies which 
                model to predict}
}
\details{
This is the generic S4 method for hydrological prediction for HMmodel-objects, using the 
model of the \code{\link{HM}}*-object.

The function predicts for all models in a multimodel object unless model is specified.
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
res = topmodel(HMObject)
res2 = predict(HMObject)
str(res)
all.equal(res, res2)
}


\keyword{models}
