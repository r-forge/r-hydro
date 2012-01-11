addUnits <- function(ID, Name, Type, Abbreviation){
	stopifnot(length(ID)==length(Name))
	stopifnot(length(ID)==length(Type))
	stopifnot(length(ID)==length(Abbreviation))
	for(i in seq(along=ID)){
		#check existing
		if(NROW(IgetUnits(getOption("odm.handler"), Name=Name[i], Type=Type[i], Abbreviation=Abbreviation[i]))>0){
			warning(paste("Skiping existing entry:", Name[i]))
			return()
		}
		warning(paste("Extending Units table which should not be necessary. Please propose new term to CUASHI at http://his.cuahsi.org/mastercvreg/", sep=""))
		IaddUnits(getOption("odm.handler"), ID=ID[i], Name=Name[i], Type=Type[i], Abbreviation=Abbreviation[i])
	}
}
