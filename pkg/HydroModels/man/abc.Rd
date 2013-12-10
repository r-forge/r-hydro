\name{abc}
\alias{abc}
\title{
The simple abc hydrological Model
}
\description{
Some description todo
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
abc(pars, init, prec, R.implementation = FALSE)
}
\arguments{
  \item{pars}{
  A vector with the three named (!) parameters a,b,c
}
  \item{init}{
  A vector with the named (!) initial condition for the storage G 
}
  \item{prec}{
  The precipitation data as vector. ToDo: change to xts
}
  \item{R.implementation}{
  boolean, determining if R or Fortran code is run.
}
}
\details{
Give some more details about the model here. Todo
	   These are our model equations (Q: stream flow, G: base flow)
	   \code{Q[t] = (1-a-b) * P[t] + c * G[t-1]}
	   \code{G[t] = (1-c) * G[t-1] + a * P[t]}
	   Rekursionsvorschrift fur \code{Gt: Gt = G0*(1-c)^t + Summe_von_i=1_bis_t_uber(a*Pi*(1-c)^(n-t))}
	   die Zeitreihe fuer G wird um einen Zeitindex nach "rechts" verschoben (also \code{G[1]=G0})
	   auf diese Weise kann dann Q ohne Schleife berechnet werden  
}
\value{
\item{q }{The vector of simulated discharges}
\item{G }{The vector of changes in the store G}
}
\references{
Vogel and Sankarasubramanian, WRR, 2003
}
\author{
Maik Heistermann (?), Dominik Reusser
}

\examples{
data(huagrahuma)
abc(pars=c(a=0.5,b=0.3,c=0.7), init=c(G=1), prec = huagrahuma$inputs$P, R.implement=TRUE)
#Todo: make more sensible example
abc(pars=c(a=0.5,b=0.3,c=0.7), init=c(G=1), prec = huagrahuma$inputs$P)
}
\keyword{ ~modelling }
\keyword{ utilities }
