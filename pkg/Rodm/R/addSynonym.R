addSynonym <- function(table, phrase, id){
	if(length(answer <- IgetSynonymID(getOption("odm.handler"), table=table, phrase=phrase))>0) return(answer)
	id  <- getID(table, id, remove.special.character=FALSE)
	IaddSynonym(getOption("odm.handler"), table=table, phrase=phrase, id=id)
	return(id)
}
