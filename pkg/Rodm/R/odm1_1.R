setClass("odm1_1",
	representation= representation(con = "DBIConnection")
	)
setClass("odm1_1Ver", contains="odm1_1"	)


setGeneric("IdbState", function(object) {standardGeneric("IdbState")})
setGeneric("IgetSite", function(object, ID=NULL, Code=NULL, Name=NULL, x=NULL, y=NULL, Elevation=NULL, LatLongDatum=NULL, exact=FALSE ) { standardGeneric("IgetSite")}) 
setGeneric("IgetUnits", function(object, ID=NULL, Name=NULL, Type=NULL, Abbreviation=NULL, exact=FALSE ) { standardGeneric("IgetUnits")}) 
setGeneric("IaddUnits", function(object, ID, Name, Type, Abbreviation ) { standardGeneric("IaddUnits")}) 
setGeneric("IgetVariable", function(object, ID=NULL, Code=NULL, Name=NULL, Speciation=NULL, Unit=NULL, Medium=NULL,exact=FALSE, ...  ) { standardGeneric("IgetVariable")}) 
setGeneric("IgetQualifier", function(object, ID=NULL, Code=NULL, Description=NULL, ...  ) { standardGeneric("IgetQualifier")}) 
setGeneric("IgetMethod", function(object, ID=NULL, Description=NULL, ...  ) { standardGeneric("IgetMethod")}) 
setGeneric("IgetOffsetType", function(object, ID=NULL, Description=NULL, Units=NULL, ...  ) { standardGeneric("IgetOffsetType")}) 
setGeneric("IgetSample", function(object, ID=NULL, LabSampleCode=NULL, ...  ) { standardGeneric("IgetSample")}) 
setGeneric("IgetSource", function(object, ID=NULL, Organization=NULL, Description=NULL, Citation=NULL, ...  ) { standardGeneric("IgetSource")}) 
setGeneric("IgetISOMetadata", function(object, ID=NULL, Title=NULL, Abstract=NULL, TopicCategory=NULL, ...  ) { standardGeneric("IgetISOMetadata")}) 
setGeneric("IgetQualityControlLevel", function(object, ID=NULL, Code=NULL, Definition=NULL, Explanation=NULL, ...  ) { standardGeneric("IgetQualityControlLevel")}) 

for(i in CVtables()){
	code <- paste('setGeneric("Iget',i,'", function(object, Term=NULL,  Definition=NULL, exact=FALSE, ...  ) { standardGeneric("Iget',i,'")})', sep="")
	eval(parse(text=code))
}
for(i in CVtables()){
	code <- paste('setMethod("Iget',i,'", signature(object = "odm1_1"), function(object,  Term=NULL,  Definition=NULL, exact=FALSE, ...){ return(IgetCV(object, "',i,'", Term, Definition, exact=exact)) })', sep="")
	eval(parse(text=code))
}
for(i in CVtables()){
	code <- paste('setMethod("Iget',i,'", signature(object = "NULL"), h.m)', sep="")
	eval(parse(text=code))
}

 
setGeneric("IgetDataValues", function(object,ID=NULL, from=NULL, to=NULL, SiteID=NULL, VariableID=NULL, Offset=NULL, OffsetTypeID=NULL, CensorCode=NULL, QualifierID=NULL, MethodID=NULL, SourceID=NULL, SampleID=NULL, DerivedFromID=NULL, QualityControlLevelID=NULL, ...  ) { standardGeneric("IgetDataValues")}) 
setGeneric("IgetSpatialReference", function(object,ID=NULL, SRSID=NULL, SRSName=NULL, IsGeographic=NULL, Notes=NULL, exact=FALSE) { standardGeneric("IgetSpatialReference")}) 
setGeneric("IgetOldDataValues", function(object,ID=NULL, from=NULL, to=NULL, SiteID=NULL, VariableID=NULL, Offset=NULL, OffsetTypeID=NULL, CensorCode=NULL, QualifierID=NULL, MethodID=NULL, SourceID=NULL, SampleID=NULL, DerivedFromID=NULL, QualityControlLevelID=NULL, VersionID, exact,...  ) { standardGeneric("IgetOldDataValues")}) 
setGeneric("IaddDataValues", function(object, localDateTime, values, TZ, SiteID, VariableID, Offset=NULL, OffsetTypeID=NULL, CensorCode, QualifierID=NULL, MethodID, SourceID, SampleID=NULL, DerivedFromID=NULL, QualityControlLevelID, exact, ...  ) { standardGeneric("IaddDataValues")}) 
setGeneric("IaddSite", function(object, Code, Name, Latitude, Longitude, LatLongDatum, Elevation=NULL, VerticalDatum=NULL, LocalX=NULL,LocalY=NULL, LocalProjection=NULL, PosAccuracy=NULL, State=NULL, County=NULL, Comments=NULL) {standardGeneric("IaddSite")})
setGeneric("IaddVariable", function(object, Code, Name, Speciation, Unit, SampleMedium,ValueType, IsRegular, TimeSupport, TimeUnits, DataType, GeneralCategory, NoDataValue) {standardGeneric("IaddVariable")})
setGeneric("IaddSource", function(object, Organization, SourceDescription, SourceLink, ContactName, Phone, Email, Address, City, State, ZipCode, Citation, Metadata) {standardGeneric("IaddSource")})
setGeneric("IaddISOMetadata", function(object, TopicCategory, Title, Abstract, ProfileVersion, MetadataLink) {standardGeneric("IaddISOMetadata")})
setGeneric("IupdateDataValues", function(object, ValueID, localDateTime, value, TZ, SiteID, VariableID, Offset=NULL, OffsetTypeID=NULL, CensorCode, QualifierID=NULL, MethodID, SourceID, SampleID=NULL, DerivedFromID=NULL, QualityControlLevelID, ...  ) { standardGeneric("IupdateDataValues")}) 
setGeneric("IdeleteDataValues", function(object, ValueID) { standardGeneric("IdeleteDataValues")}) 
setGeneric("IarchiveDataValues", function(object, ValueID,reason) { standardGeneric("IarchiveDataValues")}) 
setGeneric("IaddDataVersion", function(object, reason) { standardGeneric("IaddDataVersion")}) 
setGeneric("IgetCurrentDataVersion", function(object) { standardGeneric("IgetCurrentDataVersion")}) 
setGeneric("IgetDataVersions", function(object) { standardGeneric("IgetDataVersions")}) 
setGeneric("IaddCV", function(object, table, term, definition){standardGeneric("IaddCV")})
setGeneric("IgetCV", function(object, table, term, definition, exact=FALSE){standardGeneric("IgetCV")})
setGeneric("IaddSynonym", function(object, phrase, table, id){standardGeneric("IaddSynonym")})
setGeneric("IgetSynonymID", function(object, phrase, table){standardGeneric("IgetSynonymID")})

