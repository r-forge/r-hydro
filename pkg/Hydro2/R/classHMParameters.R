
setClass("HMParameters",
         representation(parameters = "data.frame",
                        call = "call",  # to generate 
                        n = "numeric",
                        modelID = "character"),
         prototype = prototype(parameters = data.frame(),
                               modelID = character())
         )

setAs("data.frame", "HMParameters",
      function(from) new("HMParameters",
                         parameters = from,
                         n = nrow(from)))

setAs("matrix", "HMParameters",
      function(from) as(as.data.frame(from), "HMParameters"))

setAs("numeric", "HMParameters",
      function(from) new("HMParameters",
                         parameters = as.data.frame(t(from))))

setAs("list", "HMParameters",
      function(from) new("HMParameters", call = as.call(from)))

setAs("HMParameters", "data.frame",
      function(from) {
        if(nrow(from@parameters) == 0) resample(from)
        from@parameters
      })
      
setAs("HMParameters", "matrix", function(from) as.matrix(from@parameters))

setMethod("print",
          signature(x = "HMParameters"),
          function(x, ...) {
            cat("Model: ",x@modelID,"\n")
            cat("Parameters:\n")
            print(summary(x@parameters), ...)
            invisible(x)
          }
          )

setMethod("show",
          signature(object = "HMParameters"),
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


