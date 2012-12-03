\name{hydro_metrics}
\alias{runoff_coeff}
\alias{time_of_conc}
\alias{c_smooth}
\alias{fdc_slope}
\alias{sel}
\alias{bfi}
\alias{q10}
\alias{hpc}
\alias{rising_limb_density}
\alias{fft_fit}
\alias{filter_ratio}

\title{
Various streamflow (and rainfall)-based metrics.
}
\description{
Various streamflow (and rainfall)-based metrics to describe a hydrologic catchment.
}
\usage{
runoff_coeff   (rainfall, runoff)
time_of_conc   (rainfall, runoff)
c_smooth	       (rainfall, runoff)
fdc_slope	   (runoff, lQ.thr=0.66, hQ.thr=0.33)
sel			   (rainfall, runoff, agg_dt=1)
bfi			   (runoff, ...)
hpc			   (runoff)
q10			   (runoff)
rising_limb_density(runoff)
fft_fit		   (runoff, rainfall, doplot=FALSE)
filter_ratio   (runoff, rainfall, doplot=FALSE)

}


%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{rainfall}{
vector of rainfall heights (equidistant temporal resolution) [L/T]
}
  \item{runoff}{
vector of runoff heights (equidistant temporal resolution) [L/T]
}
  \item{doplot}{
enable plotting
}

\item{agg_dt}{
number of timesteps that will be aggregated before performing calculations
}

\item{...}{
further arguments (see details)
}
}
\details{
\itemize{
\item \code{runoff_coeff} returns the runoff coefficient, i.e. sum(runoff)/sum(rainfall)
\item \code{time_of_conc} returns the time of concentration, i.e. the average temporal lag (in timesteps) between rainfall and runoff response. This values is computed for the entire series without considering events and is only sufficiently robust for time series that are long in comparison to residence time.
\item \code{c_smooth} returns a value [0..1] for the smoothing effect of the catchment, i.e. cv(runoff)/cv(rainfall), where cv is the coefficient of variation. Values close to 1 indicate a flashy, those close to 0 an inert catchment.
\item \code{fdc_slope} slope (in log(Q)-quantile-plot) of flow duration curve for given quantiles. "high slope value indicates a variable flow regime, while a low slope value means a more damped response" (Sawicz et al, 2011)
\item \code{sel} Stream flow elasticity. "A value greater or less than 1 would, respectively, define the catchment as being elastic, i.e., sensitive to change of precipitation, or inelastic, i.e., insensitive to a change of precipitation." (Sawicz et al, 2011). Here, the formulation used in Chiew (2006) or Fu et al. (2007) is used, which seem more logical as the one in Sawicz et al (2011) and Sankarasubramanian et al. (2001).
\item \code{bfi} base flow index, fraction of baseflow contribution using the specified method and the same arguments as code{\link{baseflow_sep}}
\item \code{hpc} high-pulse count. "Number of annual occurrences during which flow remains above 3 times median daily flow divided by [entire] period of flow" (Yadav et al. 2007, "FRE3" in Clausen & Biggs, 2000). Unit: Events/timestep 
\item \code{q10} Flow exceeded 10 percent of the time divided by Q50 (Clausen & Biggs, 2000)
\item \code{rising_limb_density} rising limb density:  "ratio of the number of rising limbs and the total amount of time the hydro-graph is rising [...] A small the (sic!) signature value indicates a smooth hydrograph." (Sawicz et al, 2011)
\item \code{fft_fit} returns the coefficients of a two-segment linear fit in the log-log plots of the power spectra of rainfall and runoff (as e.g. in Özger et al., 2012).
\item \code{filter_ratio} returns the ratio of the frequency recession coefficents of rainfall and runoff (i.e. second row in the result of \code{fft_fit}), 

\item \code{runoff_coeff, time_of_conc, c_smooth, fft_fit, filter_ratio} trim the included time series before performing the calculations.

}
}
\value{
\item{fft_fit}{
Matrix with the first column for rainfall, the second for runoff; the first two rows containing the slope values of the fit, the third the location of the breakpoint.
}

 \item{all others:}{
numeric value as described in details.
}


}



\references{
Chiew, F.H.S. (2006). Estimation of rainfall elasticity of streamflow in Australia. \emph{Hydrological Sciences Journal}, 51:4, 613-625, http://dx.doi.org/10.1623/hysj.51.4.613

Clausen, B., Biggs, B. J. . (2000). Flow variables for ecological studies in temperate streams: groupings based on covariance. \emph{Journal of Hydrology}, 237(3-4), 184–197. http://dx.doi.org/10.1016/S0022-1694(00)00306-1

Fu, G., S. P. Charles, and F. H. S. Chiew (2007). A two-parameter climate elasticity of streamflow index to assess climate change effects on annual streamflow. \emph{Water Resour. Res.}, 43, W11419, http://dx.doi.org/10.1029/2007WR005890

Özger, Mehmet, Mishra, Ashok K., Singh, Vijay P. (2012). Seasonal and spatial variations in the scaling and correlation structure of streamflow data
\emph{Hydrological Processes}, 1099-1085, http://dx.doi.org/10.1002/hyp.9314
  
Sawicz, K., Wagener, T., Sivapalan, M., Troch, P. a., Carrillo, G. (2011). Catchment classification: empirical analysis of hydrologic similarity based on catchment function in the eastern USA. \emph{Hydrology and Earth System Sciences}, 15(9), 2895–2911. http://dx.doi.org/10.5194/hess-15-2895-2011  
  
}

\author{
Till Francke
}



\seealso{
 code{\link{baseflow_sep}}
}

\examples{
}
