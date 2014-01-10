\name{HMObjectiveFunction}
\docType{methods}
\alias{HMObjectiveFunction}


\title{Default objective function }
\description{
Default objective function for calibration of hydrological models within the RHydro framework.
}
	

\usage{
HMObjectiveFunction(parameters, object, gof = "NSE", ...)
}

\arguments{
  \item{parameters}{The new parameter set for the object to be simulated}
  \item{object}{an object of \code{\link{HM-class}}}
  \item{gof}{The goodness-of-fit-measure to be used for optimization. Nash-Suitcliffe
             efficiency (NSE) is the default, other methods are interpreted as one
             of the measures from the \code{\link[hydroGOF:hydroGOF]{hydroGOF}} package}
  \item{...}{not used, necessary for implementation purposes}
}
\details{
This is the default objective function to be used within the RHydro framework.
It can compute a single-objective goodness-of-fit-measure for a simulated time series, compared
with the observations. The function is usually not called by the user,
it is used in the function \code{\link{calibrate}}


}
\value{
A goodness-of-fit measure for the time series.}


\examples{
require(HydroModels2)
data(huagrahuma2)
HMObject = RHydro("topmodel", Temporal = list(data = inputs),
    Parameters = list(parameters = parameters[1:9], top = topidx, del = delay),
    control = list(dependent = "Q"))
res2 = predict(HMObject)
HMObjectiveFunction(parameters[1:9], HMObject)
HMObjectiveFunction(2*parameters[1:9], HMObject)
}


\keyword{models}
