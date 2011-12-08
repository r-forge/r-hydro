\name{plot_rainfall.runoff}
\alias{plot_rainfall.runoff}
\title{ Make rainfall runoff plot }
\description{
   method to create a nice rainfall runoff plot with rainfall from top and runoff as measured and modelled time series.
}
\usage{
plot_rainfall.runoff(rain, q.model, q.measured = NULL, myColors =
                 data.frame(measured = c("grey"), modelled =
                 c("black"), rain = c("black")), q.units = "mm/h",
                 p.units = "mm/h", 
		 mar = c(3, 4, 2, 4) + 0.1, cex.rain = 1, ...)
}
\arguments{
  \item{rain}{ \code{\link[zoo]{zoo}}-object with rainfall data }
  \item{q.model}{ \code{\link[zoo]{zoo}}-object with modelled discharge data }
  \item{q.measured}{ \code{\link[zoo]{zoo}}-object with measured discharge data }
  \item{myColors}{ data.frame defining colors for plotting }
  \item{q.units}{ character: units of the discharge: used for axis label }
  \item{p.units}{ character: units of the rainfall: used for axis label }
  \item{cex.rain}{ numeric: Size of the axis lable for rainfall }
  \item{mar}{ see \code{\link{par}}  }
  \item{\dots}{ other arguments passed to \code{\link[zoo]{plot.zoo}} }
}
\value{
 used for side effect: plotting
}
\references{ thePaper }
\author{ Dominik Reusser }
\examples{
data(huagrahuma)
attach(huagrahuma)

plot_rainfall.runoff(rain = zoo(inputs$P), q.model=zoo(inputs$Q), q.units = "mm/ 15min", p.units = "mm/15min")
}
\keyword{ utilities }
\keyword{ hplot }
