sqlstatements <- function(object, term){
	if(term=="now"){
		backend <- class(object@con)
		if(backend=="SQLiteConnection"){
			datestring =  'datetime("now")'
		} else if(backend=="MySQL") {
			datestring = "NOW()"
		} else {
			todo(paste("Implement backend ", backend))
			browser()
		}
	} else if(term=="last_id"){
		backend <- class(object@con)
		if(backend=="SQLiteConnection"){
			datestring =  'last_insert_rowid()'
		} else if(backend=="MySQL") {
			datestring = "SELECT LAST_INSERT_ID()"
		} else {
			todo(paste("Implement backend ", backend))
			browser()
		}
	} else {
			todo(paste("Implement term ", term))
			browser()
	}
	return(datestring)
}