#setGeneric("IgetNoOffsetType", function(object) {standardGeneric("IgetNoOffsetType")})
#setGeneric("IgetNoVerticalDatum", function(object) {standardGeneric("IgetNoVerticalDatum")})
#setGeneric("IgetNoSpatialReferenceID", function(object) {standardGeneric("IgetNoSpatialReferenceID")})
#setGeneric("IgetNoQualifier", function(object) {standardGeneric("IgetNoQualifier")})
#setGeneric("IgetNoSample", function(object) {standardGeneric("IgetNoSample")})
setGeneric("IgetNo", function(object, table) {standardGeneric("IgetNo")})

#copy set generic from above
# mark and replace with
# '<,'>s/setGeneric/setMethod/g
# :'<,'>s/,.*/, signature(object = NULL), h.m)   

setMethod("IgetCV", signature(object = "NULL"), h.m)
setMethod("IdbState", signature(object = "NULL"), h.m)
setMethod("IaddCV", signature(object = "NULL"), h.m)
setMethod("IgetSite", signature(object = "NULL"), h.m)
setMethod("IgetUnits", signature(object = "NULL"), h.m)
setMethod("IaddUnits", signature(object = "NULL"), h.m)
setMethod("IgetVariable", signature(object = "NULL"), h.m)
setMethod("IgetQualifier", signature(object = "NULL"), h.m)
setMethod("IgetMethod", signature(object = "NULL"), h.m)
setMethod("IgetOffsetType", signature(object = "NULL"), h.m)
setMethod("IgetSample", signature(object = "NULL"), h.m)
setMethod("IgetSource", signature(object = "NULL"), h.m)
setMethod("IgetISOMetadata", signature(object = "NULL"), h.m)
setMethod("IgetQualityControlLevel", signature(object = "NULL"), h.m)
setMethod("IgetCensorCode", signature(object = "NULL"), h.m)
setMethod("IgetDataValues", signature(object = "NULL"), h.m)
setMethod("IgetSpatialReference", signature(object = "NULL"), h.m)
setMethod("IgetOldDataValues", signature(object = "NULL"), h.m)
setMethod("IaddDataValues", signature(object = "NULL"), h.m)
setMethod("IaddSite", signature(object = "NULL"), h.m)
setMethod("IaddVariable", signature(object = "NULL"), h.m)
setMethod("IupdateDataValues", signature(object = "NULL"), h.m)
setMethod("IdeleteDataValues", signature(object = "NULL"), h.m)
setMethod("IarchiveDataValues", signature(object = "NULL"), h.m)
setMethod("IaddDataVersion", signature(object = "NULL"), h.m)
setMethod("IgetCurrentDataVersion", signature(object = "NULL"), h.m)
setMethod("IgetDataVersions", signature(object = "NULL"), h.m)
setMethod("IgetNo", signature(object = "NULL"), h.m)
setMethod("IaddSource", signature(object = "NULL"), h.m)
setMethod("IaddISOMetadata", signature(object = "NULL"), h.m)

check.version <- function(object, version){
		if(dbExistsTable(object@con, "ODMVersion")){
			query = "SELECT * FROM ODMVersion"
		        if(getOption("verbose.queries", default=FALSE)) print(query)
			res <- dbGetQuery(object@con, query)
			if(res$VersionNumber!=version){
				stop("Invalid Database version. Expected ",version,", obtained ",res$VersionNumber)
			}
		} else {
			warning("Creating database structure")
			run.sql.script(object@con, system.file("odm1_1_raw.sql", package="RODM"))
			if(version=="1.1Ver"){
			     run.sql.script(object@con, system.file("odm1_1_addVersion.sql", package="RODM"))
			}
		}
		if(!dbExistsTable(object@con, "Synonyms")){
			warning("Creating synonym table")
			query = "CREATE TABLE Synonyms (phrase TEXT, RecID NUMERIC, tab TEXT)"
		        if(getOption("verbose.queries", default=FALSE)) print(query)
			dbGetQuery(object@con, query)
		}
}
 
