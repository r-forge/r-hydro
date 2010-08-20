\name{sat.vap.pres}
\alias{sat.vap.pres}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Calcualte the saturated vapour pressure from  the temperature.
}
\description{
Calcualte the saturated vapour pressure from  the temperature according to a relationship reported in Dingman (2002).
}
\usage{
sat.vap.pres(temp)
}
\arguments{
  \item{temp}{
   vector of temperatures in degree celcius
}
}
\details{
the  staturated vapour pressure (in kPa) is defined as:
0.611*exp(17.3*temp/(temp+237.3))
}
\value{
staturated vapour pressure in kPa
}
\references{
Dingman, S. L. (2002): Physical hydrology,Waveland Press, Long Grove, Ill.
}
\author{
Dominik Reusser
}


\examples{
   temp <- 20
   sat.vap.pres(temp)
}
\keyword{ util }
