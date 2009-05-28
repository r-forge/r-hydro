wasim.read.ModelRun <- function(file, data.types=wasim.data.types){
   theCall <- paste("wasim.read.ModelRun(", deparse(substitute(file)),")", sep="")
   pars <- wasim.read.ModelParameters(file)
   my.ts <- list()
   for(i in 1:NROW(data.types)){
       data.types[i,]
       par.block <- pars[[ paste("[",data.types[i,"par_block"],"]",sep="") ]]

       data.file <- par.block[data.types[i,"block_position"]]
       data.file <- strsplit(data.file, "[ \t]+")[[1]][1] #remove additional stuff at end of the file
       cat("reading", data.file, "\n")
       #Datenreihen aufspalten und für RhydroModel-Objekt vorbereiten
       ts <- wasim.file2HydroTS(file=paste(dirname(file), data.file, sep="/"), data.types[i,"is_recorded"], data.types[i,"is_flux"], units= data.types[i,"units"], type=data.types[i,"type"])
       if(!is.null(ts)){
          my.ts <- append(my.ts,ts)
       } else {
          data.types <- data.types[,-i]
       }
   }
   measuredFluxes <- my.ts[data.types[,"is_recorded"] & data.types[,"is_flux"]]
   modelledFluxes <- my.ts[!data.types[,"is_recorded"] & data.types[,"is_flux"]]
   measuredStates <- my.ts[data.types[,"is_recorded"] & !data.types[,"is_flux"]]
   modelledStates <- my.ts[!data.types[,"is_recorded"] & !data.types[,"is_flux"]]
   toRet <- new("HydroModelRun", parameter=new("HydroWasimParameters", parameters=data.frame(1) ), 
                                modelledFluxes=modelledFluxes,
				modelledStates=modelledStates,
				measuredFluxes=measuredFluxes,
				measuredStates=measuredStates,
				call=theCall)
   return(toRet)
}
