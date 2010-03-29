
setClass("HydroTopmodelParameters",
         contains = "HydroModelParameters",
         prototype = prototype(parameters = data.frame(Q0 = double(0),
                                                       lnTe = double(0),
                                                       m = double(0),
                                                       D0 = double(0),
                                                       Dmax = double(0),
                                                       td = double(0),
                                                       v = double(0),
                                                       Ks = double(0),
                                                       CD = double(0)),
                               modelID = "Topmodel"),
         validity = function(object) {
           ## check that number of parameters is correct
           if(length(object@parameters) !=9)
             return("Incorrect number of parameters")
           ## check for negative initial subsurface flow
           if(any(object@parameters[1] < 0))
             return("Initial subsurface flow should not be negative")
           ## check for negative or extremely low streamflow velocity
           if(any(object@parameters[7] < 50))
             return("Stream flow velocity should not be smaller than 50m/h")
           return(TRUE)
         }
         )

setAs("numeric", "HydroTopmodelParameters",
      function(from) {
        from <- as(from,"HydroModelParameters")
        from <- as(from,"HydroTopmodelParameters")
      }
      )

setAs("matrix", "HydroTopmodelParameters",
      function(from) {
        from <- as(from,"HydroModelParameters")
        from <- as(from,"HydroTopmodelParameters")
      }
      )

setAs("HydroModelParameters", "HydroTopmodelParameters",
      function(from) {
        from <- new("HydroTopmodelParameters", parameters=from@parameters)
        from@modelID <- "Topmodel"
        names(from@parameters) <- c("Q0","lnTe","m","D0","Dmax","td","v","Ks","CD")
        return(from)
      }
)

setAs("HydroModelParameters", "data.frame", function(from) from@parameters)
setAs("HydroModelParameters", "matrix", function(from) as.matrix(from@parameters))

setMethod("print",
          signature(x = "HydroTopmodelParameters"),
          function(x, ...) print(as(x,"HydroModelParameters"), ...)
)

setMethod("show",
          signature(object = "HydroTopmodelParameters"),
          function(object) print(object)
)

setMethod("summary",
          signature(object = "HydroModelParameters"),
          function (object, ...) 
          {
            print(object, ...)
          }
)
