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
    #Warning if units can not be checked or differ from preferred units
    skipcheck = FALSE
    if(length(object@type)==0){
        skipcheck = TRUE
        warning(paste("Skipping data check because type is undefined for time series at location",object@location.name))
    } else if(any(line <-  rhydro.data.types$data.type ==object@type)){
        if(rhydro.data.types$prefered.units[line]!=object@units){
             skipcheck = TRUE
             warning(paste("Skipping data check because units",object@units," are not standard units (",rhydro.data.types$prefered.units[line],") for time series at location",object@location.name))
        }
    } else {
        warning(paste("Skipping data check because data.type ",object@type,"is not a standard data type defined in rhydro.data.types for time series at location",object@location.name))
        skipcheck = TRUE
    }
    #Type dependent validity check
    if(!skipcheck){
        if(!is.na(rhydro.data.types$max.value[line])){
                if(object@magnitude > rhydro.data.types$max.value[line]){
                      warning(paste("Data above default range (",rhydro.data.types$max.value[line],") for time series of type",object@type,"and location",object@location.name))
                }
        }
        if(!is.na(rhydro.data.types$min.value[line])){
                if(object@magnitude < rhydro.data.types$min.value[line]){
                      warning(paste("Data below default range (",rhydro.data.types$min.value[line],") for time series of type",object@type,"and location",object@location.name))
                }
        }
        if(!is.na(rhydro.data.types$max.slope[line])){
                if(diff(object@magnitude) > rhydro.data.types$max.slope[line]){
                      warning(paste("Derivative of data above default range (",rhydro.data.types$max.slope[line],") for time series of type",object@type,"and location",object@location.name))
                }
        }
        if(!is.na(rhydro.data.types$min.slope[line])){
                if(diff(object@magnitude) < rhydro.data.types$min.slope[line]){
                      warning(paste("Derivative of data below default range (",rhydro.data.types$min.slope[line],") for time series of type",object@type,"and location",object@location.name))
                }
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

setMethod("initialize",
    signature(.Object = "HydroTS"),
    function (.Object, ...) 
    {
       .Object <- callNextMethod()
       return(.Object)
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
    
