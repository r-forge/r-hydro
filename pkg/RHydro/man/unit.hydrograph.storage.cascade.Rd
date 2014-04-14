\name{unit.hydrograph.storage.cascade}
\alias{unit.hydrograph.storage.cascade}
\alias{apply_uhg}

\title{
Unit hydrograph linear storage cascade
}
\description{
Compute the shape of a Unit hydrograph linear storage cascade with the given parameters and apply it to given rainfall series.
}
\usage{
unit.hydrograph.storage.cascade(n, k, delta_t)
apply_uhg(rainfall, uhg_params, delta_t)
}


%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{n}{
number of linear storages [-]
}

  \item{k}{
recession constant (same unit as \code{delta_t})

}

\item{delta_t}{
time resolution of return vector [time].
}

\item{rainfall}{
vector of rainfall series in time resolution of \code{delta_t}.
}

\item{uhg_params}{
vector with named components "n" and "k" (parameters of UHG) OR matrix with named columns "n", "k" and "a". In the latter case, a multiple UHG is applied with the weights in \code{"a"}.
}

}

\details{
The resulting vector \code{h} would, in principle, be of infinite length because of the asymptotic behaviour of the storage outflow. For practical reasons, it is trimmed so that at least 99\% of the volume is reproduced.
}


\value{
 {
vector \code{h} with ordinates of unit hydrograph or modelled hydrograph, corresponding to temporal resolution of \code{delta_t} starting with t=0
}

}



\author{
Till Francke
}



\examples{

#simple unit hydrograph ordinates
delta_t = 0.5
uh = unit.hydrograph.storage.cascade(n=2, k=3, delta_t = delta_t)
plot(seq(from=delta_t, by=delta_t, along.with=uh) , uh, type="l")

#compute hydrograph from multiple UHGs:
rainfall <- fuse.DATA[,"P"]
uhg_params=rbind( c(n=2,  k=3, a=0.4),
                  c(n=20, k=3, a=0.6))	#two-element unit hydrograph, weighted 40 and 60 %, resp.
plot(apply_uhg(rainfall, uhg_params, delta_t), type="l")


}