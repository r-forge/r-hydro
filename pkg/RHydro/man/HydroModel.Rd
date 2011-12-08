\name{HydroModel}
\alias{HydroModel}
\title{
Create a HydroModel
}
\description{
This function takes data and returns a new HydroModel-object, which can then be used to do hydrological simulations
}
\usage{
HydroModel(model, parameters, data, ...)
}
\arguments{
  \item{model}{
  character: Name of the model
}
  \item{parameters}{
  data.frame with the required parameters
}
  \item{data}{
  A list of data required to run the model.
}
  \item{\dots}{
  Other arguments stored in the dots-slot of the HydroModel-class
}
}
\value{
A \code{\link{HydroModel-class}}-Object of
}
\author{
Dominik Reusser and Wouter Buytaerd
}

\seealso{
\code{\link{HydroModel-class}}
}
\examples{
data(huagrahuma)
mymodel <- HydroModel("topmodel", huagrahuma$parameters[1:9], 
 	huagrahuma$inputs, delay = huagrahuma$delay,
        topidx = huagrahuma$topidx)
predictions <- predict(mymodel, probs=c(0.05, 0.95))
}
\keyword{ ~Hydrology }
\keyword{ utilities }
\keyword{ ~modelling }
