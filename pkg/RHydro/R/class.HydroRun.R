
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
setGeneric("validity.check", function(object) { standardGeneric("validity.check") })

setOldClass("zoo")

validityHydroRun <- function(object){
	#Check that name %in% rhydro.data.types$data.type
	#if(any(invalid  <- !object@metadata$name %in% rhydro.data.types$data.type)){
	#	print(paste("all metadata$name must be one of the types listed in rhydro.data.types$data.type\r This is not true for entry ", which(invalid),":",object@metadata$name[invalid] ))
	#	ToDo:Make a warning here
	#	stop()
	#}
	#Check for correct column names of metadata
	required.columns <- c( "ID",        "param.ID",  "GIS.ID",    "type",      "name",      "flux",     "origin",    "dimension", "run.ID")
	if(any(missing <- !required.columns %in% names(object@metadata))){
		print(paste("metadata is missing the column", required.columns[missing]))
		stop()
	}

	#print("validityHydroRun")
	#browser()
}
setClass("HydroRun",
         representation = representation(parameters="HydroModelParameters",
                                         ts = "zoo",
                                         metadata = "data.frame",
                                         GIS = "Spatial",
                                         performanceMeasures="data.frame",
                                         modelSupportData="list",
                                         call="call"),
         validity =  validityHydroRun,
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
setMethod("validity.check",
    signature(object = "HydroRun"),
    function (object) 
    {
	    stop("ToDo: Not implemented")
    }
)
setMethod("merge",
    signature(x= "HydroRun", y="HydroRun"),
    function(x, y, ...)
    {
	    #args: all, fill as in zoo
	    #Merge parameters
	    if(length(x@parameters@parameters)!=0 &
	       length(y@parameters@parameters)!=0){
		    print("toDo: Implement Merging of parameters in class.HydroRun")
		    browser()
		    #change numbering of parameter.ID
		    #combine parameters
            } else if(length(x@parameters@parameters)!=0){
		    new.parameters <- x@parameters
	    } else {
		    new.parameters <- y@parameters
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

setGeneric("get.names", def= function(object, ...){standardGeneric("get.names")}) 
setMethod("get.names",
    signature(object = "HydroRun"),
    function (object, ...) 
    {
	fixed <- c("pm","performance","Qsim","Qobs")
	sym <- unique(merge(object@metadata, rhydro.data.types, by.x="name", by.y="data.type")[,c("symbol","origin","run.ID")])
	sym$or <- "sim"
	sym$or[sym$origin=="measured"] <- "obs"
	
	sym.a <- unique(sym$symbol)
	sym.b <- unique(paste(sym$symbol, sym$or,sep="."))
	sym.c <- unique(paste(sym$symbol, sym$or, sym$run.ID,sep="."))
	return(c(fixed,sym.a,sym.b,sym.c))
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
      cat("Modelled fluxes: ", paste(unique(x@metadata$name[x@metadata$origin == "simulated" & x@metadata$type == "flux"]), collapse="; "),"\n")
      cat("Modelled states: ", paste(unique(x@metadata$name[x@metadata$origin == "simulated" & x@metadata$type == "state"]), collapse="; "),"\n")
      cat("Measured fluxes: ", paste(unique(x@metadata$name[x@metadata$origin == "measured" & x@metadata$type == "flux"]), collapse="; "),"\n")
      cat("Measured states: ", paste(unique(x@metadata$name[x@metadata$origin == "measured" & x@metadata$type == "state"]), collapse="; "),"\n")
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

setMethod("subset",
    signature(x= "HydroRun"),
    function(x, 
            type = factor(c("flux","state")),
            origin = factor(c("simulated","measured")),
            data.types=get.data.types(x, type=type, origin=origin),
	    dimension=unique(x@metadata$dimension),
            stations=get.stations(x, type=type, origin=origin),
            runs = 1:max(x@metadata$run.ID),
            start = NULL, end = NULL
              ){
       
		  sel <- x@metadata$run.ID %in% runs &
	             x@metadata$origin %in% origin & 
	             x@metadata$dimension %in% dimension & 
	             x@metadata$type %in% type  &
		     x@metadata$name %in% data.types

           GIS.ID <- which(dimnames(coordinates(x@GIS))[[1]] %in% stations)
	   

	   sel <- sel & x@metadata$GIS.ID %in% GIS.ID

	   #Transform GIS.ID's
	   ID.map <- data.frame(old.ID = 1:NROW(coordinates(x@GIS)), new.ID=NA)
	   ID.map[GIS.ID,]$new.ID <- 1:length(GIS.ID)
	   new.metadata <- x@metadata[sel,] 
	   new.metadata$GIS.ID <- ID.map$new.ID[new.metadata$GIS.ID]


	   if(sum(sel)==0) return(NULL)

           return(new("HydroRun", 
                       parameters = x@parameters, #ToDo: remove irrelevant
		               #ToDo: reduce time range to actual observations
                               ts = window(x@ts[,sel], start=start, end=end),
                               metadata = new.metadata,
                               GIS = x@GIS[GIS.ID],
                               performanceMeasures=x@performanceMeasures[sel,],
                               modelSupportData = x@modelSupportData,
                               call = match.call()))
   }
)


setMethod("show",
    signature(object = "HydroRun"),
    function (object) 
    {
      print(object)
    }
)

"$.HydroRun" <- function(object, name) {
  subset <- match.arg(name, choices=get.names(object))
  parts <- strsplit(subset, ".", fixed=TRUE)[[1]]
  #treat fixed (non-automatic names)
  if(length(parts)==1){
	  if(parts == "Qobs") parts <- c("Q","obs")
	  if(parts == "Qsim") parts <- c("Q","sim")
          if(parts == "pm" || parts == "performance") return(object@performanceMeasures)
  }
  sym <- merge(object@metadata, rhydro.data.types, by.x="name", by.y="data.type", all.x=TRUE)[,c("symbol","origin","run.ID")]
	sym$or <- "sim"
	sym$or[sym$origin=="measured"] <- "obs"

  #select by symbol only
  if(length(parts)==1){
      return(object@ts[,sym$symbol==parts])
  }
  if(length(parts)==2){
      return(object@ts[,sym$symbol==parts[1] & sym$or==parts[2]])
  }
  if(length(parts)==3){
      return(object@ts[,sym$symbol==parts[1] & sym$or==parts[2]& sym$run.ID==parts[3]])
  }
}

setMethod("plot",
    signature(x = "HydroRun"),
    function (x, y, 
              hydro.plot.type=c("rainfall-runoff", "by.data.type", "by.station", "balance"),
              type = factor(c("flux","state")),
              origin = factor(c("simulated","measured")),
              data.types=get.data.types(object, type=type, origin=origin),
              stations=get.stations(object, type=type, origin=origin),
              balance.types=unique(unlist(getBalanceTypes.rhydro.data.types())),
              legend.position="right",
              runs=1:get.runCount(x),
              ...) 
    {
        hydro.plot.type <- match.arg(hydro.plot.type, several.ok=TRUE)
	#type <- match.arg(type, several.ok=TRUE)
	#origin <- match.arg(origin, several.ok=TRUE)
        to.ret <- list()
            #oldpar <- par(ask=TRUE)
            if("rainfall-runoff" %in% hydro.plot.type){
                skip.plot=FALSE
                if(!skip.plot){
                    for(run in runs){
                        for(station in get.stations(x,
                                type="flux", origin="measured", 
                                data.types="discharge")){

				rain <- subset(x, type="flux", origin="simulated",  data.types="precipitation", stations=station, runs=run)
				if(is.null(rain)){
				    rain <- subset(x, type="flux", origin="measured" , data.types="precipitation", stations=station, runs=run)
				    if(is.null(rain)){
				       warning("no rainfall data avialable for rainfall runoff plot")
				       skip.plot=TRUE
				    }
				    warning("no modelled precipitation available for rainfall runoff model - using measured values instead")
				}
				q.model <- subset(x, type="flux", origin="simulated",  data.types="discharge", stations=station, runs=run)
				if(is.null(q.model)){
				   warning("no modelled discharge data avialable for rainfall runoff plot")
				   skip.plot=TRUE
				}
				
				q.measured <- subset(x, type="flux", origin="measured" , data.types="discharge", stations=stations, runs=runs)
                                if(!is.null(q.measured)){
                                }
                                plot_rainfall.runoff(rain@ts,
                                     q.model@ts, 
                                     q.measured@ts,
                                     main=paste("Station:", station, "Run:", run),
                                     q.units=q.model@metadata$dimension,
                                     p.units=rain@metadata$dimension
                                     )
                        }
                    }
                }
            }
            if("by.data.type" %in% hydro.plot.type){
		 for(data.type in data.types){
		    for(run in runs){
			    ss <- subset(x,data.types=data.type, origin=origin , runs=run, station=stations )
			    plot(ss@ts, main=paste(data.type, "Run:", run), ylab=paste(get.stations(ss,unique=FALSE), ss@metadata$dimension), ...)
	            }
		 }

            }
            if("by.station" %in% hydro.plot.type){
              for(the.station in stations){
		     for(dimension in unique(x@metadata$dimension)){
			    ss <- subset(x,data.types=data.types, origin=origin , runs=runs, station=the.station, dimension=dimension )
			    if(!is.null(ss)){
				    plot(ss@ts, plot.type="single", ylab=dimension, col=1:length(ss@metadata),main=the.station,...)
				    legend(legend.position, as.character(ss@metadata$name),col=1:length(ss@metadata), lty=1)
		            }
	             } 
	      }
            }
            if("balance" %in% hydro.plot.type){
                #loop through balance types
                for(the.class in c("simulated", "measured")){
			#d.the.class <- paste(the.class,"Fluxes", sep="")
                        to.ret[[the.class]] <- list()
                    for(balance.type in balance.types){
                        #what data.types occur in this balance?
                        to.ret[[the.class]][[balance.type]] <- list()
                        balance.type.list <- getBalanceTypes.rhydro.data.types()
                        balance.type.hit <- sapply(balance.type.list, FUN <- function(x){ any(balance.type %in% x)})
                        #extract colors
                        b.data.types <- rhydro.data.types$data.type[balance.type.hit]
                        b.type.color <- getBalanceColor.rhydro.data.types(data.type = b.data.types, balance.type=balance.type)
			#select only stations relevant for the current type
                        if(identical(stations,get.stations(x, type=type, origin=origin ))){
                             stations=get.stations(x, origin=the.class,  data.types=b.data.types)
                        }
                        #loop through runs and stations
                        for(run in runs){
                           to.ret[[the.class]][[balance.type]][[run]] <- list()
                           summary.data.state <- data.frame(name=c(), change=c())
                           for(station in stations){
                                #calc plot range
                                rangeTS <- subset(x,
                                         data.types=b.data.types,
                                         station=station,
                                         runs=run)
                                if(!is.null(rangeTS)){
                                    #first determine common x-range
                                    x.range <- range(index(rangeTS@ts),na.rm=TRUE)
                                    #calculate y range for correct x-range
				    #build sum of flux data
                                    rangeTSa <- subset(x,
				         type="flux",
                                         data.types=b.data.types,
                                         station=station,
                                         runs=run)
                                    
                                    y.range <- NULL
                                    if(!is.null(rangeTSa)){
                                    y.range <- c(0,
				       sum(rangeTSa@ts, na.rm=TRUE)
                                       )
                                    }
				    #range of state data
                                    rangeTSa <- subset(x,
				         type="state",
                                         data.types=b.data.types,
                                         station=station,
                                         runs=run)
                                    if(!is.null(rangeTSa)){
                                        state.max <- max(rangeTSa@ts,na.rm=TRUE)
                                        state.min <- min(rangeTSa@ts,na.rm=TRUE)
                                        if(is.null(y.range)){
                                            y.range <- c(state.min,state.max)
                                        } else {
                                            if(state.max > y.range[2])
                                                 y.range[2] <- state.max
                                            if(state.min < y.range[1])
                                                 y.range[1] <- state.min
                                        }
                                    }
                                    if(is.null(y.range)) stop(paste("no data to plot for run", run,"station",station, "balance.type", balance.type))
				    #ToDo: Smarter treatment of units
                                    plot(x.range,y.range, type="n", xlab="time", ylab= rangeTS@metadata$dimension[1], main=paste(balance.type," (",the.class, ") at station ", station, " for run ", run, sep=""))
                                }

                                #get flux data
                                allTS <- subset(x, origin=the.class,
				     type="flux",
                                     data.types=b.data.types,
                                     station=station,
                                     runs=run)
		                if(!is.null(allTS)){
					summary.data.flux <- matrix(nrow=NROW(allTS@metadata), ncol=3) 
					dimnames(summary.data.flux)[[2]] <- c("name","change","direction")
					
					ts.nr <- 1

					for(ts.col in 1:NCOL(allTS@ts)){
					    #build sums for flux data
					    ts <- allTS@ts[,ts.col]
					       ts.name <- as.character(allTS@metadata$name[ts.col])
					       nas <- is.na(ts)
					       if(any(nas)){
						   warning(paste("setting NA data to 0 while calculating cumulative sum for station",station,"run",run," and data type", ts.name))
						   ts[nas] <- 0

					       }
					       the.sum <- cumsum(ts)
					       the.sum[nas] <- NA
						#plot flux data by station and run
						col <- b.type.color[ts.name == b.data.types]
						lines(index(ts), the.sum, col=col)
						summary.data.flux[ts.nr,] <- c(ts.name, max(the.sum, na.rm=TRUE), allTS@metadata$flux[ts.col])
						ts.nr <- ts.nr + 1
						#store total flux change (end sum) (with direction)
					}
			       } else {
				       summary.data.flux <- NULL
			       }
                                
                                #get state data
                                allTS <- subset(x, origin=the.class,
				     type="state",
                                     data.types=b.data.types,
                                     station=station,
                                     runs=run)
		                if(!is.null(allTS)){
                                
					summary.data.state <- matrix(nrow=NROW(allTS@metadata), ncol=2) 
					dimnames(summary.data.state)[[2]] <- c("name","change")
					ts.nr <- 1
					for(ts.col in 1:NCOL(allTS@ts)){
					    ts <- allTS@ts[,ts.col]
					    ts.name <- as.character(allTS@metadata$name[ts.col])
					    #build changes for state data
						#plot state data (on different axis?)
						col <- b.type.color[ts.name == b.data.types]
						lines(ts, col=col)
						change <- as.numeric(ts[length(ts)]) - as.numeric(ts[1])
						#store total state change
						summary.data.state[ts.nr,] <-  c(ts.name, change)
						ts.nr <- ts.nr + 1
					}
			       } else {
				       summary.data.state <- NULL
			       }
                               #create list with summary data
                               to.ret[[the.class]][[balance.type]][[run]][[station]]  <- list(flux=summary.data.flux, state=summary.data.state)
                               legend.entries <- c(summary.data.flux[,1], summary.data.state[,1])
			       if(!is.null(legend.entries)){
				       legend.entries <- legend.entries[!is.na(legend.entries)]
				       legend.col <- sapply(legend.entries, FUN=function(x){b.type.color[x==b.data.types]})
				       if(length(legend.entries >0)){
					   legend("topleft", cex=0.5, legend=legend.entries, col=legend.col, lty=1, inset=0.05) 
				       }
		       		}
                           }
                       }
                    }
                }

            }
 
            #par(oldpar)
            return(to.ret)

    }
)


