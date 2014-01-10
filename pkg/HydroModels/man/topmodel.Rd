\name{topmodel}
\docType{methods}
\alias{topmodel}
\alias{topmodel,HM-method}
\alias{topmodel,numeric-method}



\title{Implementation of the hydrological model TOPMODEL}
\description{
This is an implementation of the 1995 Fortran version of the hydrological model TOPMODEL, originally developed by Keith Beven.
}
\usage{
\S4method{topmodel}{HM}(object,...)
\S4method{topmodel}{numeric}(object,data,delay,topidx,pm= c("NS"),return.simulations=TRUE,verbose=FALSE)
}
\arguments{
  \item{object}{Either: An object of class \code{\link[Hydro]{HM}}, or an array/data.frame 
                with the parameters for the model. }
  \item{data}{A list of vectors or zoo time series, containing at least a member called ``prec'' (precipitation) and ``PET'' (potential evapotranspiration). ``Qobs'' may also be given, in which the Nash-Sutcliffe efficiency is calculated directly}
  \item{delay}{Delay function for overland flow (see below)}
  \item{topidx}{An object returned from the \code{\link{topidx}} method}
  \item{pm}{Return a performance measure rather than the simulated discharge. Currently only "NS" is implemented.}
  \item{return.simulations}{If set to TRUE, returns predicted discharge time series}
  \item{verbose}{If set to TRUE, returns besides predicted discharge also overland flow, base flow and storage}
  \item{...}{Additional arguments (currently none implemented)}
}
\details{
topmodel() automatically implements a Monte Carlo simulation. If the parameter argument is a single vector, the model is run once. If the parameter argument is a matrix, each row should represent a parameter set. In that case, the model is run with each parameter set (see the examples below).

A single parameter set consists of: \code{c(qs0,lnTe,m,Sr0,SrMax,td,vr,k0,CD,dt)}, with:

\tabular{ll}{
qs0     \tab Initial subsurface flow per unit area [m]\cr
lnTe 	\tab log of the areal average of T0 [m2/h]\cr
m	\tab Model parameter controlling the rate of decline of transmissivity in the soil profile, see Beven, 1984\cr
Sr0 	\tab Initial root zone storage deficit [m]\cr
Srmax 	\tab Maximum root zone storage deficit [m]\cr
td 	\tab Unsaturated zone time delay per unit storage deficit\cr
vr 	\tab channel flow inside catchment [m/h]\cr
k0 	\tab Surface hydraulic conductivity [m/h]\cr
CD 	\tab capillary drive, see Morel-Seytoux and Khanji (1974)\cr
dt 	\tab The timestep [h]\cr
}

The topidx dataframe can be derived conveniently with \code{link{make.classes()}}. 
It should contain 2 columns. The first column should give the lower boundary of each topographic index class, and the second column should give the respective area fraction. The second column must sum to 1.

Parameters k0 is only used in the unsaturated zone time delay funtion if td<0.

Overland flow is routed through a delay function which represents the time spent in the channel system. The parameter \code{delay} is used for this. Delay is a matrix with 2 columns. The first column gives the cumulative relative area. The second column gives the average distance towards the outlet (m).

}
\value{
Either:
\itemize{
  \item{An object of class \code{\link{HM}}, if called with an object of this class}
  \item{An object of type HydroModelRun. Depending on the options, the following slots are filled:

- If no observed discharge is given, and verbose = F, simulated discharge is stored as a simulated flux

- If verbose = T, simulated discharge (Q), overland flow (qo), subsurface flow (qs), infiltration excess overland flow (fex), and actual evapotranspiration (Ea) are stored as a simulated flux, and internal storage (S) is stored as a simulated state.

- If observed discharge is given, the Nash-Sutcliffe efficiency is stored as a performance measure, and no simulated discharge is returned. This is useful for long model runs to minimise memory usage. Beware that invoking \code{topmodel()} without Q for a large number of run may require a large amount of memory, since the entire time series of simulated discharges is stored for each parameter set.
}
}
}

\references{Beven, K. J., Kirkby, M. J., 1979. A physically based variable contributing area model of basin hydrology. Hydrol. Sci. Bull. 24, 43-69.

Beven K, Lamb R, Quinn P, Romanowicz R, Freer J, 1995. TOPMODEL. In: Sing VP (Ed), Computer Models of Watershed Hydrology. Water Resources Publications, Colorado. pp. 627-668.

Morel-Seytoux, H.J., Khanji, J., 1974. Derivation of an Equation of Infiltration. Water Resources Research, 10, 795-800.

Beven, K., 1984. Infiltration into a Class of Vertically Non-Uniform Soils. Hydrological Sciences Journal 29, 425-434.

See also \url{http://source.ggy.bris.ac.uk/wiki/Hydrology_in_R} for a more elaborate example on how to run topmodel in R.
}
\author{Wouter Buytaert, Imperial College London}

% \seealso{\code{\link{print}}}
\examples{
data(huagrahuma)
attach(huagrahuma)

output <- topmodel(parameters[1:9], inputs, topidx, delay)

#Use HM structure:
HMObject = RHydro("topmodel", newval = list(Obs = list(Temporal = list(data = inputs)),
    Parameters = list(param = parameters[1:9], top = topidx, del = delay)))
res = topmodel(HMObject)
res2 = predict(HMObject)
str(res)
all.equal(res, res2)


}
\keyword{models}
