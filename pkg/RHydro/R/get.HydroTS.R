get.HydroTS <- function(object, 
            type = factor(c("flux","state")),
            origin = factor(c("simulated","measured")),
            data.types=get.data.types(object, type=type, origin=origin),
            stations=get.stations(object, type=type, origin=origin),
            runs = 1:max(object@metadata$run.ID),
            start = NULL, end = NULL
              ){
       
		  sel <- object@metadata$run.ID %in% runs &
	             object@metadata$origin %in% origin & 
	             object@metadata$type %in% type  &
		     object@metadata$name %in% data.types

           GIS.ID <- dimnames(coordinates(object@GIS))[[1]] %in% stations

	   sel <- sel & object@metadata$GIS.ID %in% GIS.ID

	   if(sum(sel)>1){
		  print("ToDo: convert to HydroTS for multi-selection")
		 browser() 
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

