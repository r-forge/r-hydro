tz2offset <- function(tz){
      return(switch(as.character(tz), "GMT"=0, stop(paste("unknown tz:", tz))))

}
