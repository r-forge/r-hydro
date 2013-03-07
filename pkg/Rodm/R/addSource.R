addSource <- function(Organization, SourceDescription, SourceLink=NULL, ContactName="Unknown", Phone="Unknown", Email="Unknown", Address="Unknown", City="Unknown", State="Unknown", ZipCode="Unknown", Citation="Unknown", Metadata="Unknown"){
	#optional: SourceLink

	#checking for existing entries 
	print("checking for multiple columns in getMetadata seems not to work. Debug for worldbank function to work correctly")
	browser()
	if(NROW(existing <- getMetadata("Source",Organization=Organization, SourceDescription=SourceDescription, SourceLink=SourceLink))>0){
		warning(paste("Existing ISOMetadata entry:", SourceDescription, " -- Skiping all imports.!"))
		return()
	}

	#check from referencetable
	if(!is.null(Metadata)){
		stopifnot(length(Metadata) == length(SourceDescription))
		MetadataID <- getID("ISOMetadata",Metadata)
	} else {
		MetadataID <- rep(NA, length(SourceDescription))
	}

	IaddSource(getOption("odm.handler"), Organization=Organization, SourceDescription= SourceDescription, SourceLink= SourceLink, ContactName= ContactName, Phone= Phone, Email= Email, Address= Address, City= City, State= State, ZipCode= ZipCode, Citation= Citation, Metadata=MetadataID)

}
