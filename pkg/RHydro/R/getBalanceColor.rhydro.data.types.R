getBalanceColor.rhydro.data.types <- function(data.type, balance.type){
     #watch out. sorting is used implicitly
     selected.rows <- rhydro.data.types$balance.type[rhydro.data.types$data.type %in% data.type]
     color <- sapply(selected.rows, FUN <- function(x){
               entries <- strsplit(x, ", *")[[1]]
               thematch <-  grep(balance.type, entries, value=TRUE)
               col <- sub(".*\\((.*)\\)", "\\1", thematch)
               if(col==thematch) col <- NA
               return(col)
     })
     if(any(is.na(color))){
         if(any(!is.na(color))){
              stop(paste("Please define either none or all colors for balance type '", balance.type, "'", sep=""))
         }
         color <- 1:length(color)
     }
     return(color)
}