setMethod("IdbState", signature(object = "odm1_1"), 
	function(object){
		check.version(object, "1.1")
	}
)
setMethod("IdbState", signature(object = "odm1_1Ver"), 
	function(object){
		check.version(object, "1.1Ver")
	}
)
setMethod("IgetISOMetadata", 
		signature(object = "odm1_1"),
		function(object,  ID=NULL, Title=NULL, Abstract=NULL, TopicCategory=NULL, exact=FALSE){
		  	w.o <- list(where.clause = "", the.and  = "")
			w.o <- expand.where(w.o, ID, "MetadataID", exact=TRUE)
			w.o <- expand.where(w.o, Title, "Title", exact=exact)
			w.o <- expand.where(w.o, Abstract, "Abstract", exact=exact)
			w.o <- expand.where(w.o, TopicCategory, "TopicCategory", exact=TRUE)

			where.clause <- w.o$where.clause
			if(where.clause!="") where.clause <- paste(" WHERE ", where.clause)

			query <- paste("SELECT * FROM ISOMetadata", where.clause)
			res <- run.query(object, query )
			#ToDo: Define standard return values and order
			if(NROW(res)>0) {names(res)[1] <- c("ID")}
			return(res)
		}
	)


setMethod("IgetUnits", 
		signature(object = "odm1_1"),
		function(object,  ID=NULL, Name=NULL, Type=NULL, Abbreviation=NULL, exact=FALSE){
		  	w.o <- list(where.clause = "", the.and  = "")
			w.o <- expand.where(w.o, ID, "UnitsID", exact=TRUE)
			w.o <- expand.where(w.o, Name, "UnitsName", exact=exact)
			w.o <- expand.where(w.o, Type, "UnitsType", exact=exact)
			w.o <- expand.where(w.o, Abbreviation, "UnitsAbbreviation", exact=exact)

			where.clause <- w.o$where.clause
			if(where.clause!="") where.clause <- paste(" WHERE ", where.clause)

			query <- paste("SELECT * FROM Units", where.clause)
			res <- run.query(object, query )
			#ToDo: Define standard return values and order
			if(NROW(res)>0) {names(res)[1:4] <- c("ID", "Name", "Type", "Abbreviation")}
			return(res)
		}
	)


setMethod("IgetSite", 
		signature(object = "odm1_1"),
		function(object,  ID=NULL, Code=NULL, Name=NULL, x=NULL, y=NULL, Elevation=NULL, LatLongDatum=NULL, exact=FALSE){
			#the where.object is used to assemble the where clause
		  	w.o <- list(where.clause = "", the.and  = "")
			w.o <- expand.where(w.o, ID, "SiteID", exact=TRUE)
			w.o <- expand.where(w.o, Code, "SiteCode", exact=exact)
			w.o <- expand.where(w.o, Name, "SiteName", exact=exact)

			if(!is.null(x)){
				stop("ToDo: Implement getSite für x")
			}
			if(!is.null(y)){
				stop("ToDo: Implement getSite für y")
			}
			if(!is.null(LatLongDatum)){
				stop("ToDo: Implement getSite für LatLongDatum")
			}
			if(!is.null(Elevation)){
				stop("ToDo: Implement getSite für Elevation")
			}

			where.clause <- w.o$where.clause
			if(where.clause!="") where.clause <- paste(" WHERE ", where.clause)

			query <- paste("SELECT * FROM Sites ", where.clause)
			res <- run.query(object, query )
			#ToDo: Define standard return values and order
			if(NROW(res)>0) {names(res)[1:3] <- c("ID", "Code", "Name")}
			return(res)
		}
	)


setMethod("IgetVariable", 
		signature(object = "odm1_1"),
		function(object, ID=NULL, Code=NULL, Name=NULL, Speciation=NULL, Unit=NULL, Medium=NULL, exact=FALSE, ... ){
		  	w.o <- list(where.clause = "", the.and  = "")
			w.o <- expand.where(w.o, ID, "VariableID", exact=TRUE)
			w.o <- expand.where(w.o, Code, "VariableCode", exact=exact)
			w.o <- expand.where(w.o, Name, "VariableName", exact=exact)
			if(!is.null(Speciation)){
				stop("ToDo: Implement getVariable für Speciation")
			}
			if(!is.null(Unit)){
				stop("ToDo: Implement getVariable für Unit")
			}
			if(!is.null(Medium)){
				stop("ToDo: Implement getVariable für Medium")
			}
			where.clause <- w.o$where.clause
			if(where.clause!="") where.clause <- paste(" WHERE ", where.clause)

			query <- paste("SELECT * FROM Variables ", where.clause)
			res <- run.query(object, query )
			#ToDo: Define standard return values and order
			if(NROW(res)>0) {names(res)[1:3] <- c("ID", "Code", "Name")}
			return(res)
		}
	)
setMethod("IgetQualifier", 
		signature(object = "odm1_1"),
		function(object,  ID=NULL, Code=NULL, Description=NULL, ...){
			where.clause <- ""
			the.and  <- ""
			if(!is.null(ID)){
				where.clause <- paste(where.clause, the.and, "QualifierID like '%", ID, "%'", sep="")
				the.and <- " AND "
			}
			if(!is.null(Code)){
				where.clause <- paste(where.clause, the.and, "QualifierCode like '%", Code, "%'", sep="")
				the.and <- " AND "
			}
			if(!is.null(Description)){
				where.clause <- paste(where.clause, the.and, "QualifierDescription like '%", Description, "%'", sep="")
				the.and <- " AND "
			}
			query <- paste("SELECT * FROM Qualifiers WHERE ", where.clause)
			res <- run.query(object, query )
			#ToDo: Define standard return values and order
			if(NROW(res)>0) {names(res)[1:3] <- c("ID", "Code", "Descritption")}
			return(res)
		}
	)

