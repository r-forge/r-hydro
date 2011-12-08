getMetadata <- function(table, ...){
	#check for valid table name
	table.list <- c(CVtables(), "SpatialReferences", "Site", "Methods","Qualifiers","QualityControlLevels","Samples","Source","Variable","OffsetTypes","Units","ISOMetadata")
	if(!table %in% table.list){
		stop("Undefined table ", table, " Valid values are: ", paste(table.list, collapse=", "))
	}

	#query data
	entry <- NULL
	command <- paste('entry <- Iget',table,'(options("odm.handler")[[1]], ... )', sep='')
	eval(parse(text=command))
	return(entry)

}
