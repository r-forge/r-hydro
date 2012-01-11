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
		  if(all(x@attributes==y@attributes)){
			  to.ret <- new("observations",
			  	values=rbind(x@values, y@values),
			  	ids=rbind(x@ids, y@ids),
			  	derivedFrom=rbind(x@derivedFrom, y@derivedFrom),
				attributes=x@attributes)
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
setMethod("[", signature=signature(x="observations"),
		function(x,i,j,...,drop=FALSE){
			if(!missing(j)){
				todo("Implement indexing with multiple entries for observations")
				browser()
				stop("Missing implementation")
			}
			if(NCOL(x@values)>1){
				todo("Implement indexing for multiple cols")
				#relatively easy for values, ids
				#make sure correct attributes are returned
				browser()
				stop("Missing implementation")
			}
			to.ret <- new("observations", values = x@values[i],
			       ids = x@ids[i],
			       derivedFrom = x@derivedFrom[i],
			       attributes = x@attributes)
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
