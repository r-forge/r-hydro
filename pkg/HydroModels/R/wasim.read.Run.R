wasim.read.Run <- function(files){
   fileNr <- 1
   all.data <- new("HydroRun")

   #ToDo: wasim.read.ModelParameters should return HydroWasimParameters!
   parameters <- new("HydroWasimParameters", parameters=data.frame(1) )
   for(file in files){
       pars <- wasim.read.ModelParameters(file)

       my.ts <- new("HydroRun")
       #ToDo convert parameters into usefull HydroWasimParameters
       #Get header information for generated series
       data.file <- pars[["[routing_model]"]][5]
       header.ts <- wasim.file2HydroRun(file=paste(dirname(file),
data.file, sep="/"),
               units="bla",
               parameter.name="discharge")
       #Read Data
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
       #set parameters and run number at the end (otherwise we don't know how to merge)
       my.ts@parameters <- parameters
       my.ts@metadata$param.ID <- 1
       my.ts@metadata$run.ID <- fileNr
       all.data <- merge(all.data,my.ts)

       #ToDo implement all-List entry for shared data
       fileNr <- fileNr + 1
   }
   all.data@call <- match.call()
   return(all.data)
}
