get.HydroTS <- function(object, 
            type = factor(c("flux","state")),
            origin = factor(c("simulated","measured")),
            data.types=get.data.types(object, type=type, origin=origin),
            stations=get.stations(object, type=type, origin=origin),
            runs = 1:max(object@metadata$run.ID),
            start = NULL, end = NULL
              ){

            data.part <- subset(object, type=type, origin=origin, data.types=data.types, stations=stations, runs=runs,start=start,end=end)
       
	  print("ToDo: convert HydroRun to  HydroTS ")
	 browser() 

	   if(sum(sel)>1){
	 } else {
             md <- object@metadata[sel,]
             toRet <- new("HydroFlux", magnitude = object@ts[,sel], 
                         location.name = dimnames(coordinates(object@GIS))[[1]][md$GIS.ID],
                         coordinate= object@GIS[md$GIS.ID],
                         TSorigin = as.character(md$origin),
                         accuracy = "unknown",
                         units = as.character(md$dimension),
                         type = as.character(md$name), direction=zoo("out")
             )
	 }

}

