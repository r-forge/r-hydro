\name{plot-HydroRun}
\docType{methods}
\alias{plot,HydroRun,ANY-method}
\title{ Plot Funtion for the HydroRun class}
\description{
Plot Funtion for the HydroRun class
}
\usage{
plot(x, y, 
              hydro.plot.type=c("rainfall-runoff", "by.data.type", "by.station", "balance"),
              data.class=c("modelledFluxes", "modelledStates", "measuredFluxes", "measuredStates"),
              data.types=get.data.types(x, data.class=data.class),
              stations=get.stations(x, data.class=data.class),
              balance.types=unique(unlist(strsplit(rhydro.data.types$balance.type, ", *"))),
              legend.position="right",
              runs=1:get.runCount(x),
              ...
    )
}
\arguments{
   \item{x}{HydroModelRun object}
   \item{y}{unused}
   \item{hydro.plot.type}{hydro plot type? c("rainfall-runoff", "by.data.type", "by.station", "balance")}
   \item{data.class}{which RHydro data class to plot?}
   \item{data.types}{which RHydro data types to plot?}
   \item{stations}{which stations to plot?}
   \item{balance.types}{which balance types to plot?}
   \item{legend.position}{position of the legend for the ... plot}
   \item{runs}{vector of integers, indicating which runs to plot}
   \item{...}{passed to plot method in methods plot types ...}
}
\keyword{methods}
