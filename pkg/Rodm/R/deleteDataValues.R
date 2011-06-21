deleteDataValues <- function(getDataResult=NULL, ID=NULL,reason=NULL){
	the.id <- c()
	if(!is.null(getDataResult)){
		the.id <- getDataResult$num$ValueID
	}
	if(!is.null(ID)){
		the.id <- ID
	}
	if(length(the.id)>0){
		IarchiveDataValues(getOption("odm.handler"),ValueID=the.id, reason)
		IdeleteDataValues(getOption("odm.handler"),ValueID=the.id)

	}

}

