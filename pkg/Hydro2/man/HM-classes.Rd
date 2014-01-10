\name{HM-class}

\docType{class}

\alias{HM-class}
\alias{HMData-class}
\alias{HMPar-class}

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
 }
 
 A \code{HM}-object has five slots, of which only the \code{Obs}-slot has to be filled.
 The slots are:
 \itemize{
  \item{Obs}{Object of class \code{HMData}, with the observations}
  \item{Pred}{A named list \code{HMData}-objects with the prediction/simulation
              results or NULL}
  \item{Dots}{a list of additional elements necessary for the hydrological model}
	\item{Parameters}{a named list with HMPar-objects, with names equal to
                    model names}
  \item{performance}{a list of the performance criterion for calibration/validation runs, 
        e.g., a Nash-Suitcliffe efficiencies}
  \item{control}{list of other elements necessary for simulation or calibration of the model.
        Of particular use is the element "dependent", a character with the name
        of the dependent variable in the list of temporal data for
        calibration/validation.}

  A \code{HMPar}-object has three slots:
  \itemize{
    \item{parameters}{numeric array or data.frame with parameters}
    \item{model}{the name of the model}
    \item{parlims}{list with parameter bounds, upper and lower with names parupper and parlower}
  }

}
 


}

\keyword{classes}

