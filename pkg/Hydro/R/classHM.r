

# Definition of the class HMData
# Network has a separate slot, although not sure if this makes sense, it is mostly a 
# spatial feature. A reason for separation is that points, grids and pixels
# have more similarities, and can also be exchanged with rasters, wheras
# Lines (and polygons) are of a different type.
# Should also Polygons then have a different slot?
# The Dots are for non-spatial data, such as matrices, data.frames etc,
# which are not a part of parameters either.

HMData = setClass("HMData", slots = c(
	Spatial = "list",
	Temporal = "list",
	SpatioTemporal = "list",
  Network = "list",
  Dots = "list"),
  prototype = prototype(Spatial = list(),
                          Temporal = list(),
                          SpatioTemporal = list(),
                          Network = list(),
                          Dots = list()),
  validity = function(object) {
     listIsNamed = function(x) {
	 	  n = names(x)
	 		length(x) == 0 || (!is.null(n) && all(nchar(n) > 0) )
	 	}
	 	stopifnot(listIsNamed(object@Spatial))
	 	stopifnot(listIsNamed(object@Temporal))
	 	stopifnot(listIsNamed(object@SpatioTemporal))
  	stopifnot(listIsNamed(object@Network))
  	stopifnot(listIsNamed(object@Dots))
  	# check classes:
  	stopifnot(all(sapply(object@Spatial, FUN = function(x) is(x, "Spatial") | is(x, "Raster"))))
  	stopifnot(all(sapply(object@Temporal, FUN = function(x) is(x, "xts") | is(x, "zoo"))))
  	stopifnot(all(sapply(object@SpatioTemporal, FUN = function(x) is(x, "ST") | is(x, "RasterStack"))))
  	stopifnot(all(sapply(object@Network, FUN = function(x) is(x, "SpatialLines") | is(x, "igraph"))))
 	  return(TRUE)
  }
)                                               

updateHMData = function(HMD, newdata) {
  for (slotName in names(newdata)) {
    slot(HMD, slotName) = modifyList(slot(HMD, slotName), newdata[[slotName]])
  }
  HMD
}

#setMethod("HMData", signature = "list", 
#  function(object) {
# do.call("HMData", object)
#  }
#)





# This union class makes it possible to add nullobjects for the Pred-slot.
# The alternative would be to have a separate class after predictions have been added,
# but is there any reason that is necessary?


setClassUnion("HMDataOrNull", c("HMData", "NULL"))

HM = setClass("HM", 
	slots = c(Obs = "HMData", #CalibData = "HMDataOrNull", 
            Pred = "HMDataOrNull", Parameters = "list", performance = "list", control = "list"),
  prototype = prototype(Obs = HMData(), #CalibData = NULL, 
                        Pred = NULL, Parameters = list(), 
                        performance = list(), control = list()))


HMobservations = function(object) object@Obs
HMpredictions = function(object) object@Pred
HMparameters = function(object) object@Parameters
HMdots = function(object) object@Dots
HMcontrol = function(object) object@control
HMtemporalData = function(object) object@Temporal
HMspatialData = function(object) object@Spatial
HMspatiotemporalData = function(object) object@SpatioTemporal




