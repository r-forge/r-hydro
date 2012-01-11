\name{check.version}
\alias{check.version}
\alias{h.m}
\title{
Internal function: check if database connection is present and database has correct version.
}
\description{
h.m is called from any interface function (defined e.g. in \code{\link{odm1_1-class}}) when no handler object has been defined with options(odm.handler=sqhandler)

check.version checks for correct version of the database and gives an error if this is not the case.
Includes a check if the data base schema has been created.  If not 
the corresponding scripts are processed from the src directory.
}
\usage{
h.m(object)
check.version(object, version)
}
\arguments{
  \item{object}{
   The odm-handler object. For example created by new("odm1_1Ver", con = con) where con is the database connection.
}
  \item{version}{
  The version required.
}
}
\details{
What do you need?
}
\value{
nothing returned. Side effects assure that the package can be used without explicitly setting up a database.
}
\author{
Dominik Reusser
}

\examples{
# see code
}
\keyword{ utilities }
\keyword{ internal }
