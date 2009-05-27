#internal function to read WASIM-output files
`wasim.read.table` <- function (name, na.strings=c("999", "999.00","9999", "9999.00","9999.000", "9999.000000","-9999","-9999.0","-9999.00") #strings indicating missing data
){

   cf <- count.fields(name, blank.lines.skip = FALSE)
   col.count <- as.integer(names(which.max(table(cf))))
   max.row <- suppressWarnings(min(which(cf[10:length(cf)]!=col.count)))
   if(is.infinite(max.row))
        max.row=length(cf)
   col <- paste("c", 1:(col.count-4), sep="")
   cols <- c("Year","Month","Day","Hour",col)

    colClasses=c(rep("integer",4),rep("numeric",col.count-4))   #specify data format of column (increases speed, catches "NAN" etc. in output)  


    head <- readLines(name, n=10)
    endhead <- suppressWarnings(min(grep("^[0-9]", head))-1)
    if(is.infinite(endhead)) endhead <- length(head)
    head <- head[1:endhead]
    col.names <-  strsplit(head[endhead],"[\t ]+")[[1]]

    if(endhead == max.row){
            warning(paste("Empty file",name,"not included"))
            return(NULL)
    } else {
        table <- read.table(name,row.names=NULL, na.strings=na.strings, skip=endhead, nrows=max.row-endhead , col.names=cols, colClasses=colClasses)
         table[is.na(table)]=NaN     #mark NaNs to be distinguished from NAs        
        ind <- wasim.assemble.date(table)
        

        if(length(col.names)==length(cols)){
               cols=col.names
        }
        
        t.data <- as.matrix(table)[,5:col.count]
        dimnames(t.data) <- list(paste("r",1:NROW(t.data),sep=""), col.names[5:col.count])
        drop.all.na <- which(colSums(is.na(t.data))==NROW(t.data))
        if(length(drop.all.na)>0){
           warning( paste("Removing stations from",name,"with NA values only:", paste(names(drop.all.na), collapse=",")))
           t.data <- t.data[,-drop.all.na]
        }
    }

    z.data <- zoo(order.by=ind, x=t.data)
     attr(z.data, "head") <- head

    return(z.data)

}
