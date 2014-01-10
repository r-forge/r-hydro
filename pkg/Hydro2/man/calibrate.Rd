\name{calibrate}
\docType{methods}
\alias{calibrate}
\alias{calibrate,HM-method}


\title{Calibration of hydrological models}
\description{
Function for calibration of hydrological models within the RHydro framework
}
	

\usage{
\S4method{calibrate}{HM}(object, models, method = "sce", objectiveFunction = NULL, ...)
}

\arguments{
  \item{object}{An object derived from \code{\link{HM-class}}}
  \item{models}{which models to optimize, if missing, all models of object are optimized}
  \item{method}{Optimization method. The only method currently implemented is 
                Shuffle complex evolution, from the function \code{\link{sceua}}}
  \item{objectiveFunction}{This is the name of alternatives to the default objective function.
                If objectiveFunction = NULL, the default 
                \code{\link{HMObjectiveFunction}} is used,
                unless there is a particular method implemented for the model.}
  \item{...}{other parameters which are passed to the optimization method and the 
             objective function}
}
\details{
This function can be used to calibrate hydrological models within the RHydro framework. 
The default version assumes that the model predicts a time series,
corresponding to the observation in the temporal slot of the observations with 
then name given in control$dependent. See also \code{\link{HM-class}}

The calibration function can use different objective functions, currently
only of single-objective type. 

}
\value{
An object of \code{HMmodel-class}, with the optimized parameter set in the
parameter slot and the calibration result as the prediction.}


\examples{
require(HydroModels2)
options(error = recover)
data(huagrahuma2)
parlower = parameters*(ifelse(parameters < 0, 4, 0.25))
parupper = parameters*(ifelse(parameters < 0, 0.25, 4))

HMObject = RHydro(model = "topmodel", Temporal = list(data = inputs),
                  Parameters = list(parameters = data.frame(parameters = parameters[1:9]), 
                                    parlims = list(parlower = parlower[1:9], 
                                    parupper = parupper[1:9])),  
                  Dots = list(top = topidx, del = delay),
                  control = list(dependent = "Q"))
pp = predict(HMObject)
HMCalib = calibrate(HMObject, maxn = 100) # Use higher 
                                          # value for maxn for real applications
}


\keyword{models}
