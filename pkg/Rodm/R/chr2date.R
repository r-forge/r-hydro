chr2date <- function(string, tz){
	if(all(nchar(string)==10)){
		if(tz!="GMT") warning("Unsupported tz handling other than GMT in chr2date") 
		result <- as.POSIXct(strptime(string, "%Y-%m-%d", tz="GMT"))
	} else if (all(nchar(string)==19)) {
		if(tz!="GMT") warning("Unsupported tz handling other than GMT in chr2date") 
		result <- as.POSIXct(strptime(string, "%Y-%m-%d %H:%M:%s", tz="GMT"))
	} else {
		cat("Unimplemented date format in chr2date")
		browser()
	}
	if(any(is.null(result))){
		cat("Invalid Date conversion in chr2date. Entering browser mode\n")
		browser()
	}
	return(result)
}
