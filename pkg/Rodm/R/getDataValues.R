getDataValues <- function(ID=NULL, from=NULL, to=NULL, SiteID=NULL, VariableID=NULL, Offset=NULL, OffsetTypeID=NULL, CensorCode=NULL, QualifierID=NULL, MethodID=NULL, SourceID=NULL, SampleID=NULL, DerivedFromID=NULL, QualityControlLevelID=NULL, VersionID=NULL, VersionDate=NULL, ... ){

	# Datensätze mit grösster VersionsID und mit ValidUntilID <= aktuell verlangter Version existieren
	old.entry <- NULL
	if(!is.null(VersionDate)){
		if(!is.null(VersionID)){
			stop("Not possible to use both VersionID and VersionDate")
		}
		todo("implement VersionDate")
		
	}
	if(!is.null(VersionID)){
		old.entry <- IgetOldDataValues(options("odm.handler")[[1]], ID=ID, from=from, to=to, SiteID=SiteID, VariableID=VariableID, Offset=Offset, OffsetTypeID=OffsetTypeID, CensorCode=CensorCode, QualifierID=QualifierID, MethodID=MethodID, SourceID=SourceID, SampleID=SampleID, DerivedFromID=DerivedFromID, QualityControlLevelID=QualityControlLevelID, VersionID)
	}

	# Datensätze aus aktueller Tabelle abholen
	entry <- IgetDataValues(options("odm.handler")[[1]], ID=ID, from=from, to=to, SiteID=SiteID, VariableID=VariableID, Offset=Offset, OffsetTypeID=OffsetTypeID, CensorCode=CensorCode, QualifierID=QualifierID, MethodID=MethodID, SourceID=SourceID, SampleID=SampleID, DerivedFromID=DerivedFromID, QualityControlLevelID=QualityControlLevelID)

	# neuere Datensätze durch alte Versionen ersetzen, zusätzliche Datensätze anhängen
	if(!is.null(old.entry)){
		replace.by.old.data <- entry$num$ValueID %in% old.entry$num$ValueID
		version.col <- which(colnames(old.entry$num) == "VersionID")
		new.data <- list(num=rbind(entry$num[!replace.by.old.data,], old.entry$num[,-version.col]), char=rbind(entry$char[!replace.by.old.data,], old.entry$char))
		entry <- new.data


	}

				
	return(entry)

#print("ToDo: Implement smart building of multi column zoo objects")
#the.series <- unique(to.ret[,c("SiteID", "VariableID")])
				#browser()
				#for(series in seq(along=the.series)){
				#	part <- subset(to.ret, SiteID==the.series[series,"SiteID"] &VariableID==the.series[series,"VariableID"] )
				#}
}

