get.data.types <- function(object, 
            type = factor(c("flux","state")),
            origin = factor(c("simulated","measured")),
            runs = 1:max(object@metadata$run.ID)
	    #stations=get.stations(object, type=type, origin=origin)
            ){
           sel <- object@metadata$run.ID %in% runs &
	             object@metadata$origin %in% origin & 
	             object@metadata$type %in% type  

		     # GIS.ID <- dimnames(coordinates(object@GIS))[[1]] %in% stations

		     #sel <- sel & object@metadata$GIS.ID %in% GIS.ID

	   types <- object@metadata$name[sel]

           types <-  unique(types)
           return(types[order(types)])
 
}

