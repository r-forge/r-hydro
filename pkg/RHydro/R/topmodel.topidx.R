topidx <- function(DEM, resolution, river=NA) {

  ## data preparation and checking
  
  DEM <- as(DEM, "matrix")
  if(min(as.vector(DEM[!is.na(DEM)])) < -9000)
    stop("DEM contains unrealistic values (< -9000)")
  DEM[is.na(DEM)] <- -9999
  
  if(!is.na(river)) {
    river <- as(river, "matrix")
    if(min(river) < 0) stop("Error: the object 'river' should only contain positive values")
  }
  else river = rep(0,nrow*ncol)
  
  nrow <- dim(DEM)[1]
  ncol <- dim(DEM)[2]

  ## calling the function

  result <- .C("topidx",
               PACKAGE = "topmodel",
               as.double(DEM),
               as.integer(river),
               as.integer(nrow),
               as.integer(ncol),
               as.double(resolution),
               as.double(resolution),
               result = double(length(DEM)*2))$result

  ## formatting of the results

  atb  <- matrix(result[1:(nrow*ncol)],nrow=nrow)
  area <- matrix(result[(nrow*ncol+1):(nrow*ncol*2)],nrow=nrow)

  atb[atb < -9000] <- NA
  area[area < -9000] <- NA

  return(list(atb = atb,area = area))

}
