svk <- function(the.vect, tablename, rownum, object){
	if(is.null(the.vect)){
		to.ret <- IgetNo(object, tablename)
	} else if(is.na(the.vect[rownum])){
		to.ret <- IgetNo(object, tablename)
	} else {
		to.ret <-the.vect[rownum]
	}
	return(to.ret)
}


