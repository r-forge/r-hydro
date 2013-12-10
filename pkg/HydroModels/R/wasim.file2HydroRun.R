wasim.file2HydroRun <- function(file, 
		origin=factor("measured",levels=c("simulated","measured")), 
		type=factor("flux", levels=c("flux", "state")),
		parameter.name,
direction=zoo("out"), units, generated.header.info=NULL){
    data <- wasim.read.table(file)
    if(is.null(data)) return(NULL)
    if(origin=="measured"){
          coordinate <- wasim.head2spatial(attr(data,"head"), z.line=NA)
          dimnames(coordinate@coords)[[1]]=dimnames(data)[[2]]
    } else {
          if(is.null(generated.header.info) ||
             NCOL(data) - NCOL(generated.header.info@ts)>1 ||
             NCOL(data) - NCOL(generated.header.info@ts)<0){
             coordinate <- SpatialPoints(data.frame(x=rep(0,NCOL(data)), y=rep(0,NCOL(data))))
             dimnames(data)[[2]] <- paste("station",1:NCOL(data))
             dimnames(coordinate@coords)[[1]] <- dimnames(data)[[2]]
             
             warning("No header information for generated data available")
          } else {
              if(NCOL(data) - NCOL(generated.header.info@ts)==0){
                   coordinate <- generated.header.info@GIS
                   dimnames(data)[[2]] <- dimnames(generated.header.info@GIS)[[1]]
              }
              if(NCOL(data) - NCOL(generated.header.info@ts)==1){
                   coordinate <- SpatialPoints(rbind( generated.header.info@GIS@coords, c(0,0)))
                   dimnames(data)[[2]] <- c(dimnames(generated.header.info@ts)[[2]], "average")
                   dimnames(coordinate@coords)[[1]] <- dimnames(data)[[2]]
              }
          }
    }
    metadata  <-  data.frame(ID=1:NCOL(data), param.ID=NA, GIS.ID= 1:NCOL(data), type=type, name=parameter.name, flux=NA, origin=origin, dimension=units, run.ID=NA)
    to.ret  <- new("HydroRun", parameters=new("HydroModelParameters"), ts=data, metadata = metadata, GIS = coordinate, performanceMeasures=data.frame(), modelSupportData = list(), call = match.call())
    return(to.ret)
}
