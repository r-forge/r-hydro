reload <- function(){
	try(detach("package:RODM"))
	ll = getOption("lib.loc", default=NULL)
	ll.string <- ""
	if(!is.null(ll)) ll.string <- paste("-l", ll)
	system(paste("R CMD INSTALL",ll.string," RODM"))
	library(RODM, lib.loc=ll)
}
