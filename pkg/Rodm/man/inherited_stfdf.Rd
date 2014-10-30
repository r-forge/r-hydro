\name{inherited_stfdf-class}
\alias{inherited_stfdf-class}
\alias{inherited_stfdf}
\alias{restructureDataResult}
\alias{[,inherited_stfdf-method} 
\alias{==,inherited_stfdf,inherited_stfdf-method} 
\title{
Internal: Class inherited stfdf
}
\description{
This class is an inherited STFDF from the packages spacetime. STFDF is for spatio-temporal data with a full data frame.
It shows n spatial points and m times. Foreach location and time exists observations.
It deals with spatio-temporal data and provides special time series analysis.
The object of class inherited_stfdf contains one stfdf with the main-data: spatial data of package sp and temporal informations of class xts. The actual data is stored in the form of a data.frame.
Furthermore it contains two stfdf-objects with the 'ValueIDs' and the 'DerivedFromIDs' and also one data.frame with the Meta-informations.

}

\usage{
  inherited_stfdf(sp, time, data, endtime,
					ValueIDs, DerivedFromIDs, MetadataRel, Metadata)
  \S4method{[}{inherited_stfdf}(x, i, j, ..., drop = TRUE)
}


\arguments{
\item{sp}{object of class \link{Spatial}, with \code{n} elements}
\item{time}{object holding time information, of length \code{m}}
\item{endtime}{ vector of class \code{POSIXct}, end points
of time intervals; if not specified the time intervals are choose by default, when intervals are regular \link{delta} }
\item{data}{data frame with \code{n*m} observations}
\item{ValueIDs}{an object of class STFDF; see \link{STFDF}, which contains the ID's of the measured values}
\item{DerivedFromIDs}{an object of class STFDF; see \link{STFDF}, which contains the ID's of the measured values}
\item{MetadataRel}{an object of class STFDF; see \link{STFDF}, which contains the metadata-ids for build a relationship with the dataValues}
\item{Metadata}{an object of class data.frame; see \link{STFDF}, which contains metadata of measurements, e.g. variablename, methods, etc.}
\item{x}{an object of class inherited_stfdf}
\item{i}{variety of spatial entities}
\item{j}{range of temporal entities }
\item{...}{selection of attribute(s)}
\item{drop}{has no effect}
}


\section{Objects from the Class}{
Objects of this class represent full space/time data with a full grid 
(or lattice) layout }

\section{Slots}{
  \describe{
    \item{\code{sp}:}{spatial object; see \link{ST-class}}
    \item{\code{time}:}{an object of class xts; see \link{xts}}
	\item{\code{data}:}{\code{data.frame}, which holds the measured values
	the measured values; space index cycling first, time order preserved}
	\item{\code{endtime}:}{it is a vector of class POSIXct. It contains end points of time intervals}
	\item{\code{ValueIDs}:}{an object of class STFDF; see \link{STFDF}, which contains the ID's of the measured values}
	\item{\code{DerivedFromIDs}:}{an object of class STFDF; see \link{STFDF}, which contains the ID's of the measured values}
	\item{\code{MetadataRel}:}{an object of class STFDF; see \link{STFDF}, which contains the metadata-ids for build a relationship with the dataValues}
	\item{\code{Metadata}:}{an object of class data.frame; see \link{STFDF}, which contains metadata of measurements, e.g. variablename, methods, etc.}
	
 }
}

\section{Methods}{
  \describe{
    \item{[}{\code{signature(x = "inherited_stfdf")}: selects location, times and variables}
   \item{==}{\code{signature(e1="inherited_stfdf",e2="inherited_stfdf")}: compares two inherited stfdf's}
	}
}

\examples{
# look at documentation of addDataValues. Import more than one location to execute the example.
# when you use getDataValues the method return an inherited_stfdf
example(addDataValues)
inDB = getDataValues()

# Select data
#You can selected the data by using numerics and characters.
#In the following code line 'inDB' is sub-setted to the second and third location, the first twenty dates and the temperature.
#Advice: The variable must have the correct term. For support look at the column name of inDB@data.

selectedData = inDB[1, 1:10, "Distance"]

#Furthermore you can miss out some parameters:
selectedData2 = inDB[1,10:10]
selectedData3 = inDB[,10:10]

#Attention: if the dataset contains only one location (or it is subset only one point) it's impossible to get a inherited spacetime-object. So you get a object of xts.
#If only one time is selected you get a SpatialPointsDataFrame.

#The inherited stfdf-data can visualized in different plots. For example:

stplot(inDB, mode='tp', type = 's')
stplot(inDB, mode='xt')


# Further you can access the slots of object by take advantage of the '@'.
inDB@Metadata
inDB@sp
inDB@time
inDB@data
}

\author{
Dominik Reusser
}
\keyword{ utilities }
\keyword{ stfdf }
