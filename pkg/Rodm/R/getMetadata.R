getMetadata <- function(table, ...){
	#check for valid table name
	table.list <- c(CVtables(), "SpatialReference", "Site", "Methods","Qualifiers","QualityControlLevels","Samples","Source","Variable","OffsetTypes","Units","ISOMetadata")
	if(!table %in% table.list){
		stop("Undefined table", table, "Valid values are:", table.list)
	}

	#query data
	entry <- NULL
	command <- paste('entry <- Iget',table,'(options("odm.handler")[[1]], ... )', sep='')
	eval(parse(text=command))
	return(entry)

}
