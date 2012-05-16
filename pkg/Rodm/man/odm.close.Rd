\name{odm.close}
\alias{odm.close}
\alias{getDefaultDB}
\title{
Open standard SQLite database delivered with the package and 
close existing connection to observations database.
}
\description{
Close the existing connection to observations database.
}
\usage{
odm.close()
getDefaultDB(file="RODM.db")
}
\arguments{
  \item{file}{
    Name of the file delivered with the package. Normaly should not be changed.
}
}

\value{
Nothing returned.
}
\author{
Dominik Reusser
}
\examples{
getDefaultDB()

odm.close()
}
\keyword{ utilities }
