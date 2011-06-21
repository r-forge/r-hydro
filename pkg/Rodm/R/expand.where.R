expand.where <- function(w.o, var, var.name, exact=TRUE){
	if(exact){
		like = " like "
		perc = ""
	} else {
		like = " like "
		perc = "%"
	}
	if(!is.null(var)){
		if(!is.na(var)){
			w.o$where.clause <- paste(w.o$where.clause, w.o$the.and, var.name, like, '"', perc, var, perc, '"', sep="")
			w.o$the.and <- " AND "
		}
	}
	return(w.o)
}
