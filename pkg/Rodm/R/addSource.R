addSource <- function(Organization, SourceDescription, SourceLink=NULL, ContactName="Unknown", Phone="Unknown", Email="Unknown", Address="Unknown", City="Unknown", State="Unknown", ZipCode="Unknown", Citation="Unknown", Metadata="Unknown"){
	#optional: SourceLink

	#check from referencetable
	if(!is.null(Metadata)){
		stopifnot(length(Metadata) == length(SourceDescription))
		MetadataID <- getID("ISOMetadata",Metadata)
	} else {
		MetadataID <- rep(NA, length(SourceDescription))
	}
	#checking for existing entries doesnt make much sense because matching
	#SourceDescritpion will not work as they probably differ
	IaddSource(getOption("odm.handler"), Organization=Organization, SourceDescription= SourceDescription, SourceLink= SourceLink, ContactName= ContactName, Phone= Phone, Email= Email, Address= Address, City= City, State= State, ZipCode= ZipCode, Citation= Citation, Metadata=MetadataID)

}
