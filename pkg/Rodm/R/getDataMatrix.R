getDataMatrix <- function(variables, aggregate, select.time="latest", warn.missing=FALSE){
	interpolated <- FALSE
	all.countries <- getMetadata("Site")
	if(length(select.time)>1){
		c.data <- array(NA, dim=c(NROW(all.countries), length(variables), length(select.time)))
		make.array <- TRUE
	} else {
		c.data <- matrix(NA, nrow=NROW(all.countries), ncol=length(variables))
		make.array <- FALSE
	}

	for(cc in 1:NROW(all.countries$Name)){
		cat("  Processing ", all.countries$Name[cc], "\n")
		for(vv in seq(along=variables)){
			value1 <- getDataValues(Site= all.countries$ID[cc], Variable=getID("Variable", variables[vv]))
			

			if(is.null(value1) || is.na(value <- value1@values)){
				if(warn.missing){
			       		warning("no value for Site",all.countries$Name[cc], " and Variable ", variables[vv],"\n")
				}
			} else {
				if(length(value)>1){ 
					if(all(select.time=="latest")){
					#Use the latest value
						c.data[cc,vv] <- value[NROW(value)]
					} else {
						if (is.null(select.time)){
					#aggregate multple values
							stopifnot(class(aggregate)=="function")
							c.data[cc,vv] <- aggregate(value)
						
						} else {
					#Extract according to date
							stopifnot("POSIXt" %in% class(select.time)) 
							toextract <- xts(1:length(select.time), order.by=select.time)
							merg <- merge(value, toextract)
							#check if we need to interpolate
							if(any(is.na(merg$value[!is.na(merg$toextract)]))){
								interpolated=TRUE
								interp <- na.spline(merg$value)
								merg$value <- interp
							}
							val <- merg$value[!is.na(merg$toextract)]
							if(make.array){
								c.data[cc,vv,] <- val
							} else {
								c.data[cc,vv] <- val
							}


						}
					}
					# Only one value in DB
				} else {
					if(make.array){
						c.data[cc,vv,] <- coredata(value)
						interpolated=TRUE
					} else {
						c.data[cc,vv] <- coredata(value)
					}
				}
			}
		}
	}

	if(interpolated) warning("Used spline interpolation while extracting data for some dates")
	if(make.array){
		dimnames(c.data) <- list(all.countries$Name, variables, as.character(select.time))

		c2.data <- list(data = c.data, contryCode =all.countries$Code)
	} else {
		c2.data <- data.frame(c.data)
		rownames(c2.data) <- all.countries$Name
		colnames(c2.data) <- variables
		c2.data$countryCode <- all.countries$Code
	}
	return(c2.data)

}
