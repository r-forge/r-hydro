addSpatialReferences <- function(ID, SRSID, Name, IsGeographic, Notes){
	stopifnot(length(ID)==length(Name))
	stopifnot(length(ID)==length(SRSID))
	stopifnot(length(ID)==length(Notes))
	stopifnot(length(ID)==length(IsGeographic))
	stopifnot(is.logical(IsGeographic))
	for(i in seq(along=ID)){
		#check existing
		if(NROW(IgetSpatialReferences(getOption("odm.handler"), ID=ID[i], SRSName=Name[i], SRSID=SRSID[i], IsGeographic=IsGeographic, Notes=Notes[i]))>0){
			warning(paste("Skiping existing entry:", Name[i]))
			return()
		}
		IaddSpatialReferences(getOption("odm.handler"), ID=ID[i], SRSName=Name[i], SRSID=SRSID[i], IsGeographic=IsGeographic, Notes=Notes[i])
	}
}
