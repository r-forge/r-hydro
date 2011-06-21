addCV <- function(table, term, definition){
	stopifnot(length(term)==length(definition))
	for(i in seq(along=term)){
		#check existing
		if(NROW(IgetCV(getOption("odm.handler"), table=table, term=term[i], definition=definition[i]))>0){
			todo("ToDo: Handling of existing entries")
			browser()
		}
		todo("ToDo: Warnign and handling if CV is extended")

		IaddCV(getOption("odm.handler"), table=table, term=term[i], definition=definition[i])
	}
}
