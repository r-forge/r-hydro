HydroTSvalidity <- function(object){
    if(! object@TSorigin %in% c("recorded", "generated"))
        message = "TSorigin must be either 'recorded' or 'generated'"
    #stopifnot(class(object@magnitude)=="zoo")
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
    
