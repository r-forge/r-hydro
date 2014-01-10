topidx <- function(DEM, river=NA) {
  
  stopifnot(is(DEM, "SpatialGridDataFrame"))

  ## TODO: check that we have equidistant projection

  ## check resolution
  stopifnot(DEM@grid@cellsize[1] == DEM@grid@cellsize[2])

  ## check layers

  if(ncol(DEM@data) > 1) stop("DEM contains too many layers")
  
  ## check unrealistic values
  if(min(DEM@data < -9000)) stop("DEM contains unrealistic values (< -9000)")
  DEM@data[is.na(DEM@data)] <- -9999

  if(!is.na(river)) {
    river <- as(river, "matrix")
    if(min(river) < 0) stop("Error: the object 'river' should only contain positive values")
  } else river = rep(0, length(DEM))
  
  ## calling the function

  result <- .C("topidx",
               PACKAGE = "HydroModels",
               as.double(as.matrix(DEM)),
               as.integer(river),
               as.integer(DEM@grid@cells.dim[1]),
               as.integer(DEM@grid@cells.dim[2]),
               as.double(DEM@grid@cellsize[1]),
               as.double(DEM@grid@cellsize[2]),
               result = double(length(DEM)*2))$result

  ## formatting the results

  result[result < -9000] <- NA
  out <- DEM
  out@data <- data.frame(DEM = DEM@data,
                         atb = result[1:length(DEM)],
                         area = result[(length(DEM) + 1):length(result)])
  return(out)

}
