
read.IPCC.GCM <- function(file) { 
  require(ncdf)
  require(sp)

  nc <- open.ncdf(file)
  
  lat <- get.var.ncdf(nc,"latitude")
  long <- get.var.ncdf(nc, "longitude")

  latx  <- rep(lat,length(long))
  longx <- rep(long, length(lat))
  longx <- as.vector(t(matrix(longx,nrow=length(long))))
  
  longx[longx > 180] <-  longx[longx > 180] - 360
  
  var <- get.var.ncdf(nc)
  
  data <- data.frame(jan = as.vector(t(var[,,1])),
                     feb = as.vector(t(var[,,2])),
                     mar = as.vector(t(var[,,3])),
                     apr = as.vector(t(var[,,4])),
                     may = as.vector(t(var[,,5])),
                     jun = as.vector(t(var[,,6])),
                     jul = as.vector(t(var[,,7])),
                     aug = as.vector(t(var[,,8])),
                     sep = as.vector(t(var[,,9])),
                     oct = as.vector(t(var[,,10])),
                     nov = as.vector(t(var[,,11])),
                     dec = as.vector(t(var[,,12]))
                     )
  
  mappoints <- data.frame(x = longx, y = latx)
  map <- cbind(mappoints, data)
  coordinates(map) = ~x + y
  proj4string(map) <- CRS("+proj=latlong +datum=WGS84")
  close.ncdf(nc)
  
  return(map)
}
