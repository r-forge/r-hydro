sv <- function(the.vect, rownum=1){ #select variable
	if(is.null(the.vect)){
		to.ret <- "NULL" 
	} else if(is.na(the.vect[rownum])){
		to.ret <- "NULL" 
	} else {
		to.ret <- the.vect[rownum]
	}
	return(to.ret)
}

