setClass("HydroWasimParameters",
         contains= "HydroModelParameters",
         prototype=prototype(modelID = "Wasim"))

#setAs("numeric", "HydroTopmodelParameters",
#      function(from) {
#        from <- as(from,"HydroModelParameters")
#        from <- new(from,"HydroTopmodelParameters")
#        from@modelID <- "Topmodel"
#        colnames(from@parameters) <- c("Q0","lnTe","m","D0","Dmax","td","v","Ks","CD","dt")
#      }
#      )
#
#setAs("matrix", "HydroTopmodelParameters",
#      function(from) {
#        from <- as(from,"HydroModelParameters")
#        from <- new(from,"HydroTopmodelParameters")
#        from@modelID <- "Topmodel"
#        colnames(from@parameters) <- c("Q0","lnTe","m","D0","Dmax","td","v","Ks","CD","dt")
#      }
#      )
#
#setAs("HydroModelParameters", "HydroTopmodelParameters",
#      function(from) {
#        from <- new(from,"HydroTopmodelParameters")
#        from@modelID <- "Topmodel"
#        colnames(from@parameters) <- c("Q0","lnTe","m","D0","Dmax","td","v","Ks","CD","dt")
#      }
#      )
#
#setAs("HydroModelParameters", "data.frame", function(from) from@parameters)
#setAs("HydroModelParameters", "matrix", function(from) as.matrix(from@parameters))

#setAs("list","HydroWasimParameters",  function(from) new(HydroWasimParameters))


