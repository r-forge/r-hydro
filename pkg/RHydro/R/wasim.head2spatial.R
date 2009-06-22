wasim.head2spatial <- function(head, x.line=3, y.line=4, z.line=2){
   cols <- 5:length(head[[x.line]])
   x <- as.double(head[[x.line]][cols])
   y <- as.double(head[[y.line]][cols])
   z <- as.double(head[[z.line]][cols])
   if(any(is.na(z))){
      S <- SpatialPoints(data.frame(x,y))
   } else {
      S <- SpatialPoints(data.frame(x,y,z))
   }
   return(S)
}
