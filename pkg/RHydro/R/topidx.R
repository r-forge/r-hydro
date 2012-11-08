topidx <- function(DEM, res, river=NA) {

  ## data preparation and checking
  
  DEM <- as(DEM, "matrix")
  if(min(as.vector(DEM[!is.na(DEM)])) < -9000)
    stop("DEM contains unrealistic values (< -9000)")
  DEM[is.na(DEM)] <- -9999

  my.nrow <- dim(DEM)[1]
  my.ncol <- dim(DEM)[2]

  if(!is.na(river)) {
    river <- as(river, "matrix")
    if(min(river) < 0) stop("Error: the object 'river' should only contain positive values")
  } else river = rep(0, my.nrow * my.ncol)
  
  ## calling the function

  result <- .C("topidx",
               #PACKAGE = "topmodel", # EJP: topmodel heritage...
               PACKAGE = "RHydro",
               as.double(DEM),
               as.integer(river),
               as.integer(my.nrow),
               as.integer(my.ncol),
               as.double(res),
               as.double(res),
               result = double(length(DEM)*2))$result

  ## formatting the results

  atb  <- matrix(result[1:(my.nrow*my.ncol)],nrow=my.nrow)
  area <- matrix(result[(my.nrow*my.ncol+1):(my.nrow*my.ncol*2)],nrow=my.nrow)

  atb[atb < -9000] <- NA
  area[area < -9000] <- NA

  return(list(atb = atb,area = area))

}
