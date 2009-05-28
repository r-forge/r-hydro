wasim.file2HydroTS <- function(file, is_recorded, is_flux, direction=zoo("out"), units, type){
    data <- wasim.read.table(file)
    if(is.null(data)) return(NULL)
    if(is_recorded){
          coordinate <- wasim.head2spatial(attr(data,"head"))
    } else {
          #Da noch Position und namen aus Parameterfile
          coordinate <- SpatialPoints(cbind(4111100,493330))
          warning("Coordinates for generated data not implemented")
    }
    if(is_flux){
        to.ret <- new("HydroFlux", magnitude = data,
TSorigin="recorded", coordinate=coordinate, direction=direction, units=units, type=type)
    } else {
        to.ret <- new("HydroState", magnitude = data, TSorigin="recorded", coordinate=coordinate, units=units, type=type)
    }
    return(to.ret)
}
