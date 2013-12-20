
setClass("HydroModelParameters",
         representation(parameters = "data.frame",
                        call = "call",  # to generate 
                        n = "numeric",
                        modelID = "character"),
         prototype = prototype(parameters = data.frame(),
                               modelID = character())
         )

setAs("data.frame", "HydroModelParameters",
      function(from) new("HydroModelParameters",
                         parameters = from,
                         n = nrow(from)))

setAs("matrix", "HydroModelParameters",
      function(from) as(as.data.frame(from), "HydroModelParameters"))

setAs("numeric", "HydroModelParameters",
      function(from) new("HydroModelParameters",
                         parameters = as.data.frame(t(from))))

setAs("list", "HydroModelParameters",
      function(from) new("HydroModelParameters", call = as.call(from)))

setAs("HydroModelParameters", "data.frame",
      function(from) {
        if(nrow(from@parameters) == 0) resample(from)
        from@parameters
      })
      
setAs("HydroModelParameters", "matrix", function(from) as.matrix(from@parameters))

setMethod("print",
          signature(x = "HydroModelParameters"),
          function(x, ...) {
            cat("Model: ",x@modelID,"\n")
            cat("Parameters:\n")
            print(summary(x@parameters), ...)
            invisible(x)
          }
          )

setMethod("show",
          signature(object = "HydroModelParameters"),
          function(object) {
            print(object)
          }
)

setMethod("plot",
          signature(x = "HydroModelParameters"),
          function(x, y, ...) {
            oldpar <- par(..., no.readonly = T)
            on.exit(par(oldpar))
            npar <- length(x@parameters)
            nrow <- round(sqrt(npar))
            ncol <- ceiling(npar/nrow)
            par(mfrow=c(nrow,ncol))
            for(i in 1:length(x@parameters)) {
              if(is(x@parameters[,i],"numeric")) hist(x@parameters[,i], xlab = names(x@parameters)[i], main="")
              else plot(x@parameters[,i], xlab = names(x@parameters)[i], main="")
            }
          }
)

setMethod("summary",
  signature(object = "HydroModelParameters"),
  function (object, ...) 
  {
    print(object, ...)
  }
)

setMethod("names",
          signature(x = "HydroModelParameters"),
          function(x) {
            names(x@parameters)
          }
)


