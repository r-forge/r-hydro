wasim.read.Run <- function(files){
   fileNr <- 1

   parameters <- new("HydroWasimParameters", parameters=data.frame(1) )
   for(file in files){
       pars <- wasim.read.ModelParameters(file)
       #ToDo convert parameters into usefull HydroWasimParameters
       #Get header information for generated series
       data.file <- pars[["[routing_model]"]][5]
       header.ts <- wasim.file2HydroRun(file=paste(dirname(file),
data.file, sep="/"),
               units="bla",
               parameter.name="discharge")
       #Read Data
       my.ts <- new("HydroRun")
       i <- 1
       while(i <= NROW(wasim.data.types)){
           par.block <- pars[[ paste("[",wasim.data.types[i,"par_block"],"]",sep="") ]]

           data.file <- par.block[wasim.data.types[i,"block_position"]]
           data.file <- strsplit(data.file, "[ \t]+")[[1]][1] #remove additional stuff at end of the file
           cat("reading", data.file, "\n")
           #Datenreihen aufspalten und für RhydroModel-Objekt vorbereiten
	   #ToDo als zoo
           ts <- wasim.file2HydroRun(file=paste(dirname(file), data.file, sep="/"),
                   origin=wasim.data.types[i,"origin"],
                   type=wasim.data.types[i,"type"],
                   units= wasim.data.types[i,"units"], 
                   generated.header.info=header.ts,
                   parameter.name=wasim.data.types[i,"parameter.name"])
           if(!is.null(ts)){
              my.ts <- merge(my.ts,ts, all=TRUE)
              i <- i+1
	      #ToDo collect meta-data
           } else {
              wasim.data.types <- wasim.data.types[-i,]
           }
       }
       #ToDo implement all-List entry for shared data
       #Find list entry symbols and sort ts.data according to ts-type
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
       }
       fileNr <- fileNr + 1
   }
   toRet <- new("HydroModelRun", parameters=parameters, 
                                modelledFluxes=ts.data[[3]],
				modelledStates=ts.data[[1]],
				measuredFluxes=ts.data[[4]],
				measuredStates=ts.data[[2]],
				call=match.call())
   return(toRet)
}
