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
    #ToDo: Warning if units differ from prefered units
    #ToDo: Type dependend validity check
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
    
