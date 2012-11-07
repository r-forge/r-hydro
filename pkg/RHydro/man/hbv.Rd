\name{hbv}
\alias{hbv}
\alias{hbv.prerun}
\Rdversion{1.1}
\encoding{utf8}

\title{
hbv - simulation using hydrological model HBV
}
\description{
\code{hbv} simulates discharge from a given rainfall time series using a simple 0-D version of the hydrological model HBV (Bergström,) as implemented in Heistermann & Kneis (2011) with simple routing using custom, triangular hydrograph or linear storage cascade. \code{hbv_prerun} applies \code{hbv} while repeating a pre-run phase ("warm up") as long as any of the storages change by more than \code{storage_tolerance}
}
\usage{
hbv(pars, init=NULL, prec, temp=NULL, delta_t=1, unithg=NULL)
hbv.prerun(init=NULL, prec, max_pre_runs=20, storage_tolerance=0.1, prerun_length=(365*24*60/5), verbose=TRUE,...)

}
%- maybe also 'usage' for other objects documented here.
\arguments{


  \item{pars}{
named vector holding the HBV parameters
\code{cfmax=2.4}  degree day factor for snow melt  [mm/°C/d]
\code{tt=0}    temperature threshold below which precipitation falls as snow [°C]
\code{fc=200}     field capacity [mm] 
\code{minsm}   minimum soil moisture for storage sm [mm]
\code{beta}    parameter to control the fraction of rain and snow melt partitioned for groundwater recharge [-]
\code{lp}     fraction of soil moisture-field capacity-ratio above which actual evapotranspiration equals potential evapotranspiration [-]
\code{corr=1}   correction factor for potential evapotranspiration [-]
\code{k_perc} percolation coefficient [1/d]
\code{k0}     fast storage coefficient of soil upper zone [1/d]
\code{luz}    threshold above which soil upper zone storage empties at rate computed by storage coefficient K0 [mm]
\code{k1}     slow storage coefficient of soil upper zone [1/d]
\code{k2}     storage coefficient of soil lower zone [1/d]
\code{maxbas} Length of (triangular) unit hydrograph [timesteps]. See details.
\code{etpmean=5} mean evaporation [mm/d]
\code{tmean=10} mean temperatures [°C]

\code{n} (real) number of storages in linear storage cascade. Overrides pars["maxbas"], overridden by \code{unithg}.
\code{k} decay constant for linear storage cascade. Overrides pars["maxbas"], overridden by \code{unithg}.
}
  \item{init}{
named vector holding the HBV state variables for initialisation
\code{'snow'=0} snow storage [mm]
\code{'sm'=200} soil moisture storage [mm]
\code{'suz'=0}  soil upper zone storage [mm]
\code{'slz'=0}  soil lower zone storage [mm]
}
 
\item{prec}{
	vector holding rainfall in equidistant timesteps of \code{delta_t} in mm
}

\item{temp = pars["tmean"]}{
	vector holding temperature in equidistant timesteps of \code{delta_t} in °C
}

\item{delta_t=1}{
length of timesteps in \code{prec} in days
}

\item{unithg=NULL}{ vector of dimensionless unit hydrograph (should sum up to 1). Overrides \code{pars[c("maxbas","n","k")]}.}

\item{max_pre_runs=20}{maximum number of pre-run iterations}

\item{storage_tolerance=0.1}{While any of the storages has changed by more than this values, the pre-run phase is repeated}

\item{prerun_length=365*24*60/5} number of timesteps from \code{prec} to use for pre-run phase (typically a year)

\item{verbose=TRUE}{additional text output during pre-run iterations}

\item{...}{additional parameters passed to \code{hbv}}

}


\details{
If \code{unithg} is specified, \code{pars[c("maxbas","n","k")]} are ignored. If \code{pars[c("n","k")]} are specified, routing using linear storagte cascade is performed. If only \code{pars["maxbas"]} is set, a triangular unit hydrograph with its peak in at \code{pars["maxbas"]} /2 timesteps is used.
}

\value{
The function returns a list \code{list(q, snow, sm, suz, slz)} with
%%  ~Describe the value returned
%%  If it is a LIST, use
  \item{q}{(vector) modelled discharge [mm]}
  \item{snow}{(scalar) snow storage at end of run [mm]}
  \item{sm}{(scalar)soil moisture storage at end of run [mm]}
  \item{suz}{(scalar)soil upper zone storage at end of run [mm]}
  \item{slz}{(scalar)soil lower zone storage at end of run [mm]}
    
}
\references{
  Bergström, S. (1976) 
  Development and application of a conceptual runoff model for Scandinavian catchments. \emph{SMHI Reports RHO}, No. 7, Norrkög.
  
  Heistermann, M. & Kneis, D. (2011)
  Benchmarking quantitative precipitation estimation by conceptual rainfall-runoff modeling, \emph{Water Resour. Res.,}
  47, W06514, doi:10.1029/2010WR009153.  
}
\author{
Maik Heistermann, David Kneis, Till Francke
}
\note{
- still in development, use with care, all comments welcome -
}


\seealso{
 \code{\link{none}}
}

\examples{
data(huagrahuma)
prec.day <- aggregate(huagrahuma$inputs$P, 
      by=strftime(index(huagrahuma$inputs$P), "\%d.\%m.\%Y"))

#use standard parameters and initialization
hbv(pars=0, init=0, prec = prec.day , delta_t=1)
 
}

\keyword{ ~modelling }
\keyword{ utilities }
