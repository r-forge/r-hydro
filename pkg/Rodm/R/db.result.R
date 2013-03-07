setOldClass("xts")
setClass("observations",
	 representation = representation(values = "xts",
					 ids = "xts",
					 derivedFrom = "xts",
					 attributes = "data.frame"),
	 prototype = prototype(values = xts(),
			       ids = xts(),
			       derivedFrom = xts(),
			       attributes = data.frame()))

setGeneric("merge", function(x,y,...) {standardGeneric("merge")})
setMethod("merge", signature=signature(x="observations", y="observations"),
	  function(x, y, ...){
		  x.attributes.old <- x@attributes
		  x@attributes[is.na(x@attributes)] <- -9999
		  y@attributes[is.na(y@attributes)] <- -9999
		  if(all(x@attributes==y@attributes)){
			  to.ret <- new("observations",
			  	values=rbind(x@values, y@values),
			  	ids=rbind(x@ids, y@ids),
			  	derivedFrom=rbind(x@derivedFrom, y@derivedFrom),
				attributes=x.attributes.old)
	  	  } else {
			  todo("Implement merge if attributes are differing")
			  browser()
			  stop("not implemented")
		  }
		  return(to.ret)
	  }
  )

setMethod("plot", signature=(x="observations"),
	  function(x, y, ...){
		new.xts <- xts(matrix(as.numeric(coredata(x@values)),ncol=NCOL(x@values)), order.by=index(x@values))
		plot.zoo(new.xts, ...)
	  }
)
setMethod("summary", signature=(object="observations"),
	  function(object){
		  for(i in 1:NCOL(object@values)){
			  print(t(object@attributes[i,]))
			  print(summary(object@values[,i]))
		  }
	  }
)

setMethod("show", signature=(object="observations"),
	  function(object){
		  cat(sum(!is.na(object@values))," observations from database query\n")
		  cat("Sites: ", paste(unique(object@attributes$site), collapse="; "), "\n")
		  cat("Variables: ", paste(unique(substr(object@attributes$variable, 1,15)), collapse="; "), "\n\n")


	  }
)
setMethod("$", signature=signature(x="observations"),
		function(x, name){
		att <- x@attributes
		matches <- matrix(grepl(name,as.matrix(att)), ncol=NCOL(att))
		sel <- which(rowSums(matches) > 0)
		if(length(sel) != 1){
			stop("No unique selection of a column according to attributes")
		}
		to.ret <- x[,sel]
		browser()
		return(to.ret)
})
setMethod("[", signature=signature(x="observations"),
		function(x,i,j,...,drop=FALSE){
			if(!missing(j)){
				if(NCOL(x@values)==1){
					stop("Wrong dimensions")
				}
				if(missing(i)){
					to.ret <- new("observations", values = x@values[,j],
					       ids = x@ids[,j],
					       derivedFrom = x@derivedFrom[,j],
					       attributes = x@attributes[j,])
		       		} else {
					to.ret <- new("observations", values = x@values[i,j],
					       ids = x@ids[i,j],
					       derivedFrom = x@derivedFrom[i,j],
					       attributes = x@attributes[j,])
				}


			}
			if(NCOL(x@values)>1){
				to.ret <- new("observations", values = x@values[i,],
				       ids = x@ids[i,],
				       derivedFrom = x@derivedFrom[i,],
				       attributes = x@attributes)
			} else {
				to.ret <- new("observations", values = x@values[i],
				       ids = x@ids[i],
				       derivedFrom = x@derivedFrom[i],
				       attributes = x@attributes)
	                }
	                return(to.ret)
		}
)
setMethod("==", signature=signature(e1="observations", e2="observations"),
		function(e1,e2){
			to.ret <- matrix(TRUE, nrow=NROW(e1@values), ncol=NCOL(e1@values))
			if(NCOL(e1@values)>1 | NCOL(e1@values)>1){
				todo("Implement comparison for multirow data")
				browser()
				stop("Unimplemented")
			}
			#matching ids?
			if(any(coredata(e1@ids) != coredata(e2@ids))){
				todo("Implement comparison for differing ids")
				browser()
				stop("Unimplemented")
			}
			#matching time?
			#this works to check difference in time because
			#just before we tested if ids match without time index
			if(any(e1@ids != e2@ids)){
				todo("Implement comparison for differing time values")
				browser()
				stop("Unimplemented")
			}
			#comparing attributes
			#work with NULL-values, which are represented as NA
			e1@attributes[is.na(e1@attributes)] <- -9999
			e2@attributes[is.na(e2@attributes)] <- -9999
			if(any(e1@attributes!=e2@attributes)){
				todo("What to do for differing attributes?")
				browser()
				stop("Unimplemented")
			}
			#comparing derived from
			d1 <- e1@derivedFrom
			d1[is.na(d1)]<-"NA"
			d2 <- e2@derivedFrom
			d2[is.na(d2)]<-"NA"
			if(any(d1!=d2)){
				todo("What to do for differing derivedFrom?")
				browser()
				stop("Unimplemented")
			}
			#comparing values
			v1 <- e1@values
			v1[is.na(v1)]<-"NA"
			v2 <- e2@values
			v2[is.na(v2)]<-"NA"
			if(any(v1!=v2)){
				at <- attributes(to.ret)
				at$values <- coredata(v1==v2)
				to.ret <- to.ret & coredata(v1==v2)
				attributes(to.ret) <- at
			}
			return(to.ret)
		}
)
