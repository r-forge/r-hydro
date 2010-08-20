get.names <- function(object){
	fixed <- c("pm","performance","Qsim","Qobs")
	sym <- unique(merge(object@metadata, rhydro.data.types, by.x="name", by.y="data.type")[,c("symbol","origin","run.ID")])
	sym$or <- "sim"
	sym$or[sym$origin=="measured"] <- "obs"
	
	sym.a <- unique(sym$symbol)
	sym.b <- unique(paste(sym$symbol, sym$or,sep="."))
	sym.c <- unique(paste(sym$symbol, sym$or, sym$run.ID,sep="."))
	return(c(fixed,sym.a,sym.b,sym.c))
}
