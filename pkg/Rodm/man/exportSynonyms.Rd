\name{Synonym transfer functions}
\alias{exportSynonyms}
\alias{importSynonyms}
\title{
Transfer synonyms  
}
\description{
Functions that allow to transfer synonyms from one database to another. This may be useful because the synonyms include quite a bit of manual matching on large datasets. Transferring those allows to reconstruct a database from source file more easily.
}
\usage{
exportSynonyms(file)
importSynonyms(file)
}
\arguments{
  \item{file}{
   File name for export and import
}
}
\value{
Used for the side effect of creating/importing a file. The file includes the columns phrase, table and key.
}
\author{
Dominik Reusser
}

\seealso{
 \code{\link{getID}}, \code{\link{addSynonym}}
}
\examples{
exportSynonyms("synonym_table.tab")
importSynonyms("synonym_table.tab")
}
\keyword{ utilities }
