addOffsetType <- function(Units, Description){
	#all mandatory
	stopifnot(length(Units) == length(Description))

	#check ref: Units
	UnitsID <- getID("Units",Units)
	if(NROW(existing <- getMetadata("OffsetType",Description=Description, Units = UnitsID))>0){
		warning(paste("Existing OffsetType entry:", Description, ", Skipping all imports"))
		return()
	}
	IaddOffsetType(getOption("odm.handler"), Description=Description, Units=UnitsID)
}
