\name{long.wave.radiation.balance}
\alias{long.wave.radiation.balance}
\title{
estimate long wave radiation balance for snow
}
\description{
estimate long wave radiation balance for snow
}
\usage{
long.wave.radiation.balance(t.air, t.atm = t.air, t.snow = NULL, sigma = 4.9 * 10^-9, vap.pres, cloud.cover = 0, sky.view = 0, emiss.snow = 1)
}
\arguments{
  \item{t.air}{
   zoo-object of air temperatures.
}
  \item{t.atm}{
   zoo-object of atmosphere temperatures.
}
  \item{t.snow}{
   zoo-object of snow temperatures.
}
  \item{sigma}{
   Boltzman constant in MJ * 1/m²*1/day*1/K^4
}
  \item{vap.pres}{
   zoo object of vapour pressure in kPa
}
  \item{cloud.cover}{
  fraction of cloud cover (no unit)
}
  \item{sky.view}{
  fraction of sky covered by forest (no unit)
}
  \item{emiss.snow}{
  emissivity of snow (no unit)
}
}
\details{
All temperatures in degree C. If t.snow is set to zero, it is estimated as min(t.air - 2.5 , 0)
}
\value{
 \item{L}{ zoo.object of long wave radiation in MJ * 1/m^2 * 1/day}
 \item{L.in}{incoming radiation}
 \item{L.out}{from snow cover emitted radiation}
 \item{e.at}{estimated emissivity of the atmosphere}
}
\references{
Dingman, S. L. (2002): Physical hydrology,Waveland Press, Long Grove, Ill.
}
\author{
Dominik Reusser
}


\examples{
#Example 5-7 from Dingman
long.wave.radiation.balance(t.air=4, vap.pres=0.651, sky.view=0.8, cloud.cover=0.5)
#Dingman reports 0.27 MJ * 1/m^2 * 1/day

}
\keyword{ util }
