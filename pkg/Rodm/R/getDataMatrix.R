getDataMatrix <- function(variables, warn.missing=FALSE){
	all.countries <- getMetadata("Site")
	c.data <- matrix(NA, nrow=NROW(all.countries), ncol=length(variables))

	for(cc in 1:NROW(all.countries$Name)){
		cat("  Processing country ", all.countries$Name[cc])
		for(vv in seq(along=variables)){
			value <- getDataValues(Site= all.countries$ID[cc], Variable=getID("Variable", variables[vv]))$num$DataValue
			if(is.null(value)){
				if(warn.missing){
			       		warning("no value for Site",all.countries$Name[cc], " and Variable ", variables[vv],"\n")
				}
			} else {
				if(length(value)>1){ cat("Duplicates for Site",all.countries$Name[cc], " and Variable ", variables[vv],". Importing the first only\n");
					c.data[cc,vv] <- value[1]
				} else {
					c.data[cc,vv] <- value
				}
			}
		}
	}

	c2.data <- data.frame(c.data)
	rownames(c2.data) <- all.countries$Name
	colnames(c2.data) <- variables
	c2.data$fipsCode <- all.countries$Code
	return(c2.data)

}
