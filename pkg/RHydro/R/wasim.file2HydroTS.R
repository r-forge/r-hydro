wasim.file2HydroTS <- function(file, is_recorded, is_flux,
direction=zoo("out"), units, type, generated.header.info=NULL){
    data <- wasim.read.table(file)
    if(is.null(data)) return(NULL)
    if(is_recorded){
          coordinate <- wasim.head2spatial(attr(data,"head"))
    } else {
          if(is.null(generated.header.info) ||
             NCOL(data) - NCOL(generated.header.info@magnitude)>1 ||
             NCOL(data) - NCOL(generated.header.info@magnitude)<0){
             coordinate <- SpatialPoints(data.frame(x=rep(0,NCOL(data)), y=rep(0,NCOL(data))))
             dimnames(data)[[2]] <- paste("station",1:NCOL(data))
             
             warning("No header information for generated data available")
          } else {
              if(NCOL(data) - NCOL(generated.header.info@magnitude)==0){
                   coordinate <- generated.header.info@coordinate
                   dimnames(data)[[2]] <- dimnames(generated.header.info@magnitude)[[2]]
              }
              if(NCOL(data) - NCOL(generated.header.info@magnitude)==1){
                   coordinate <- SpatialPoints(rbind( generated.header.info@coordinate@coords, c(0,0)))
                   dimnames(data)[[2]] <- c(dimnames(generated.header.info@magnitude)[[2]], "average")
              }
          }
    }
    origin <- if(is_recorded) "recorded" else "generated"
    if(is_flux){
        to.ret <- new("HydroFlux", magnitude = data,
TSorigin=origin, coordinate=coordinate, direction=direction,
units=units, type=type, location.name=dimnames(data)[[2]])
    } else {
        to.ret <- new("HydroState", magnitude = data, TSorigin=origin, coordinate=coordinate, units=units, type=type, location.name=dimnames(data)[[2]])
    }
    return(to.ret)
}
