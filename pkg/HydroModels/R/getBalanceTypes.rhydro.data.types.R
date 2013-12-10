getBalanceTypes.rhydro.data.types <- function(){
        #remove color definitions
        data.types <-  gsub(" *\\([^)]*\\)", "", rhydro.data.types$balance.type)
        toRet <- strsplit(data.types, ", *")
        return(toRet)
}