setMethod("IgetSpatialReference",
	       signature(object = "odm1_1"),
       	       function(object,ID=NULL, SRSID=NULL, SRSName=NULL, IsGeographic=NULL, Notes=NULL,exact=FALSE) { 

			#the where.object is used to assemble the where clause
		  	w.o <- list(where.clause = "", the.and  = "")
			w.o <- expand.where(w.o, ID, "SpatialReferenceID", exact=TRUE)
			w.o <- expand.where(w.o, SRSID, "SRSID", exact=TRUE)
			w.o <- expand.where(w.o, SRSName, "SRSName", exact=exact)
			w.o <- expand.where(w.o, IsGeographic, "IsGeographic", exact=TRUE)
			w.o <- expand.where(w.o, Notes, "Notes", exact=exact)

			where.clause <- w.o$where.clause
			if(where.clause!="") where.clause <- paste(" WHERE ", where.clause)
			
			query <- paste("SELECT * FROM SpatialReferences", where.clause)
			res <- run.query(object, query )
			#ToDo: Define standard return values and order
			if(NROW(res)>0) {names(res)[1] <- c("ID")}
			return(res)
	       }) 
setMethod("IgetQualityControlLevel", 
		signature(object = "odm1_1"),
		function(object,  ID=NULL, Code=NULL, Definition=NULL, Explanation=NULL, ...){
			where.clause <- ""
			the.and  <- ""
			if(!is.null(ID)){
				where.clause <- paste(where.clause, the.and, "QualityControlLevelID like '%", ID, "%'", sep="")
				the.and <- " AND "
			}
			if(!is.null(Code)){
				where.clause <- paste(where.clause, the.and, "QualityControlLevelCode like '%", Code, "%'", sep="")
				the.and <- " AND "
			}
			if(!is.null(Definition)){
				where.clause <- paste(where.clause, the.and, "Definition like '%", Definition, "%'", sep="")
				the.and <- " AND "
			}
			if(!is.null(Explanation)){
				where.clause <- paste(where.clause, the.and, "Explanation like '%", Explanation, "%'", sep="")
				the.and <- " AND "
			}
			query <- paste("SELECT * FROM QualityControlLevels WHERE ", where.clause)
			res <- run.query(object, query )
			#ToDo: Define standard return values and order
			if(NROW(res)>0) {names(res)[1:3] <- c("ID", "Code", "Descritption")}
			return(res)
		}
	)
setMethod("IgetSample", 
		signature(object = "odm1_1"),
		function(object,  ID=NULL, LabSampleCode=NULL, ...){
			where.clause <- ""
			the.and  <- ""
			if(!is.null(ID)){
				where.clause <- paste(where.clause, the.and, "SampleID like '%", ID, "%'", sep="")
				the.and <- " AND "
			}
			if(!is.null(LabSampleCode)){
				where.clause <- paste(where.clause, the.and, "LabSampleCode like '%", LabSampleCode, "%'", sep="")
				the.and <- " AND "
			}
			query <- paste("SELECT * FROM Samples WHERE ", where.clause)
			res <- run.query(object, query )
			#ToDo: Define standard return values and order
			if(NROW(res)>0) {names(res)[1] <- c("ID")}
			return(res)
		}
	)
setMethod("IgetOffsetType", 
		signature(object = "odm1_1"),
		function(object,  ID=NULL, Description=NULL, Units=NULL, ...){
			where.clause <- ""
			the.and  <- ""
			if(!is.null(ID)){
				where.clause <- paste(where.clause, the.and, "OffsetTypeID like '%", ID, "%'", sep="")
				the.and <- " AND "
			}
			if(!is.null(Description)){
				where.clause <- paste(where.clause, the.and, "OffsetDescription like '%", Description, "%'", sep="")
				the.and <- " AND "
			}
			if(!is.null(Units)){
				where.clause <- paste(where.clause, the.and, "OffsetUnits like '%", Units, "%'", sep="")
				the.and <- " AND "
			}
			query <- paste("SELECT * FROM OffsetTypes WHERE ", where.clause)
			res <- run.query(object, query )
			#ToDo: Define standard return values and order
			if(NROW(res)>0) {names(res)[1:3] <- c("ID", "UnitsID", "Descritption")}
			return(res)
		}
	)
setMethod("IgetMethod", 
		signature(object = "odm1_1"),
		function(object,  ID=NULL, Description=NULL, ...){
			where.clause <- ""
			the.and  <- ""
			if(!is.null(ID)){
				where.clause <- paste(where.clause, the.and, "MethodID like '%", ID, "%'", sep="")
				the.and <- " AND "
			}
			if(!is.null(Description)){
				where.clause <- paste(where.clause, the.and, "MethodDescription like '%", Description, "%'", sep="")
				the.and <- " AND "
			}
			query <- paste("SELECT * FROM Methods WHERE ", where.clause)
			res <- run.query(object, query )
			#ToDo: Define standard return values and order
			if(NROW(res)>0) {names(res)[1:3] <- c("ID", "Code", "Descritption")}
			return(res)
		}
	)
setMethod("IgetSource", 
		signature(object = "odm1_1"),
		function(object,  ID=NULL, Organization=NULL, Description=NULL, Citation=NULL, ...){
			where.clause <- ""
			the.and  <- ""
			if(!is.null(ID)){
				where.clause <- paste(where.clause, the.and, "SourceID like '%", ID, "%'", sep="")
				the.and <- " AND "
			}
			if(!is.null(Organization)){
				where.clause <- paste(where.clause, the.and, "Organization like '%", Organization, "%'", sep="")
				the.and <- " AND "
			}
			if(!is.null(Description)){
				where.clause <- paste(where.clause, the.and, "SourceDescription like '%", Description, "%'", sep="")
				the.and <- " AND "
			}
			if(!is.null(Citation)){
				where.clause <- paste(where.clause, the.and, "Citation like '%", Citation, "%'", sep="")
				the.and <- " AND "
			}
			query <- paste("SELECT * FROM Sources WHERE ", where.clause)
			res <- run.query(object, query )
			#ToDo: Define standard return values and order
			if(NROW(res)>0) {names(res)[1:3] <- c("ID", "Code", "Descritption")}
			return(res)
		}
	)
