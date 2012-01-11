addISOMetadata <- function(TopicCategory="Unknown", Title="Unknown", Abstract="Unknown", ProfileVersion="Unknown", MetadataLink=NULL){
	#check from referencetable
	if(!is.null(TopicCategory)){
		stopifnot(length(TopicCategory) == length(Title))
		TheTopicCategory <- getID("TopicCategory",TopicCategory)
	} else {
		TheTopicCategory <- rep(NA, length(Title))
	}
	if(NROW(existing <- getMetadata("ISOMetadata",TopicCategory=TopicCategory, Title=Title))>0){
		warning(paste("Skiping existing ISOMetadata entry:", Title))
		return()
	}
	todo("ToDo check for existing locations")
	IaddISOMetadata(getOption("odm.handler"), TopicCategory=TheTopicCategory, Title= Title, Abstract= Abstract, ProfileVersion= ProfileVersion, MetadataLink= MetadataLink)

}
