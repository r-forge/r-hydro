restructureDataResult <- function(to.ret, value.numeric=TRUE){
			if(NROW(to.ret)>0) {
				#sort according to data types and create to xts objects, one numeric, one string
				data.types <- sapply(to.ret, is.numeric)
				the.numerics <- which(data.types)
				the.char <- which(!data.types)
				index.col <- which(names(to.ret)=="DateTimeUTC")
				the.char <- the.char[the.char!=index.col]

				order.by <- chr2date(to.ret[,index.col], tz="GMT")
				order.by.unique <- chr2date(unique(to.ret[,index.col]), tz="GMT")

				ts.columns <- colnames(to.ret) %in% c("ValueID", "DataValue", "LocalDateTime", "DateTimeUTC", "DerivedFromID", "VersionID")
				metadata <- unique(to.ret[,!ts.columns])
				for(dataset in 1:NROW(metadata)){
						sel<- to.ret$ValueAccuracy == metadata$ValueAccuracy[dataset]&
						to.ret$UTCOffset == metadata$UTCOffset[dataset]&
						to.ret$SiteID == metadata$SiteID[dataset]&
						to.ret$VariableID == metadata$VariableID[dataset]&
						to.ret$OffsetValue == metadata$OffsetValue[dataset]&
						to.ret$OffsetTypeID == metadata$OffsetTypeID[dataset]&
						to.ret$CensorCode == metadata$CensorCode[dataset]&
						to.ret$QualifierID == metadata$QualifierID[dataset]&
						to.ret$MethodID == metadata$MethodID[dataset]&
						to.ret$SourceID == metadata$SourceID[dataset]&
						to.ret$SampleID == metadata$SampleID[dataset]&
						to.ret$QualityControlLevelID == metadata$QualityControlLevelID[dataset]


						if(sum(sel) != length(unique(order.by[sel]))){
							cat("Multiple entries with the same metadata. Can not restructure the data. A dataframe with the problematic metadata is returned\n")
							browser()
							return(id2name(metadata)[dataset,])
						}
						if(dataset==1){
							if(value.numeric){
								value.xts <- xts(suppressWarnings(as.numeric(to.ret[sel,"DataValue"])),order.by=order.by[sel])
							} else {
								value.xts <- xts(to.ret[sel,"DataValue"],order.by=order.by[sel])
							}
							id.xts <- xts(to.ret[sel,"ValueID"],order.by=order.by[sel])
							derivedfrom.xts <-  xts(to.ret[sel,"DerivedFromID"],order.by=order.by[sel])
						} else {
							value.xts <- suppressWarnings(merge(value.xts, xts(to.ret[sel,"DataValue"],order.by=order.by[sel])))
							id.xts <- merge(id.xts, xts(to.ret[sel,"ValueID"],order.by=order.by[sel]))
							derivedfrom.xts <- merge(derivedfrom.xts, xts(to.ret[sel,"DerivedFromID"],order.by=order.by[sel]))
						}

				}
				metadata.plain <- id2name(metadata)
				colnames(value.xts) <- paste(metadata.plain$Site, metadata.plain$Variable, sep=": ")
				colnames(id.xts) <- paste(metadata.plain$Site, metadata.plain$Variable, sep=": ")
				colnames(derivedfrom.xts) <- paste(metadata.plain$Site, metadata.plain$Variable, sep=": ")
				to.ret <- new("observations", values=value.xts, ids=id.xts, derivedFrom=derivedfrom.xts, attributes=metadata.plain)
				#to.ret <- list(values=value.xts, ids=id.xts, derivedfrom=derivedfrom.xts, attrib=metadata.plain)
				
				#browser()
				#names(res)[1:3] <- c("ID", "Code", "Descritption")
			}
		}

