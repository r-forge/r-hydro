getDataValues <- function(ID=NULL, from=NULL, to=NULL, SiteID=NULL, VariableID=NULL, Offset=NULL, OffsetTypeID=NULL, CensorCode=NULL, QualifierID=NULL, MethodID=NULL, SourceID=NULL, SampleID=NULL, DerivedFromID=NULL, QualityControlLevelID=NULL, VersionID=NULL, VersionDate=NULL,show.deleted=FALSE ){

	all.args <- list(SiteID=SiteID, VariableID=VariableID, Offset=Offset, OffsetTypeID=OffsetTypeID, CensorCode=CensorCode, QualifierID=QualifierID, MethodID=MethodID, SourceID=SourceID, SampleID=SampleID, DerivedFromID=DerivedFromID, QualityControlLevelID=QualityControlLevelID, VersionID=VersionID, VersionDate=VersionDate)
	#check if only single constraints are used -> necessary
	# because we need to expand it in addDataValues
	# in order to provide smart treatment of meta data
	count.unique <- sapply(all.args, function(x) length(unique(x)))
	if(all(count.unique <= 1)){
		the.unique <- sapply(all.args, function(x) unique(x))
		for(i in seq(along=the.unique)){
			if(!is.null(the.unique[[i]])){
				assign(names(the.unique)[i], value=the.unique[[i]])
			}
		}
	} else if(sum(count.unique > 1)==1) {
		the.long <- which(count.unique > 1)
		for(i in seq(along=all.args)[-the.long]){
			the.unique <- unique(all.args[[i]])
			if(!is.null(the.unique)){
				assign(names(all.args)[i], value=the.unique)
			}
		}
	} else {
		todo("Smart processing of multiple arguments is missing")
		browser()
	}



	# Datensätze mit grösster VersionsID und mit ValidUntilID <= aktuell verlangter Version existieren
	old.entry <- NULL
	if(!is.null(VersionDate)){
		if(!is.null(VersionID)){
			stop("Not possible to use both VersionID and VersionDate")
		}
		todo("implement VersionDate")
		
	}
	if(!is.null(VersionID)){
		old.entry <- restructureDataResult(IgetOldDataValues(options("odm.handler")[[1]], ID=as.numeric(ID), from=from, to=to, SiteID=SiteID, VariableID=VariableID, Offset=Offset, OffsetTypeID=OffsetTypeID, CensorCode=CensorCode, QualifierID=QualifierID, MethodID=MethodID, SourceID=SourceID, SampleID=SampleID, DerivedFromID=DerivedFromID, QualityControlLevelID=QualityControlLevelID, VersionID))
	}
	if(show.deleted){
		deleted.entry <- restructureDataResult(IgetDeletedDataValues(options("odm.handler")[[1]], ID=as.numeric(ID), from=from, to=to, SiteID=SiteID, VariableID=VariableID, Offset=Offset, OffsetTypeID=OffsetTypeID, CensorCode=CensorCode, QualifierID=QualifierID, MethodID=MethodID, SourceID=SourceID, SampleID=SampleID, DerivedFromID=DerivedFromID, QualityControlLevelID=QualityControlLevelID))
		#merge with old
		if(!is.null(deleted.entry)){
			if(!is.null(old.entry)){
				old.entry <- merge(old.entry, deleted.entry)
			} else {
				old.entry <-  deleted.entry
			}
		}
	}

	# Datensätze aus aktueller Tabelle abholen
	entry <- restructureDataResult(IgetDataValues(options("odm.handler")[[1]], ID=as.numeric(ID), from=from, to=to, SiteID=SiteID, VariableID=VariableID, Offset=Offset, OffsetTypeID=OffsetTypeID, CensorCode=CensorCode, QualifierID=QualifierID, MethodID=MethodID, SourceID=SourceID, SampleID=SampleID, DerivedFromID=DerivedFromID, QualityControlLevelID=QualityControlLevelID))

	# neuere Datensätze durch alte Versionen ersetzen, zusätzliche Datensätze anhängen
	if(!is.null(old.entry)){
		replace.by.old.data <- entry@ids %in% old.entry@ids
		version.col <- which(colnames(old.entry@attributes) == "VersionID")
		entry <- merge(entry[!replace.by.old.data], old.entry)
	}

				
	return(entry)

}

