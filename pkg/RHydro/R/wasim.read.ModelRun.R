wasim.read.ModelRun <- function(files, data.types=wasim.data.types){
   theCall <- paste("wasim.read.ModelRun(", deparse(substitute(file)),")", sep="")
   fileNr <- 1
   measuredFluxes <- modelledFluxes <- measuredStates <- modelledStates <- list()
   for(file in files){
       pars <- wasim.read.ModelParameters(file)
       #ToDo convert parameters into usefull HydroWasimParameters
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
       #ToDo implement all-List entry for shared data
       #ToDo use data types
       measuredFluxes[[fileNr]] <- my.ts[data.types[,"is_recorded"] & data.types[,"is_flux"]]
       modelledFluxes[[fileNr]] <- my.ts[!data.types[,"is_recorded"] & data.types[,"is_flux"]]
       measuredStates[[fileNr]] <- my.ts[data.types[,"is_recorded"] & !data.types[,"is_flux"]]
       modelledStates[[fileNr]] <- my.ts[!data.types[,"is_recorded"] & !data.types[,"is_flux"]]
       fileNr <- fileNr + 1
   }
   toRet <- new("HydroModelRun", parameters=new("HydroWasimParameters", parameters=data.frame(1) ), 
                                modelledFluxes=modelledFluxes,
				modelledStates=modelledStates,
				measuredFluxes=measuredFluxes,
				measuredStates=measuredStates,
				call=theCall)
   return(toRet)
}