setMethod("IgetOldDataValues", 
		signature(object = "odm1_1Ver"),
		function(object,ID=NULL, from=NULL, to=NULL, SiteID=NULL, VariableID=NULL, Offset=NULL, OffsetTypeID=NULL, CensorCode=NULL, QualifierID=NULL, MethodID=NULL, SourceID=NULL, SampleID=NULL, DerivedFromID=NULL, QualityControlLevelID=NULL, VersionID, exact=FALSE, ...  ){

			where.clause <- assembleDataWhereClause(ID=ID, from=from, to=to, SiteID=SiteID, VariableID=VariableID, Offset=Offset, OffsetTypeID=OffsetTypeID, CensorCode=CensorCode, QualifierID=QualifierID, MethodID=MethodID, SourceID=SourceID, SampleID=SampleID, DerivedFromID=DerivedFromID, QualityControlLevelID=QualityControlLevelID, exact=exact)

			the.query <- paste("SELECT * FROM DataValuesRepository NATURAL JOIN (SELECT ValueID, min(VersionID) AS VersionID FROM DataValuesRepository ", where.clause, " AND VersionID >= ",VersionID," GROUP BY ValueID) AS RecSelect ")
			to.ret <- run.query(object, the.query )
			return(restructureDataResult(to.ret))
		}
	)

setMethod("IgetOldDataValues", 
		signature(object = "odm1_1"),
		function(object,ID=NULL, from=NULL, to=NULL, SiteID=NULL, VariableID=NULL, Offset=NULL, OffsetTypeID=NULL, CensorCode=NULL, QualifierID=NULL, MethodID=NULL, SourceID=NULL, SampleID=NULL, DerivedFromID=NULL, QualityControlLevelID=NULL, VersionID, ...  ){

			#Do nothing because no version
		}
)
setMethod("IgetDataValues", 
		signature(object = "odm1_1"),
		function(object,ID=NULL, from=NULL, to=NULL, SiteID=NULL, VariableID=NULL, Offset=NULL, OffsetTypeID=NULL, CensorCode=NULL, QualifierID=NULL, MethodID=NULL, SourceID=NULL, SampleID=NULL, DerivedFromID=NULL, QualityControlLevelID=NULL, exact=FALSE, ...  ){

			where.clause <- assembleDataWhereClause(ID=ID, from=from, to=to, SiteID=SiteID, VariableID=VariableID, Offset=Offset, OffsetTypeID=OffsetTypeID, CensorCode=CensorCode, QualifierID=QualifierID, MethodID=MethodID, SourceID=SourceID, SampleID=SampleID, DerivedFromID=DerivedFromID, QualityControlLevelID=QualityControlLevelID, exact=exact)

			query <- paste("SELECT * FROM DataValues ", where.clause)
			to.ret <- run.query(object, query )
			#ToDo: Define standard return values and order
			return(restructureDataResult(to.ret))
		}
	)
