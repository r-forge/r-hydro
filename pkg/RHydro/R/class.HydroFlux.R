setClass("HydroFlux",
    representation = representation(direction="zoo"),
    contains = "HydroTS"
    )

setAs("numeric", "HydroFlux",
        function(from){
              from <- as(from, "HydroTS")
              from <- as(from, "HydroFlux")
        }
)

setAs("HydroFlux", "numeric" ,
        function(from){
              from <- as(from, "HydroTS") 
              from <- as(from, "numeric")
        }
)

setAs("HydroFlux", "HydroTS",
        function(from){
             to <- new("HydroTS", magnitude = from@magnitude, 
                         location.name = from@location.name,
                         coordinate= from@coordinate,
                         TSorigin = from@TSorigin,
                         accuracy = from@accuracy,
                         units = from@units,
                         type = from@type
             )
             return(to)
        }
)

setAs("HydroTS", "HydroFlux",
        function(from){
             to <- new("HydroFlux", magnitude = from@magnitude, 
                         location.name = from@location.name,
                         coordinate= from@coordinate,
                         TSorigin = from@TSorigin,
                         accuracy = from@accuracy,
                         units = from@units,
                         type = from@type, direction=zoo("out")
             )
             return(to)
        }
)
