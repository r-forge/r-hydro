


HMData = setClass("HMData", slots = c(
	Spatial = "list",
	Temporal = "list",
	SpatioTemporal = "list",
  Lines = "list",
  Dots = "list"),
  prototype = prototype(Spatial = list(),
                          Temporal = list(),
                          SpatioTemporal = list(),
                          Lines = list(),
                          Dots = list()),
  validity = function(object) {
     listIsNamed = function(x) {
	 	  n = names(x)
	 		length(x) == 0 || (!is.null(n) && all(nchar(n) > 0) )
	 	}
	 	stopifnot(listIsNamed(object@Spatial))
	 	stopifnot(listIsNamed(object@Temporal))
	 	stopifnot(listIsNamed(object@SpatioTemporal))
  	stopifnot(listIsNamed(object@Lines))
  	stopifnot(listIsNamed(object@Dots))
  	# check classes:
  	stopifnot(all(sapply(object@Spatial, FUN = function(x) is(x, "Spatial") | is(x, "Raster"))))
  	stopifnot(all(sapply(object@Temporal, FUN = function(x) is(x, "xts") | is(x, "zoo"))))
  	stopifnot(all(sapply(object@SpatioTemporal, FUN = function(x) is(x, "ST") | is(x, "RasterStack"))))
  	stopifnot(all(sapply(object@Lines, FUN = function(x) is(x, "SpatialLines") | is(x, "igraph"))))
 	  return(TRUE)
  }
)                                               


# This union class makes it possible to add nullobjects for the Pred-slot.
# The alternative would be to have a separate class after predictions have been added,
# but is there any reason that is necessary?


setClassUnion("HMDataOrNull", c("HMData", "NULL"))

HM = setClass("HM", 
	slots = c(Obs = "HMData", CalibData = "HMDataOrNull", 
            Pred = "HMDataOrNull", Parameters = "list", control = "list"),
  prototype = prototype(Obs = HMData(), CalibData = NULL, 
                        Pred = NULL, Parameters = list(), control = list()))


observations = function(object) object@Obs
predictions = function(object) object$Pred
parameters = function(object) object@Parameters
dots = function(object) object@Dots
control = function(object) object$control
temporalData = function(object) object@Temporal
spatialData = function(object) object@Spatial
spatiotemporalData = function(object) object@SpatioTemporal




