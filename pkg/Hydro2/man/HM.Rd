\name{HM}

\docType{methods}

\alias{HM}
\alias{HM,ANY-method}
\alias{HMData}
\alias{HMData,ANY-method}
\alias{HMPar}
\alias{HMPar,ANY-method}

\alias{updateHMData}
\alias{updateParameters}
\alias{HMobs}
\alias{HMpred}
\alias{HMparameters}
\alias{HMdots}
\alias{HMcontrol}
\alias{HMnetwork}
\alias{HMtemporalData}
\alias{HMspatialData}
\alias{HMspatiotemporalData}

\title{Create and manipulate HM and HMData objects}

\usage{
\S4method{HM}{ANY}(...)
\S4method{HMData}{ANY}(...)
\S4method{HMPar}{ANY}(...)
updateHMData(HMD, newdata)
updateParameters(obPars, Parameters)
}
\arguments{
  \item{...}{This is a list of the elements which should be a part of the objects.
             For \code{HM}-objects, these are:
             \itemize{
             
             	slots = c(Obs = "HMData", #CalibData = "HMDataOrNull",
            Pred = "list", Dots = "list", Parameters = "list", 
            performance = "list", control = "list"),

             
               \item{Obs}{Object of class \code{HMData}, with the observations}
               \item{Pred}{An empty list (default) or a named list of 
                          \code{HMData}-objects with  with the prediction/simulation
                          results from each model, with the names equal to model name.}
               \item{Dots}{a list of additional elements useful for one or
                           more hydrological models}
               \item{Parameters}{A named list with \code{HMPar}-parameters, 
                      with the names equal to model name.}
               \item{performance}{a named list with the performance results for 
                       calibration/validation runs, 
                       e.g., a Nash-Suitcliffe efficiencies}
               \item{control}{list of other elements necessary for simulation or calibration of the model.
                     Of particular use is the element "dependent", a character with the name
                     of the dependent variable in the list of temporal data for
                     calibration/validation.}
             }

             For \code{HMData}-objects, these are:
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
            For \code{HMPar}-objects, these are:
             \itemize{
               \item{parameters}{numeric array or data.frame with parameters, 
                     multiple sets are possible for some models, one in each column} 
               \item{model}{model name}
               \item{parlims}{list of parameter limits, with parupper and parlower 
                              as element names.}
             }  
          }
  \item{HMD}{object of class HM}
  \item{newdata}{A list of updated data sets for the \code{HMData}-object }
  \item{obPars}{a list with the original object parameters}
  \item{Parameters}{a list of \code{HMPar}-parameter sets for updating object parameters,
                    or a named list with the parameters for HMPar as a sublist}
}
             


\description{
 \code{HM} is the default function for generating HM-objects,
 whereas \code{HMData} can be used to generate data objects. 
 These are used to describe 
 the observations and predictions. HM-objects are usually created by calls
 to \code{\link{RHydro}}.
 

 \code{HMPar} generates parameter objects. The object currently has three elements,
the parameters themselves (data.frame or numeric), the name of the model and
the upper and lower bounds for calibration as numeric arrays.


There is also a set of functions which can be used to extract data from \code{HM}
and \code{HMData} objects.

\itemize{
\item{HMobservations}{extracts the observations from the \code{HM}-object}
\item{HMpredictions}{extracts the predictions from the \code{HM}-object}
\item{HMparameters}{extracts the parameters from the \code{HM}-object}
\item{HMcontrol}{extracts the control parameters from the \code{HM}-object}
\item{HMtemporalData}{extracts the temporal data from from the \code{HMData}-object}
\item{HMspatialData}{extracts the spatial data from the \code{HMData}-object}
\item{HMspatiotemporalData}{extracts the spatio-temporal data from the \code{HMData}-object}
\item{HMnetwork}{extracts the network data from the \code{HMData}-object}
\item{HMdots}{extracts the dots from the \code{HMData}-object}


}

There are also two functions for updating \code{HMData} objects and the 
parameters of a \code{HM}-object.


}

\keyword{classes}

