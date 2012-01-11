\name{reload}
\alias{reload}
\alias{run.query}
\alias{run.sql.script}
\alias{sqlstatements}
\alias{sv}
\alias{svk}
\alias{todo}
\title{
Internal functions: helping to do things
}
\description{
The following methods are used internaly:

reload is used to recompile and reload the package during development.

todo is used to indicate unfinished implementations. options(verbose.todos = TRUE) can be used to determine if the corresponding text is printed.

run.query is used to run queries. In addition, the  query string is printed if options(verbose.queries=TRUE) is set.

run.sql.script reads an SQL script from a text file and executes all the commands.

sqlnow returnes a database engine specific term to obtain the current time and date.

sv and svk are uesd to return the correct element from a vector to be entered in a database query. The commands take care to give useful result also for vectors that are NULL and NA-entries in a vector. svk must be used if the database column has to meet a foreign key relation ship. In this case, the appropriate key is returned.
}
\usage{
reload()
run.query(object, query)
run.sql.script(con, script.file)
sqlstatements(object, term)
sv(the.vect, rownum)
svk(the.vect, tablename, rownum, object)
todo(text)
}
\arguments{
  \item{con}{
  Connection returned by \code{\link{dbConnect}}
%\code{\link[<pkg>:<pkg>-package]{<pkg>}}
}
  \item{query}{
  Query string to be executed
}
  \item{script.file}{
  Location (path) of the SQL script to be run.
}
  \item{object}{
  ODM handler object returned by new("ODM1_1") or new("ODM1_1Ver").
}
  \item{term}{
  Internal function. SQL statement to be translated in the appropriate SQL-dialect. 
}

  \item{tablename}{
  Name of the table defining the foreign key.
}
  \item{the.vect}{
  Vector from which to return the correct element.
}
  \item{rownum}{
  Element to be returned from vector.
}
  \item{text}{
  String describing what is missing in the implementation.
}
}
\details{
 See code for details.
}
\value{
 See code for return values.
}
\author{
Dominik Reusser
}

\examples{
# see code for examples
}
\keyword{ utilities }
\keyword{ internal }
