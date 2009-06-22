wasim.read.ModelRun <- function(files){
   theCall <- paste("wasim.read.ModelRun(", deparse(substitute(file)),")", sep="")
   fileNr <- 1
   ts.data <- list()
   for(i in 1:4){
      ts.data[[i]] <- list()
      ts.data[[i]]$runs <- list()
      ts.data[[i]]$shared <- list()
   }
   parameters <- new("HydroWasimParameters", parameters=data.frame(1) )
   for(file in files){
       pars <- wasim.read.ModelParameters(file)
       #ToDo convert parameters into usefull HydroWasimParameters
       #Get header information for generated series
       data.file <- pars[["[routing_model]"]][5]
       header.ts <- wasim.file2HydroTS(file=paste(dirname(file),
data.file, sep="/"),
               is_flux=TRUE,
               is_recorded=TRUE,
               units="bla",
               type="discharge")
       #Read Data
       my.ts <- list()
       i <- 1
       while(i <= NROW(wasim.data.types)){
           par.block <- pars[[ paste("[",wasim.data.types[i,"par_block"],"]",sep="") ]]

           data.file <- par.block[wasim.data.types[i,"block_position"]]
           data.file <- strsplit(data.file, "[ \t]+")[[1]][1] #remove additional stuff at end of the file
           cat("reading", data.file, "\n")
           #Datenreihen aufspalten und für RhydroModel-Objekt vorbereiten
           ts <- wasim.file2HydroTS(file=paste(dirname(file), data.file, sep="/"),
                   is_recorded=wasim.data.types[i,"is_recorded"],
                   is_flux=wasim.data.types[i,"is_flux"],
                   units= wasim.data.types[i,"units"], 
                   generated.header.info=header.ts,
                   type=wasim.data.types[i,"type"])
           if(!is.null(ts)){
              my.ts <- append(my.ts,ts)
              i <- i+1
           } else {
              wasim.data.types <- wasim.data.types[-i,]
           }
       }
       #ToDo implement all-List entry for shared data
       #Find list entry symbols and sort ts.data according to ts-type
       for(slot in 1:4){
           ts.data[[slot]]$runs[[fileNr]] <- list()
       }
       for(data.type in (i-1):1){
          dt <- which(my.ts[[data.type]]@type == rhydro.data.types$data.type)
          if(length(dt)==0){
             warning(paste("unrecognized data type", my.ts[[data.type]]@type, "You may redefine data.types to allow for advanced processing"))
             if(!exists("unknown")){
                  unknown <- 1
             }else{
                  unknown <- unknown + 1
             }
             symbol <- paste("unknwon", unknown, sep="")
          } else {
             symbol <- rhydro.data.types$symbol[dt]
          }
          slot <- 1 + wasim.data.types[data.type,"is_recorded"] + 2 * wasim.data.types[data.type,"is_flux"]
          if(!is.null(ts.data[[slot]][[symbol]])){
              stop(paste(rhydro.data.types$data.type[dt], "multiply defined"))
          }
          ts.data[[slot]]$runs[[fileNr]][[symbol]] <- my.ts[[data.type]]
       }
       fileNr <- fileNr + 1
   }
    slot <- 1 + wasim.data.types[i,"is_recorded"] + 2 * wasim.data.types[i,"is_flux"]
   toRet <- new("HydroModelRun", parameters=parameters, 
                                modelledFluxes=ts.data[[3]],
				modelledStates=ts.data[[1]],
				measuredFluxes=ts.data[[4]],
				measuredStates=ts.data[[2]],
				call=theCall)
   return(toRet)
}
