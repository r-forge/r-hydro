get.stations <- function(object, 
            type = factor(c("flux","state")),
            origin = factor(c("simulated","measured")),
              data.types=get.data.types(object, type=type, origin=origin),
              runs=1:max(object@metadata$run.ID), unique=TRUE ){
                     
               sel <- object@metadata$run.ID %in% runs &
	             object@metadata$origin %in% origin & 
	             object@metadata$type %in% type &
		     object@metadata$name %in% data.types

	       GIS.ID <- object@metadata$GIS.ID[sel]

	      stations <-  dimnames(coordinates(object@GIS[GIS.ID]))[[1]] 

           if(is.null(stations)){
              return(stations)
           }
	   if(unique){
	      stations <- unique(stations)
              return(stations[order(stations)])
	   } else {
              return(stations)
	   }

}

