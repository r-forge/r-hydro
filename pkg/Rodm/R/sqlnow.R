sqlnow <- function(object){
	backend <- class(object@con)
	if(backend=="SQLiteConnection"){
		datestring =  'datetime("now")'
	} else if(backend=="MySQL") {
		datestring = "NOW()"
	} else {
		todo(paste("Implement backend ", backend))
		browser()
	}
}

