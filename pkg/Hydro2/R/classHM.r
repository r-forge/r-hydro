

# Definition of the class HMData
# Network has a different slot, although not sure if this makes sense, it is mostly a 
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
  Network = "list"),
  prototype = prototype(Spatial = list(),
                          Temporal = list(),
                          SpatioTemporal = list(),
                          Network = list()),
  validity = function(object) {
     listIsNamed = function(x) {
	 	  n = names(x)
	 		length(x) == 0 || (!is.null(n) && all(nchar(n) > 0) )
	 	}
	 	stopifnot(listIsNamed(object@Spatial))
	 	stopifnot(listIsNamed(object@Temporal))
	 	stopifnot(listIsNamed(object@SpatioTemporal))
  	stopifnot(listIsNamed(object@Network))
  #	stopifnot(listIsNamed(object@Dots))
  	# check classes:
  	stopifnot(all(sapply(object@Spatial, FUN = function(x) is(x, "Spatial") | is(x, "Raster"))))
  	stopifnot(all(sapply(object@Temporal, FUN = function(x) is(x, "xts") | is(x, "zoo"))))
  	stopifnot(all(sapply(object@SpatioTemporal, FUN = function(x) is(x, "ST") | is(x, "RasterStack"))))
  	stopifnot(all(sapply(object@Network, FUN = function(x) is(x, "SpatialLines") | is(x, "igraph"))))
 	  return(TRUE)
  }
)                                               

updateHMData = function(HMD, newdata) {
  if (is(HMD, "HMData")) {
    for (slotName in names(newdata)) {
      slot(HMD, slotName) = modifyList(slot(HMD, slotName), newdata[[slotName]])
    }
  } else if (is.list(HMD) & is.list(newdata)) {
    for (ip in 1:length(newdata)) {
      if (names(newdata)[ip] %in% names(HMD)) {
        jp = which(names(HMD) == names(newdata)[ip])
        HMD[[jp]] = updateHMData(HMD[[jp]], newdata[[names(newdata)[ip]]])
      } else {
        HMD[[length(HMD)+1]] = newdata[[ip]] 
        names(HMD)[length(HMD)] = names(newdata)[ip]
      }
    }
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
setClassUnion("listOrNull", c("list", "NULL"))

HM = setClass("HM", 
	slots = c(Obs = "HMData", #CalibData = "HMDataOrNull",
            Pred = "list", Dots = "list", Parameters = "list", performance = "list", control = "list"),
  prototype = prototype(Obs = HMData(), #CalibData = NULL, 
                        Pred = list(),  Dots = list(), Parameters = list(), 
                        performance = list(), control = list()),
  validity = function(object) {
    stopifnot(is.null(object@Pred) || length(object@Pred) == 0 || all(sapply(object@Pred, FUN = function(x) is(x, "HMData"))))
    return(TRUE)
  })


HMPar = setClass("HMPar", slots = c(parameters = "data.frame",  
                                    model = "character", parlims = "list"),
                 prototype = prototype(parlims = list()))

setAs("HMPar", "list", function(from) sapply(slotNames(from), function(x) slot(from, x)))

HMobs = function(object) object@Obs
HMpred = function(object, model) {
  if (missing(model) || is.null(model)) {
    object@Pred
  } else {
    object@Pred[[model]]
  }
}
# HMparameters returns either:
#  - the complete set of Parameters
#  - the parameters of one model 
HMparameters = function(object, model) {
  opar = object@Parameters
  if (missing(model) || is.null(model)) {
    opar
  } else {
    opar[[names(opar) == model]]
  }
}

HMdots = function(object) object@Dots
HMcontrol = function(object) object@control
HMtemporalData = function(object) object@Temporal
HMspatialData = function(object) object@Spatial
HMspatiotemporalData = function(object) object@SpatioTemporal

updateParameters = function(obPars, Parameters){
  for (ip in 1:length(Parameters)) {
    pname = names(Parameters)[ip]
    if (pname %in% names(obPars)) {
      obPars[[pname]] = do.call("HMPar", modifyList(as(obPars[[pname]], "list"), as(Parameters[[ip]], "list")))
    } else {
      obPars[[pname]] = Parameters[[ip]]
    }
  }
  obPars  
}


