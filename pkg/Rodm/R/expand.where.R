expand.where <- function(w.o, var, var.name, exact=TRUE){
	if(exact){
		like = " like "
		perc = ""
	} else {
		like = " like "
		perc = "%"
	}
	if(!is.null(var)){
		if(!all(is.na(var))){
			if(length(var>1)){
				orterm <- ""
				theor <- ""
				for(i in seq(along=var)){
					orterm <- paste(orterm, theor, var.name, like, '"', perc, var[i], perc, '"', sep="")
					theor <- " OR "
				}
				w.o$where.clause <- paste(w.o$where.clause, w.o$the.and, " ( ", orterm, ' ) ', sep="")
			} else {
				w.o$where.clause <- paste(w.o$where.clause, w.o$the.and, var.name, like, '"', perc, var, perc, '"', sep="")
			}
			w.o$the.and <- " AND "
		}
	}
	return(w.o)
}
