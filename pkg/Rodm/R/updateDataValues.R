updateDataValues <- function(getDataResult, reason=NULL){
	#Requery the data 
	inDB <- getDataValues(ID=getDataResult$num$ValueID)

	#Find differences based on ID!
	nm <- intersect(names(inDB$num), names(getDataResult$num))
	IDrow <- which(nm=="ValueID")
	inDB.byID <- zoo(coredata(inDB$num[,nm]), order.by = coredata(inDB$num[,nm][,IDrow]))
	getDataResult.byID <- zoo(coredata(getDataResult$num[,nm]),  order.by = coredata(getDataResult$num[,nm][,IDrow]))
	different.num <- inDB.byID != getDataResult.byID

	#find differences in time
	inDB.byID <- zoo(index(inDB$num), order.by = coredata(inDB$num[,nm][,IDrow]))
	getDataResult.byID <- zoo(index(getDataResult$num),  order.by = coredata(getDataResult$num[,nm][,IDrow]))
	timediff <- inDB.byID - getDataResult.byID
	if(any(timediff != 0)){
		todo("Implement changing time in update data")
		browser()
	}



	nnm <- intersect(names(inDB$char), names(getDataResult$char))
	inDB.byID <- zoo(coredata(inDB$char[,nnm]), order.by = coredata(inDB$num[,nm][,IDrow]))
	getDataResult.byID <- zoo(coredata(getDataResult$char[,nnm]),  order.by = coredata(getDataResult$num[,nm][,IDrow]))
	different.char <- inDB.byID != getDataResult.byID
	to.update <- coredata(getDataResult$num[,nm][rowSums(different.num)>0 | rowSums(different.char)>0,IDrow])


	#update the single records
	if(length(to.update)==0){
		warning("Nothing to update")
		return()
	}
	IarchiveDataValues(getOption("odm.handler"),ValueID=to.update, reason)
	for(rec.id in to.update){
		the.row <- which(getDataResult$num[,nm][,IDrow]==rec.id)
		the.tz <- guess.tz(getDataResult$num$UTCOffset[the.row])
		IupdateDataValues(getOption("odm.handler"),ValueID=rec.id, 
				localDateTime=chr2date(getDataResult$char$LocalDateTime[the.row], tz=the.tz),
				value=getDataResult$num$DataValue[the.row],
				valueAccuracy=getDataResult$num$ValueAccuracy[the.row],
				TZ=the.tz,
				SiteID=getDataResult$num$SiteID[the.row],
				VariableID=getDataResult$num$VariableID[the.row],
				Offset=getDataResult$num$OffsetValue[the.row],
				OffsetTypeID=getDataResult$num$OffsetTypeID[the.row],
				CensorCode=getDataResult$char$CensorCode[the.row],
				QualifierID=getDataResult$num$QualifierID[the.row],
				MethodID=getDataResult$num$MethodID[the.row],
				SourceID=getDataResult$num$SourceID[the.row],
				SampleID=getDataResult$num$SampleID[the.row],
				DerivedFromID=getDataResult$num$DerivedFromID[the.row],
				QualityControlLevelID=getDataResult$num$QualityControlLevelID[the.row])

	}
}
