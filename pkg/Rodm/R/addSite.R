addSite <- function(Code, Name, x, y, Elevation=NULL, LatLongDatum, LocalProjection=NULL, isLocal=NULL, VerticalDatum=NULL,PositionAccuracy=NULL, State=NULL, County=NULL, Comment=NULL){
	#mandatory fields: Code, Name, Lat, Long, LatLongDatum

	#check from referencetables: SpatialReferences -> LatLongDatum, LocalProjection
	stopifnot(length(LatLongDatum) == length(Code))
	SpatialReferenceID <- getID("SpatialReferences", LatLongDatum)


	if(!is.null(LocalProjection)){
		stopifnot(length(LocalProjection) == length(Code))
		SpatialReferenceID2 <- getID("SpatialReferences", LocalProjection)
	} else {
		#ToDo
		SpatialReferenceID2 <- rep(1, length(Code))
	}

	#check from referencetables: VerticalDatum
	if(!is.null(VerticalDatum)){
		stopifnot(length(VerticalDatum) == length(Code))
		VertDatID <- getID("VerticalDatum",VerticalDatum)
	} else {
		VertDatID <- rep(NA, length(Code))
	}
	#check for existing entries
	todo("ToDo check for existing locations")
	#transform coordinates
	#depending on value of isLocal
	todo("ToDo automatic coordinate conversion")

	IaddSite(getOption("odm.handler"),Code = Code, Name =Name, Latitude=x, Longitude=y, Elevation=Elevation, LatLongDatum=SpatialReferenceID, LocalProjection=SpatialReferenceID2, VerticalDatum=VertDatID,PosAccuracy=PositionAccuracy, State=State, County=County, Comment=Comment)


}