setMethod("IdeleteDataValues", 
		signature(object = "odm1_1"),
		function(object, ValueID){
			the.query <- paste("DELETE FROM DataValues 
					 WHERE ValueID = ", paste(ValueID, collapse=" OR ValueID = "), sep="")
				run.query(object, the.query)

		}
)
setMethod("IarchiveDataValues", 
		signature(object = "odm1_1"),
		function(object, ValueID,reason){
			#Do nothing as this does not have a version management system
		}
)
setMethod("IgetDataVersions", 
		signature(object = "odm1_1"),
		function(object){
			stop("Versions not implemented")
		}
)
setMethod("IgetCurrentDataVersion", 
		signature(object = "odm1_1"),
		function(object){
			stop("Versions not implemented")
		}
)
setMethod("IaddDataVersion", 
		signature(object = "odm1_1"),
		function(object, reason){
			stop("Versions not implemented")
		}
)

setMethod("IgetDataVersions", 
		signature(object = "odm1_1Ver"),
		function(object){
			#Do nothing as this does not have a version management system
			the.query <- "SELECT * FROM Versions"
			to.ret <- run.query(object, the.query )
			return(to.ret)
		}
)

setMethod("IgetCurrentDataVersion", 
		signature(object = "odm1_1Ver"),
		function(object){
			#Do nothing as this does not have a version management system
			the.query <- "SELECT MAX( VersionID ) FROM Versions"
			to.ret <- run.query(object, the.query )
			return(as.numeric(to.ret))
		}
)

setMethod("IaddDataVersion", 
		signature(object = "odm1_1Ver"),
		function(object, reason){
			# Eintrag in VersionsTabelle ValidUntilDate zum alten Datensatz
			the.query <- paste("UPDATE Versions SET ValidUntil = ", sqlnow(object) ," WHERE VersionID =", IgetCurrentDataVersion(object))
			run.query(object, the.query )
			# Neuer Eintrag in VersionsTabelle mit neuer Begründung
			the.query <- paste("INSERT INTO Versions (VersionComment) Values ('",reason,"')", sep="")
			run.query(object, the.query )

			# Achtung: beim Abholen von der Versionshistory 
			#	muss die Begründung für die Änderung jeweils 
			#	bei der nächsten Versionsnummer nachgeschaut werden.
			the.query <- "SELECT LAST_INSERT_ID()"
			to.ret <- run.query(object, the.query )
			return(as.numeric(to.ret))
		}
)
setMethod("IarchiveDataValues", 
		signature(object = "odm1_1Ver"),
		function(object, ValueID,reason){
			stopifnot(!is.null(reason))
			stopifnot(length(ValueID)>0)
			# daten kopieren mit aktueller Datenversion als ValidUntilID
			currentVersion <-  IgetCurrentDataVersion(object)
			if(is.na(currentVersion)){
				the.query <- paste("INSERT INTO Versions (VersionComment) Values ('Initial Version')", sep="")
				run.query(object, the.query )
			}
			the.query = paste("INSERT INTO DataValuesRepository SELECT ValueID, VersionID, DataValue, ValueAccuracy, LocalDateTime, UTCOffset, DateTimeUTC, SiteID, VariableID, OffsetValue, OffsetTypeID, CensorCode, QualifierID, MethodID, SourceID, SampleID, DerivedFromID, QualityControlLevelID FROM DataValues JOIN (SELECT ",currentVersion," as VersionID) as Version WHERE ValueID = ", paste(ValueID, collapse=" OR ValueID = "), sep="")
			run.query(object, the.query )
			# Version updaten
			IaddDataVersion(object, reason)

		}
)
setMethod("IupdateDataValues", 
		signature(object = "odm1_1"),
		function(object, ValueID, localDateTime, value, TZ, SiteID, VariableID, Offset=NULL, OffsetTypeID=NULL, CensorCode, QualifierID=NULL, MethodID, SourceID, SampleID=NULL, DerivedFromID=NULL, QualityControlLevelID, valueAccuracy=NULL,...  ){
			insert.query <- paste("UPDATE DataValues SET DataValue = ",value,
					", ValueAccuracy = ", valueAccuracy,
				       	", LocalDateTime = '", localDateTime,
				       	"', UTCOffset = ", tz2offset(TZ),
					", DateTimeUTC = '", strftime(localDateTime, tz=TZ),
					"', SiteID = ", SiteID, 
					", VariableID = ", VariableID,
					", OffsetValue = ", Offset,
					", OffsetTypeID = ", OffsetTypeID,
				        ", CensorCode = '", CensorCode,
					"', QualifierID = ", QualifierID,
				        ", MethodID = ", MethodID, 
					", SourceID = ", SourceID,
					", SampleID = ", SampleID, 
					", DerivedFromID = ", DerivedFromID,
					", QualityControlLevelID = ", QualityControlLevelID,
					" WHERE ValueID = ", ValueID, sep="")
				run.query(object, insert.query)

		}
)
setMethod("IaddVariable", signature=(object = "odm1_1"),
	  function(object, Code, Name, Speciation, Unit, SampleMedium,ValueType, IsRegular, TimeSupport, TimeUnits, DataType, GeneralCategory, NoDataValue) {
			for(rownum in seq(along=Name)){
				#no Foreign Key
		  		theCode <- sv(Code, rownum)
		  		theNoDataValue <- sv(NoDataValue, rownum)
				theIsRegular <- sv(IsRegular, rownum)
				theTimeSupport <- sv(TimeSupport, rownum)
				#Handle CV-Fields: VariableName, Speciation, SampleMedium,
			        #	ValueType, DataType, GeneralCategory
				#Other Fields with foreign key: VariableUnits, TimeUnits
				theName <- svk(Name, "Name", rownum, object)
				theSpeciation <- svk(Speciation, "Speciation", rownum, object)
				theUnit <- svk(Unit, "Unit", rownum, object)
				theSampleMedium <- svk(SampleMedium, "SampleMedium", rownum, object)
				theValueType <- svk(ValueType, "ValueType", rownum, object)
				theTimeUnits <- svk(TimeUnits, "TimeUnits", rownum, object)
				theDataType <- svk(DataType, "DataType", rownum, object)
				theGeneralCategory <- svk(GeneralCategory, "GeneralCategory", rownum, object)


				insert.query <- paste("INSERT INTO Variables (VariableCode, VariableName, Speciation, VariableUnitsID, SampleMedium,ValueType, IsRegular, TimeSupport, TimeUnitsID, DataType, GeneralCategory, NoDataValue) VALUES ('", paste(
						theCode,
						theName ,
						theSpeciation ,
						theUnit ,
						theSampleMedium ,
						theValueType ,
						theIsRegular ,
						theTimeSupport ,
						theTimeUnits ,
						theDataType ,
						theGeneralCategory ,
						theNoDataValue ,
						sep="', '"), "')", sep="")
			 	run.query(object, insert.query )
			}
	  }
)
setMethod("IaddISOMetadata",
		signature(object = "odm1_1"),
		function(object, TopicCategory, Title, Abstract, ProfileVersion, MetadataLink) {
		for(rownum in seq(along=Title)){
			theTopicCategory <- svk(TopicCategory, "TopicCatgeoryCV", rownum,object)
			insert.query <- paste("INSERT INTO ISOMetadata (TopicCategory, Title, Abstract, ProfileVersion, MetadataLink) VALUES ('", paste(
					theTopicCategory,
					Title[rownum],
					Abstract[rownum],
					ProfileVersion[rownum],
					MetadataLink[rownum],
					sep="', '"), "')", sep="")
			run.query(object, insert.query )

		}
	}
)
setMethod("IaddSource",
		signature(object = "odm1_1"),
		function(object, Organization, SourceDescription, SourceLink, ContactName, Phone, Email, Address, City, State, ZipCode, Citation, Metadata) {
		for(rownum in seq(along=SourceDescription)){
			theMetadata <- svk(Metadata, "ISOMetadata", rownum,object)
			insert.query <- paste("INSERT INTO Sources (Organization, SourceDescription, SourceLink, ContactName, Phone, Email, Address, City, State, ZipCode, Citation, MetadataID) VALUES ('", paste(
					Organization[rownum],
					SourceDescription[rownum],
					SourceLink[rownum],
					ContactName[rownum],
					Phone[rownum],
					Email[rownum],
					Address[rownum],
					City[rownum],
					State[rownum],
					ZipCode[rownum],
					Citation[rownum],
					theMetadata,
					sep="', '"), "')", sep="")
			run.query(object, insert.query )

		}
	}
)

setMethod("IaddSite", 
		signature(object = "odm1_1"),
		function(object, Code, Name, Latitude, Longitude, LatLongDatum, Elevation=NULL, VerticalDatum=NULL, LocalX=NULL,LocalY=NULL, LocalProjection=NULL, PosAccuracy=NULL, State=NULL, County=NULL, Comments=NULL){
			for(rownum in seq(along=Name)){

				#no Foreign Key
				#replace with
				# :'<,'>s/\i*$/the& <- sv(&, rownum)/  
				theElevation <- sv(Elevation, rownum)
				theLocalX <- sv(LocalX, rownum)
				theLocalY <- sv(LocalY, rownum)
				thePosAccuracy <- sv(PosAccuracy, rownum)
				theState <- sv(State, rownum)
				theCounty <- sv(County, rownum)
				theComment <- sv(Comments, rownum)
				#with Foreign Key 
				# :'<,'>s/\i*$/the& <- svk(&, "&", rownum, object)/   
				theVerticalDatum <- svk(VerticalDatum, "VerticalDatumCV",rownum,object)
				theLocalProjection <- svk(LocalProjection, "SpatialReferences", rownum,object)

				insert.query <- paste("INSERT INTO Sites (SiteCode, SiteName, Latitude, Longitude, LatLongDatumID, Elevation_m, VerticalDatum, LocalX, LocalY, LocalProjectionID, PosAccuracy_m, State, County, Comments) VALUES ('", paste(

						Code[rownum],
						Name[rownum],
						Latitude[rownum],
						Longitude[rownum],
						LatLongDatum[rownum],
						theElevation,
						theVerticalDatum,
						theLocalX,
						theLocalY,
						theLocalProjection,
						thePosAccuracy,
						theState,
						theCounty,
						theComment,
						sep="', '"), "')", sep="")
			 	run.query(object, insert.query )
			}

		}
)
setMethod("IaddDataValues", 
		signature(object = "odm1_1"),
		function(object, localDateTime, values, TZ, SiteID, VariableID, Offset=NULL, OffsetTypeID=NULL, CensorCode, QualifierID=NULL, MethodID, SourceID, SampleID=NULL, DerivedFromID=NULL, QualityControlLevelID, valueAccuracy=NULL,...  ){
			for(rownum in seq(along=values)){
				
				#with Foreign Key 
				theOffsetTypeID <- svk(OffsetTypeID, "OffsetType", rownum,object)
				theQualifierID <- svk(QualifierID, "Qualifier", rownum,object)
				theSampleID <- svk(SampleID, "Sample", rownum,object)
				theSiteID <- svk(SiteID, "SiteID", rownum, object)
				theVariableID <- svk(VariableID, "VariableID", rownum, object)
				theMethodID <- svk(MethodID, "MethodID", rownum, object)
				theCensorCode <- svk(CensorCode, "CensorCodeCV", rownum, object)
				theSourceID <- svk(SourceID, "SourceID", rownum, object)
				theQualityControlLevelID <- svk(QualityControlLevelID, "QualityControlLevelID", rownum, object)

				#without Foreign Key
				theOffset <- sv(Offset, rownum)
				thevalueAccuracy <- sv(valueAccuracy, rownum)
				thelocalDateTime <- sv(localDateTime, rownum)
				theTZ <- sv(TZ, rownum)
				theDerivedFromID <- sv(DerivedFromID, rownum)

				insert.query <- paste("INSERT INTO DataValues (DataValue, ValueAccuracy, LocalDateTime, UTCOffset, DateTimeUTC, SiteID, VariableID, OffsetValue, OffsetTypeID, CensorCode, QualifierID, MethodID, SourceID, SampleID, DerivedFromID, QualityControlLevelID) VALUES ('", paste(values[rownum],
						thevalueAccuracy,
						thelocalDateTime,
						theTZ , 
						strftime(thelocalDateTime, tz="GMT"), 
						theSiteID, theVariableID,
						theOffset,
						theOffsetTypeID,
						theCensorCode,
						theQualifierID,
						theMethodID,
						theSourceID,
						theSampleID,
						theDerivedFromID,
						theQualityControlLevelID ,sep="', '"), "')", sep="")
			 	run.query(object, insert.query )
			}
		}
	)
setMethod("IgetNo",
	  signature(object= "odm1_1"),
	  function(object, table){
		#lookup table for database information
		tab.def <- matrix(
				 #db table, db attribute
				c("SpatialReferences", "SRSName", "SRSID, IsGeographic, Notes, SpatialReferenceID","0, 0, '', 'No'", "SpatialReferenceID",
	  			  "OffsetTypes", "OffsetDescription", "OffsetUnitsID", "1", "OffsetTypeID",
				  "Qualifiers", "QualifierCode", "QualifierDescription", "'No Qualifier - to enable optional fields with foreign keys'", "QualifierID" ,
				  "Samples", "LabSampleCode", "SampleType, LabMethodID", "'no', 1", "SampleID",
				  "ISOMetadata", "Title", "TopicCategory", "'Unknown'", "MetadataID"
				),
		  	byrow=TRUE, ncol=5)
		CVtab <- paste(CVtables(), "CV", sep="")
		lc <- length(CVtab)
		CVentries <- cbind(CVtab, rep("Definition", lc), rep("Term",lc), rep("'no'",lc), rep("Term", lc))
		tab.def <- rbind(tab.def, CVentries)
		tab.def <- as.data.frame(tab.def, stringsAsFactors=FALSE)
		names(tab.def) <- c("tab", "col", "other.fields", "default.values", "primary.key")
		tab.def.bak <- tab.def
		tab.def <- tab.def[tab.def$tab==table,]
		if(NROW(tab.def)!=1){
			cat("Existing tables:\n")
			print(tab.def.bak$tab)
		       	stop(paste("IgetNo: No definitions for table", table))
		}

		query <- paste("SELECT * FROM ", tab.def$tab ," WHERE ", tab.def$col,"='No",tab.def$tab,"'", sep="")
		res <- run.query(object, query)
		if(NROW(res)==0){
			ins.query <- paste("INSERT INTO ", tab.def$tab ," (",tab.def$col, ", ", tab.def$other.fields,") Values ('No",tab.def$tab,"',", tab.def$default.values,")", sep="" )
			res <- run.query(object, ins.query)
			res <- run.query(object, query)

		}
		return(res[[tab.def$primary.key]])
	  }
)

setMethod("IgetCV",
	  signature(object= "odm1_1"),
	  function(object, table, term, definition, exact=FALSE){
		  #check for valid tables
		  stopifnot(table %in% CVtables())
		  	where.object <- list(where.clause = "", the.and  = "")

			where.object <- expand.where(where.object, term, "Term", exact=exact)
			where.object <- expand.where(where.object, definition, "Definition", exact=exact)

			where.clause <- where.object$where.clause
			if(where.clause!="") where.clause <- paste(" WHERE ", where.clause)

			query <- paste("SELECT * FROM ",table,"CV", where.clause, sep="")
			res <- run.query(object, query )
			return(res)
	  }
)
setMethod("IaddCV",
	  signature(object= "odm1_1"),
	  function(object, table, term, definition){
		  #check for valid tables
		  stopifnot(table %in% CVtables())
			query <- paste("INSERT INTO ",table,"CV (Term, Definition) Values ('", term, "','",definition,"')"  , sep="")
			res <- run.query(object, query )
			return(res)
	  }
)
setMethod("IaddUnits",
	  signature(object= "odm1_1"),
	  function(object, ID, Name, Type, Abbreviation){
		  #check for valid tables
			query <- paste("INSERT INTO Units (UnitsID, UnitsName, UnitsType, UnitsAbbreviation) Values ('", ID, "','",Name, "','", Type ,"','",Abbreviation,"')"  , sep="")
			res <- run.query(object, query )
			return(res)
	  }
)

setMethod("IaddSynonym",
	       signature(object= "odm1_1"),
       	       function(object, phrase, table, id){
		       query <- paste('INSERT INTO Synonyms (phrase, RecID, tab) Values ("',
				       phrase, '","', id, '","', table,'")', sep='')
			res <- run.query(object, query)
	       })
setMethod("IgetSynonymID",
	       signature(object= "odm1_1"),
	       function(object, phrase, table){
		       query <- paste('SELECT RecID FROM Synonyms WHERE phrase = "',
				       phrase, '" AND tab="', table, '"', sep='')
			res <- run.query(object, query)
			return(res$RecID)

	       })
#setMethod("IgetNoVerticalDatum", 

#		signature(object = "odm1_1"),
#		function(object){
#
#			query <- "SELECT * FROM VerticalDatumCV WHERE Definition='No Datum'" 
#			res <- run.query(object, query)
#			if(length(res)==0){
#				ins.query <- "INSERT INTO VerticalDatumCV (Term, Definition) Values ('No','No Datum')" 
#				res <- run.query(object, ins.query)
#				res <- run.query(object, query)
#
#			}
#			return(res$Term)
#		})
#
#setMethod("IgetNoOffsetType", 
#		signature(object = "odm1_1"),
#		function(object){
#
#			query <- "SELECT * FROM OffsetTypes WHERE OffsetDescription='No Offset'" 
#			res <- run.query(object, query)
#			if(length(res)==0){
#				query <- "INSERT INTO OffsetTypes (OffsetUnitsID, OffsetDescription) Values (1,'No Offset')" 
#				res <- run.query(object, query)
#				query <- "SELECT * FROM OffsetTypes WHERE OffsetDescription='No Offset'" 
#				res <- run.query(object, query)
#
#			}
#			return(res$OffsetTypeID)
#		})
#setMethod("IgetNoQualifier", 
#		signature(object = "odm1_1"),
#		function(object){
#
#			query <- "SELECT * FROM Qualifiers WHERE QualifierCode='NoQualifier'" 
#			if(getOption("verbose.queries", default=FALSE)) print(query)
#			res <- dbGetQuery(object, query)
#			if(length(res)==0){
#				query <- "INSERT INTO Qualifiers (QualifierCode, QualifierDescription) Values ('NoQualifier', 'No Qualifier - to enable optional fields with foreign keys')"
#				if(getOption("verbose.queries", default=FALSE)) print(query)
#				res <- dbSendQuery(object,  query)
#				query <- "SELECT * FROM Qualifiers WHERE QualifierCode='NoQualifier'" 
#				if(getOption("verbose.queries", default=FALSE)) print(query)
#				res <- dbGetQuery(object, query)
#
#			}
#			return(res$QualifierID)
#		})
#setMethod("IgetNoSample", 
#		signature(object = "odm1_1"),
#		function(object){
#
#			res <- run.query(object, "SELECT * FROM Samples WHERE LabSampleCode='No Sample'" )
#			if(length(res)==0){
#				#ToDo: Set real default values
#				res <- run.query(object, "INSERT INTO Samples (SampleType, LabSampleCode, LabMethodID) Values ('bla', 'No Sample', 1)" )
#				res <- run.query(object, "SELECT * FROM Samples WHERE LabSampleCode='No Sample'" )
#
#			}
#			return(res$SampleID)
#		})
