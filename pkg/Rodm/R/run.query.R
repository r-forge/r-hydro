run.query <- function(object, query){
	if(getOption("verbose.queries", default=FALSE)) print(query)
	IdbState(object)
	res <- dbGetQuery(object@con, query)
	return(res)
}
