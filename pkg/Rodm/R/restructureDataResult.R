restructureDataResult <- function(to.ret){
			if(NROW(to.ret)>0) {
				zoo.obj <- zoo()
				#sort according to data types and create to zoo objects, one numeric, one string
				data.types <- sapply(to.ret, is.numeric)
				the.numerics <- which(data.types)
				the.char <- which(!data.types)
				index.col <- which(names(to.ret)=="DateTimeUTC")
				the.char <- the.char[the.char!=index.col]

				order.by <- as.POSIXct(strptime(to.ret[,index.col], "%Y-%m-%d %H:%M:%s", tz="GMT"))
				to.ret <- list(num=zoo(as.matrix(to.ret[,the.numerics]), order.by = order.by), char=zoo(to.ret[,the.char], order.by = order.by))
				
				#browser()
				#names(res)[1:3] <- c("ID", "Code", "Descritption")
			}
		}

