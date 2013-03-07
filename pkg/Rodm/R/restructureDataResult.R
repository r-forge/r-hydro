restructureDataResult <- function(to.ret, value.numeric=TRUE){
	if(NROW(to.ret)>0) {
		#to be compatible with postgres
		colnames(to.ret) <- tolower(colnames(to.ret))
		#to be able to compare also NA
		to.ret[is.na(to.ret)] <- -9999999999
		#sort according to data types and create to xts objects, one numeric, one string
		data.types <- sapply(to.ret, is.numeric)
		the.numerics <- which(data.types)
		the.char <- which(!data.types)
		index.col <- which(names(to.ret)=="datetimeutc")
		the.char <- the.char[the.char!=index.col]

		order.by <- chr2date(to.ret[,index.col], tz="GMT")
		order.by.unique <- chr2date(unique(to.ret[,index.col]), tz="GMT")

		ts.columns <- colnames(to.ret) %in% tolower(c("ValueID", "DataValue", "LocalDateTime", "DateTimeUTC", "DerivedFromID", "VersionID"))
		metadata <- unique(to.ret[,!ts.columns])
		for(dataset in 1:NROW(metadata)){
				sel<- to.ret$valueaccuracy == metadata$valueaccuracy[dataset]&
				to.ret$utcoffset == metadata$utcoffset[dataset]&
				to.ret$siteid == metadata$siteid[dataset]&
				to.ret$variableid == metadata$variableid[dataset]&
				to.ret$offsetvalue == metadata$offsetvalue[dataset]&
				to.ret$offsettypeid == metadata$offsettypeid[dataset]&
				to.ret$censorcode == metadata$censorcode[dataset]&
				to.ret$qualifierid == metadata$qualifierid[dataset]&
				to.ret$methodid == metadata$methodid[dataset]&
				to.ret$sourceid == metadata$sourceid[dataset]&
				to.ret$sampleid == metadata$sampleid[dataset]&
				to.ret$qualitycontrollevelid == metadata$qualitycontrollevelid[dataset]


				if(sum(sel) != length(unique(order.by[sel]))){
					dup <- duplicated(to.ret[,-1])
					if(any(dup)){
						ids <- to.ret$valueid[sel]
						sel[sel] <- !dup
						if(sum(sel) != length(unique(order.by[sel]))){
							cat("Multiple entries with the same metadata, but not duplicates (?). Resolve in browser.\n")
							browser()
						} else {
							warning(paste("Some duplicated entries in database in the dataset with ids", paste(ids, collapse="; ") ))
						}



					} else {
						dup <- duplicated(to.ret[,-c(1,2)])
						if(any(dup)){
							ids <- to.ret$valueid[sel]
							sel[sel] <- !dup
							if(sum(sel) != length(unique(order.by[sel]))){
								cat("Multiple entries with the same metadata, but not duplicates (?). Part2. Resolve in browser.\n")
								browser()
							} else {
								warning(paste("Entries in database with conflicting data with ids", paste(ids, collapse="; ") ))
							}



						} else {
							cat("Multiple entries with the same metadata. Can not restructure the data. A dataframe with the problematic metadata is returned\n")
							browser()
							return(id2name(metadata)[dataset,])
						}
					}
				}
				if(dataset==1){
					if(value.numeric){
						value.xts <- xts(suppressWarnings(as.numeric(to.ret[sel,"datavalue"])),order.by=order.by[sel])
					} else {
						value.xts <- xts(to.ret[sel,"datavalue"],order.by=order.by[sel])
					}
					id.xts <- xts(to.ret[sel,"valueid"],order.by=order.by[sel])
					derivedfrom.xts <-  xts(to.ret[sel,"derivedfromid"],order.by=order.by[sel])
				} else {
					value.xts <- suppressWarnings(merge(value.xts, xts(to.ret[sel,"datavalue"],order.by=order.by[sel])))
					id.xts <- merge(id.xts, xts(to.ret[sel,"valueid"],order.by=order.by[sel]))
					derivedfrom.xts <- merge(derivedfrom.xts, xts(to.ret[sel,"derivedfromid"],order.by=order.by[sel]))
				}

		}
		metadata.plain <- id2name(metadata)
		colnames(value.xts) <- paste(metadata.plain$Site, metadata.plain$Variable, sep=": ")
		colnames(id.xts) <- paste(metadata.plain$Site, metadata.plain$Variable, sep=": ")
		colnames(derivedfrom.xts) <- paste(metadata.plain$Site, metadata.plain$Variable, sep=": ")
		#convert NA back
		value.xts[value.xts==-9999999999] <- NA
		derivedfrom.xts[derivedfrom.xts==-9999999999] <- NA
		metadata.plain[metadata.plain==-9999999999] <- NA

		to.ret <- new("observations", values=value.xts, ids=id.xts, derivedFrom=derivedfrom.xts, attributes=metadata.plain)
		#to.ret <- list(values=value.xts, ids=id.xts, derivedfrom=derivedfrom.xts, attrib=metadata.plain)
		
		#browser()
		#names(res)[1:3] <- c("ID", "Code", "Descritption")
	}
}

