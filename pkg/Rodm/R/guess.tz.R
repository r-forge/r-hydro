guess.tz <- function(tz){
	return(switch(as.character(tz), "0"="GMT", stop(paste("undefined tz:", tz))))

}
