deleteDataValues <- function(ID=NULL,reason=NULL){
	the.class <- class(ID)
	the.id=c()
	if(the.class=="observations"){
		the.id <- ID@ids
	}
	if(the.class=="numeric"){
		the.id <- ID
	}
	if(length(the.id)>0){
		IarchiveDataValues(getOption("odm.handler"),ValueID=the.id, reason)
		IdeleteDataValues(getOption("odm.handler"),ValueID=the.id)
	}

}

