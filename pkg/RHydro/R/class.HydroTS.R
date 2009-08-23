setGeneric("validity.check", function(object) { standardGeneric("validity.check") })

setGeneric("print")

HydroTSvalidity <- function(object){
    if(! object@TSorigin %in% c("recorded", "generated"))
        error.message = "TSorigin must be either 'recorded' or 'generated'"
    if(length(object@location.name) !=  NROW(object@coordinate@coords)){
        new.message <- "expecting length(object@location.name) == NROW(object@coordinate@coords)"
        if(exists("error.message")){
              error.message <- c(error.message, new.message)
        } else {
              error.message = new.message
        }
    }
    if(length(object@location.name) != NCOL(object@magnitude)){
        new.message <- "expecting length(object@location.name) == NCOL(object@magnitude)"
        if(exists("error.message")){
              error.message <- c(error.message, new.message)
        } else {
              error.message = new.message
        }
    }
    if(exists("error.message")){
       return(error.message)
    } else {
       return(TRUE)
    }

}

setOldClass("zoo")
setClass("HydroTS",
    representation = representation(magnitude="zoo",
		location.name="character",
                coordinate="Spatial", TSorigin="character", 
                accuracy="character",
                units="character", type="character"), 
    validity=HydroTSvalidity
    )

setAs("HydroTS", "numeric" ,
        function(from){
            as.vector(from@magnitude)
        }
)
setAs("numeric", "HydroTS",
        function(from){
              new("HydroTS", magnitude = zoo(from),
                  location.name="unknown",
                  coordinate = SpatialPoints(data.frame(x=0,y=0)),
                  TSorigin = "generated")
        }
)

setMethod("validity.check",
    signature(object = "HydroTS"),
    function (object) 
    {

    #Warning if units can not be checked or differ from preferred units
    skipcheck = FALSE
    if(length(object@type)==0){
        skipcheck = TRUE
        print(paste("Skipping data check because type is undefined for time series at location",object@location.name))
    } else if(any(line <-  rhydro.data.types$data.type ==object@type)){
        if(rhydro.data.types$prefered.units[line]!=object@units){
             skipcheck = TRUE
             print(paste("Skipping data check because units",object@units," are not standard units (",rhydro.data.types$prefered.units[line],") for time series of type ",object@type," at locations",paste(object@location.name, collapse=",")))
        }
    } else {
        print(paste("Skipping data check because data.type ",object@type,"is not a standard data type defined in rhydro.data.types"))
        skipcheck = TRUE
    }
    #Type dependent validity check
    if(!skipcheck){
        outside=FALSE
        if(!is.na(rhydro.data.types$max.value[line])){
                if(any(object@magnitude > rhydro.data.types$max.value[line], na.rm=TRUE)){
                      outside <- TRUE
                }
        }
        if(!is.na(rhydro.data.types$min.value[line])){
                if(any(object@magnitude < rhydro.data.types$min.value[line], na.rm=TRUE)){
                      outside <- TRUE
                }
        }
        if(outside){
             theRange <- paste(range(object@magnitude, na.rm=TRUE), collapse=",")
             print(paste("Data outside default range (",rhydro.data.types$max.value[line],",",rhydro.data.types$min.value[line],") for time series of type",object@type," (range: ",theRange,") and locations",paste(object@location.name, collapse=",")))
        }

        outside=FALSE
        if(!is.na(rhydro.data.types$max.slope[line])){
                if(any(diff(object@magnitude) > rhydro.data.types$max.slope[line], na.rm=TRUE)){
                      outside <- TRUE
                }
        }
        if(!is.na(rhydro.data.types$min.slope[line])){
                if(any(diff(object@magnitude) < rhydro.data.types$min.slope[line], na.rm=TRUE)){
                      outside <- TRUE
                }
        }
        if(outside){
             theRange <- paste(range(diff(object@magnitude), na.rm=TRUE), collapse=",")
             print(paste("Derivative of data outside default range (",rhydro.data.types$min.slope[line], ",",rhydro.data.types$max.slope[line],") for time series of type",object@type," (range: ",theRange,") and locations",paste(object@location.name, collapse=",")))
       }
    }
    }
)

setMethod("max",
    signature(x = "HydroTS"),
    function (x, ..., na.rm = FALSE) 
    {
          return(max(x@magnitude, ..., na.rm=na.rm))
    }
)

setMethod("min",
    signature(x = "HydroTS"),
    function (x, ..., na.rm = FALSE) 
    {
          return(min(x@magnitude, ..., na.rm=na.rm))
    }
)

setMethod("range",
    signature(x = "HydroTS"),
    function (x, ..., na.rm = FALSE) 
    {
          return(range(x@magnitude, ..., na.rm=na.rm))
    }
)

setMethod("initialize",
    signature(.Object = "HydroTS"),
    function (.Object, ...) 
    {
       .Object <- callNextMethod()
       return(.Object)
    }
)

setMethod("length",
    signature(x = "HydroTS"),
    function (x) 
    {
          return(length(x@magnitude))
    }
)

setMethod("plot",
    signature(x = "HydroTS"),
          function(x,y,...)plot(x@magnitude,...)
)

setMethod("print",
    signature(x = "HydroTS"),
    function (x, ...) 
    {
         print("HydroTS with coordinates")
         print(x@coordinate)
         print("Data:")
         print(x@magnitude)
    }
)

setMethod("summary",
    signature(object = "HydroTS"),
    function (object, ...) 
    {
        print("HydroTS")
        summary(object@coordinate)
        summary(object@magnitude)
    }
)
    
