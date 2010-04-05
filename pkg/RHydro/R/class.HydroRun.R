
## new class structure HydroRun
## to replace HydroModelRun
##
## some suggested conventions:
##
## - GIS is a list that consists of different spatial data (point, line, polygon, grid)
##   but we need to figure out how we structure it
##
## - for now everything is kept in one zoo object but we may have to experiment with that
##
## - we need to think about the structure of the metadata.
##   See current structure in prototype as a suggestion

setClass("HydroRun",
         representation = representation(parameters="HydroModelParameters",
                                         ts = "zoo",
                                         metadata = "data.frame",
                                         GIS = "Spatial",
                                         performanceMeasures="data.frame",
                                         modelSupportData="list",
                                         call="call"),
 ##        validity =  validityHydroRun,
         prototype = prototype(parameters = new("HydroModelParameters"),
                               ts = zoo(),
                               metadata = data.frame(ID = numeric(),
                                                     param.ID = numeric(),
                                                     GIS.ID = numeric(),
                                                     type = factor(levels=c("flux","state")),
                                                     name = factor(),
                                                     flux = numeric(),
                                                     origin = factor(levels=c("simulated","measured")),
                                                     dimensions = character(),
						     run.ID = numeric()),
                               GIS = NULL,
                               performanceMeasures=data.frame(),
                               modelSupportData = list(),
                               call = new("call")
         )    
)

setMethod("merge",
    signature(x= "HydroRun", y="HydroRun"),
    function(x, y, ...)
    {
	    #args: all, fill as in zoo
	    #Merge parameters
	    if(length(x@parameters@parameters)!=0 ||
	       length(y@parameters@parameters)!=0){
		    print("toDo: Implement Merging of parameters in class.HydroRun")
		    browser()
            } else {
		    new.parameters <- x@parameters
	    }

	    #Merge ts
	    no.x <- FALSE
	    no.y <- FALSE
	    if(length(x@ts)==0){
		    new.ts <- y@ts
		    no.x <- TRUE
	    } else if(length(y@ts)==0){
		    new.ts <- x@ts
		    no.y <- TRUE
	    } else {
		    new.ts <- merge(x@ts,y@ts)
	    }
	    #Merge GIS
	    if(no.x) {
		    new.GIS <- y@GIS
	    } else if(no.y){
		    new.GIS <- x@GIS
	    } else {
		    #use all x-data first and add y-data later
		    new.GIS <- x@GIS
		    map <- data.frame(x=c(),y=c())
		    for(x.dim in 1:NROW(coordinates(x@GIS))){
		       for(y.dim in 1:NROW(coordinates(y@GIS))){
			       if(identical(x@GIS[x.dim],y@GIS[y.dim])){
				       map <- rbind(map,data.frame(x=x.dim,y=y.dim))
			       }
		       }
		    }
		    #combine GIS-Data
		    for(y.dim in 1:NROW(coordinates(y@GIS))){
			    if(y.dim %in% map$y){
				    #replace gis.ID in metadata
                                    col.repl <- y@metadata$GIS.ID == y.dim
                                    y@metadata$GIS.ID[col.repl] <- map$x[map$y==y.dim]

			    } else {
				    #add data point and change ID
				    new.GIS <- rbind(new.GIS, y@GIS[y.dim])
				    new.ID <- NROW(coordinates(new.GIS))
                                    col.repl <- y@metadata$GIS.ID == y.dim
                                    y@metadata$GIS.ID[col.repl] <- new.ID
			    }
		    }
	    }
	    #Merge metadata
	    if(no.x) {
		new.metadata <- y@metadata
	    } else if(no.y){
		new.metadata <- x@metadata
	    } else {
		    if(any(c(!is.na(x@metadata$param.ID), !is.na(y@metadata$param.ID)))){
			    print("toDo: adjusting metadata to changing param.ID")
			    browser()
	            }
		    if(any(c(!is.na(x@metadata$run.ID), !is.na(y@metadata$run.ID)))){
			    print("toDo: adjusting metadata to changing run.ID")
			    browser()
	            }
		new.metadata <- rbind(x@metadata,y@metadata)
	    }
	    #Merge performanceMeasures
	    if(no.x) {
		    new.performanceMeasures <- y@performanceMeasures
	    } else if(no.y){
		    new.performanceMeasures <- x@performanceMeasures
	    } else {
		    if(length(x@performanceMeasures) != 0 ||
                       length(y@performanceMeasures) != 0){
			    print("toDo: Implement Merging of ... in class.HydroRun")
			    browser()
		    } else {
		         new.performanceMeasures <- x@performanceMeasures
		    }
	    }
	    #Merge modelSupportData
	    new.modelSupportData <- c(x@modelSupportData, y@modelSupportData)
	    #Merge call
	    new.call <- match.call()
            return(new("HydroRun", 
                       parameters = new.parameters,
                               ts = new.ts,
                               metadata = new.metadata,
                               GIS = new.GIS,
                               performanceMeasures=new.performanceMeasures,
                               modelSupportData = new.modelSupportData,
                               call = new.call))
    }
    )


setMethod("print",
    signature(x = "HydroRun"),
    function (x, ...) 
    {
      cat("Model ID: ",x@parameters@modelID,"\n")
      cat("\n")
      cat("Number of model runs: ", dim(x@parameters@parameters)[1],"\n")
      cat("Number of parameters: ", dim(x@parameters@parameters)[2],"\n")
      cat("Parameter names: ", names(x@parameters),"\n")
      cat("\n")
      cat("Modelled fluxes: ", as.character(unique(x@metadata$name[x@metadata$origin == "simulated" & x@metadata$type == "flux"])),"\n")
      cat("Modelled states: ", as.character(unique(x@metadata$name[x@metadata$origin == "simulated" & x@metadata$type == "state"])),"\n")
      cat("Measured fluxes: ", as.character(unique(x@metadata$name[x@metadata$origin == "measured" & x@metadata$type == "flux"])),"\n")
      cat("Measured states: ", as.character(unique(x@metadata$name[x@metadata$origin == "measured" & x@metadata$type == "state"])),"\n")
      cat("\n")
      cat("Calculated performance measures: ", names(x@performanceMeasures),"\n")
      cat("Model Support Data: ", names(x@modelSupportData),"\n")
      cat("Call: ")
      print(x@call)
    }
)

setMethod("summary",
    signature(object = "HydroRun"),
    function (object, ...) 
    {
      print(object, ...)
    }
)

setMethod("show",
    signature(object = "HydroRun"),
    function (object) 
    {
      print(object)
    }
)

"$.HydroRun" <- function(object, name = c("Qsim","Qobs","pm","performance")) {
  subset <- match.arg(name)
  if(subset == "pm" || subset == "performance") return(object@performanceMeasures)
  if(subset == "Qsim") return(object@ts[,object@metadata$origin == "simulated" & object@metadata$name == "Q"])
  if(subset == "Qobs") return(object@ts[,object@metadata$origin == "measured" & object@metadata$name == "Q"])
}


