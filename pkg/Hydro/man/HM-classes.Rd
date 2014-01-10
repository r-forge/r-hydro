\name{HM-class}

\docType{class}

\alias{HM-class}
\alias{HMData-class}


\title{HM-classes}

\description{
 \code{HM} is the main class for hydrological modelling within the \code{RHydro} 
 framework, whereas objects of class \code{HMData} are used to describe 
 the observations and predictions. HM-objects are usually created by calls
 to \code{\link{RHydro}}, but can also be created by calls to \code{HM} and 
 \code{HMData}.
 
 A \code{HMData}-object has five slots, of which some or all can be filled with datasets.
 These slots are:
 \itemize{
  \item{Spatial}{a list of \code{\link[sp]{Spatial}}-objects to be used with the 
  hydrological model, typically points 
  or grids. These can also be of class \code{\link[raster]{raster}}.}
  \item{Temporal}{a list of temporal objects to be used with the hydrological model,
  typically of types \code{\link{xts}} or \code{\link[zoo:zoo]{zoo}}}
  \item{SpatioTemporal}{a list of spatio-temporal data to be used with the 
  hydrological model, typically \code{\link[spacetime:ST-class]{spacetime}}-objects
  or alternatively \code{\link[raster:stack]{rasterStack}}-objects.}
  \item{Network}{a list of network objects to be used with the hydrological model, 
  typically \code{\link[sp:SpatialLines]{SpatialLines}} or \code{\link[igraph:igraph]{igraph}}-objects}
  \item{Dots}{a list of additional elements necessary for the hydrological model}
 }
 
 A \code{HM}-object has five slots, of which only the \code{Obs}-slot has to be filled.
 The slots are:
 \itemize{
  \item{Obs}{Object of class \code{HMData}, with the observations}
  \item{Pred}{Object of class \code{HMData} with the prediction/simulation
              results or NULL}
	\item{Parameters}{list with parameters, the elements can be an array or data.frame
	    with parameters, parlims with parameter limits for calibration, or other
	    parameters useful for the model.}
  \item{performance}{the performance criterion for a calibration/validation run, 
        e.g., a Nash-Suitcliffe efficiency}
  \item{control}{list of other elements necessary for simulation or calibration of the model.
        Of particular use is the element "dependent", a character with the name
        of the dependent variable in the list of temporal data for
        calibration/validation.}
}
 


}

\keyword{classes}

