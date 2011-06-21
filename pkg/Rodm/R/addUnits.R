addUnits <- function(ID, Name, Type, Abbreviation){
	stopifnot(length(ID)==length(Name))
	stopifnot(length(ID)==length(Type))
	stopifnot(length(ID)==length(Abbreviation))
	for(i in seq(along=ID)){
		#check existing
		if(NROW(IgetUnits(getOption("odm.handler"), ID=ID[i], Name=Name[i], Type=Type[i], Abbreviation=Abbreviation[i]))>0){
			todo("Handling of existing entries")
			browser()
		}
		IaddUnits(getOption("odm.handler"), ID=ID[i], Name=Name[i], Type=Type[i], Abbreviation=Abbreviation[i])
	}
}
