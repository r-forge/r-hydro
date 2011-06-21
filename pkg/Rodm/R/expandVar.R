expandVar <- function(var, nrow, ncol, checkID=FALSE, table=NULL){
	if(checkID){
		stopifnot(!is.null(table))
		theID  <- getID(table,var)
	} else {
		theID <- var
	}
	nrow.var <- NROW(theID)
	ncol.var <- NCOL(theID)
	#Same dimensions are required as were passed
	if(nrow.var == nrow & ncol.var == ncol){
		#make certain theID is an matrix
                dim(theID) <- c(nrow,ncol)
		return(theID)
	}

	#Different dimensions are required then  were passed
	if(nrow==ncol) warning("Number of columns and rows equivalent: unclear how to expand data! Assuming columns to match")

	if(ncol.var == 1 & nrow.var==1){
		return(matrix(theID, ncol=ncol, nrow=nrow))
	} else if(ncol==ncol.var){
		
		cat("ncol==ncol.var. Please impement\n")
		browser()
	} else if(nrow==nrow.var){
		cat("nrow==nrow.var. Please impement\n")
		browser()
	} else {
		cat("Unexpected expansion of variable. Please impement\n")
		browser()
	}
	stop("Should not be here")

}
