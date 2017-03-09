\name{baseflow_sep}
\alias{baseflow_sep}

\title{
Baseflow separation
}
\description{
Various baseflow separation methods
}
\usage{
baseflow_sep(runoff, method="DFM", parms=c(c=0.925, c_slope=diff(range(runoff))/length(runoff)/2, window_size=10, f_lowess=0.1))
}


%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{runoff}{
vector of runoff heights (equidistant temporal resolution) [L/T]
}
  \item{method}{
base-flow separation method, see details.
}

\item{parms}{
method-specific paramters, see details. The effect of the parameter will be dependent on the temporal resolution of the runoff series.
}

}

\details{
\code{method="DFM"} (default) selects baseflow separation using a single-pass digital filter method (e.g. Sawicz et al, 2011). It uses the parameter \code{c}, varying between 0 (baseflow close to runoff) to 1 (constant baseflow). \\
q_direct[i] = max(0, cc*qd[i-1]+(1+cc)/2*(runoff[i]-runoff[i-1]), na.rm=TRUE)

\code{method="constant_slope"} separates base flow by drawing a line with constant slope from the minima of the hydrograph to the next intersection with it. Dingman (2002) recommends for the parameter \code{c_slope} a value depending on catchment area A (A < 20 mi²): c_slope = 0.05 ft³/s * A /h. You do the math, imperial units suck.

\code{method="RLSWM"} re-scaled LOWESS-smoothed window minima. Determines the minima in a moving window of \code{window_size} timesteps and smoothes them using \code{\link{lowess}} with parameter \code{f_lowess}. If at any timestep baseflow is larger than the runoff, the entire baseflow-series is shrunk linearly.
}


\value{
 {
vector holding base flow time series
}


}



\references{
Sawicz, K., Wagener, T., Sivapalan, M., Troch, P. A., & Carrillo, G. (2011). Catchment classification: empirical analysis of hydrologic similarity based on catchment function in the eastern USA. \emph{Hydrology and Earth System Sciences}, 15(9), 2895–2911. http://dx.doi.org/10.5194/hess-15-2895-2011  
  
Dingman, S. L. (2002). Physical hydrology. Upper Saddle River, NJ: Prentice Hall.  
}

\author{
Till Francke
}


\seealso{
 \code{\link{bfi}}
}

\examples{
runoff = fuse.DATA[,"Q"]

bf = baseflow_sep(runoff, method="RLSWM", parms=c(window_size=50, f_lowess=0.2))
plot(runoff, type="l")
lines(bf, col="red")
}