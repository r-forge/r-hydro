updateDataValues <- function(getDataResult, reason=NULL){
	#Requery the data 
	stopifnot(class(getDataResult)=="observations")
	inDB <- getDataValues(ID=as.numeric(getDataResult@ids))

	#Find differences based on ID!
	comp <- getDataResult == inDB
	details <- attributes(comp)
	if(any(!(names(details) %in% c("values", "dim")))){
		todo("Implement updating if anything besides values is different")
		browser()
		stop("Unimplemented")
	}


	#update the single records
	if(all(comp)){
		warning("Nothing to update")
		return()
	}
	to.update <- coredata(getDataResult@ids)[!comp]
	IarchiveDataValues(getOption("odm.handler"),ValueID=to.update, reason)
	for(rec.id in to.update){
		the.row <- which(getDataResult@ids==rec.id)
		#make sure that ID is processed correctly in Iupdate if it is NA
		the.tz <- guess.tz(getDataResult[the.row]@attributes$UTCOffset)
		obj <- getOption("odm.handler")
		IupdateDataValues(obj,ValueID=rec.id, 
				#localDateTime=chr2date(index(getDataResult[the.row]@values), tz=the.tz),
				localDateTime=index(getDataResult[the.row]@values),
				value=sv(coredata(getDataResult[the.row]@values)),
				valueAccuracy=sv(getDataResult[the.row]@attributes$ValueAccuracy),
				TZ=the.tz,
				SiteID=getID("Site", getDataResult[the.row]@attributes$Site),
				VariableID=getID("Variable",getDataResult[the.row]@attributes$Variable),
				Offset=getDataResult[the.row]@attributes$OffsetValue,
				OffsetTypeID=getID("OffsetType",getDataResult[the.row]@attributes$OffsetType),
				CensorCode=sv(getDataResult[the.row]@attributes$CensorCode),
				QualifierID=getID("Qualifier",getDataResult[the.row]@attributes$Qualifier),
				MethodID=getID("Method",getDataResult[the.row]@attributes$Method),
				SourceID=getID("Source",getDataResult[the.row]@attributes$Source),
				SampleID=getID("Sample",getDataResult[the.row]@attributes$Sample),
				DerivedFromID= sv(coredata(getDataResult[the.row]@derivedFrom)),
				QualityControlLevelID=getID("QualityControlLevel",getDataResult[the.row]@attributes$QualityControlLevel))

	}
}
