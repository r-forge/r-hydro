wasim.head2spatial <- function(head, x.line=3, y.line=4, z.line=2){
   head.split <- strsplit(head, "[ \t]+")
   cols <- 5:length(head.split[[x.line]])
   x <- as.double(head.split[[x.line]][cols])
   y <- as.double(head.split[[y.line]][cols])
   z <- as.double(head.split[[z.line]][cols])
   if(any(is.na(z))){
      S <- SpatialPoints(data.frame(x,y))
   } else {
      S <- SpatialPoints(data.frame(x,y,z))
   }
   return(S)
}
