updateCV <- function(){
	def <- processWSDL("http://his.cuahsi.org/ODMCV_1_1/ODMCV_1_1.asmx?WSDL")

	ff <- genSOAPClientInterface(def=def)

	ans <- ff@functions$GetUnits()
	test <-     xmlToList(xmlParse(ans, asText = TRUE))
	sapply(test$Records, function(x){
				if(any(names(x)!="count")){
					addUnits(ID=x$UnitsID, Name=x$UnitsName, Type=x$UnitsType, Abbreviation=x$UnitsAbbreviation)
				}

		})


	ans <- ff@functions$GetSpatialReferences()
	test <-     xmlToList(xmlParse(ans, asText = TRUE))
	sapply(test$Records, function(x){
				if(any(names(x)!="count")){
					if(is.null(x$SRSID)) x$SRSID="NULL"
					if(is.null(x$Notes)) x$Notes=""
					addSpatialReferences(ID=x$SpatialReferenceID, SRSID=x$SRSID, Name=x$SRSName, IsGeographic=as.logical(x$IsGeographic), Notes=x$Notes)
				}

		})

	for(tab in CVtables()){
		command <- paste("ans <- ff@functions$Get", tab, "CV()", sep = "")
		eval(parse(text=command))
		test <- xmlToList(xmlParse(ans, asText = TRUE))
		sapply(test$Records, function(x){
				if(names(x)!="count"){
				  addCV(table=tab, term=x$Term, definition=x$Definition)
				}
			})
	}


}
