addDataValues <- function(DataZoo=NULL, Date=NULL, Value=NULL, ValueAccuracy=rep(NA, NCOL(DataZoo)), Site, Variable, Offset=rep(NA, NCOL(DataZoo)), OffsetType=rep('No', NCOL(DataZoo)), CensorCode = rep("nc", NCOL(DataZoo)), Qualifier=rep("No", NCOL(DataZoo)), Method=rep('No', NCOL(DataZoo)), Source, Sample=rep("No", NCOL(DataZoo)), DerivedFrom=NULL, QualityControlLevel, tolerance=0){
	#mandatory: DataValue,  Site, Variable, CensorCode, Method, Source, QualityControlLevel



	todo("UnitConversion")
	if(is.null(DataZoo) & (is.null(Date) | is.null(Value))) stop("You must provide information either as DataZoo or Date and Value")
	if(!is.null(Value)){
		stopifnot(is.numeric(Value))
	}

	if(is.null(Date)) Date <- index(DataZoo)
	stopifnot("POSIXt" %in%  class(Date))
	if(NROW(Date)==1){Date <- rep(Date, NROW(Value))}
	if(is.null(Value)) Value <- coredata(DataZoo)
	if(is.null(dim(Value))) dim(Value)  <-  c(NROW(Value),NCOL(Value) )

	if(is.null(DataZoo)) DataZoo <- xts(Value, order.by=Date)

	


	#check variables with foreign keys
	SiteID <- expandVar(Site, nrow=NROW(Value), ncol=NCOL(Value), checkID=TRUE, table="Site")
	VariableID <- expandVar(Variable, nrow=NROW(Value), ncol=NCOL(Value), checkID=TRUE, table="Variable")
	OffsetTypeID <- expandVar(OffsetType, nrow=NROW(Value), ncol=NCOL(Value), checkID=TRUE, table="OffsetType")
	QualifierID <- expandVar(Qualifier, nrow=NROW(Value), ncol=NCOL(Value), checkID=TRUE, table="Qualifier")
	MethodID <- expandVar(Method, nrow=NROW(Value), ncol=NCOL(Value), checkID=TRUE, table="Method")
	CensorCodeNum <- expandVar(CensorCode, nrow=NROW(Value), ncol=NCOL(Value), checkID=TRUE, table="CensorCode")
	SourceID <- expandVar(Source, nrow=NROW(Value), ncol=NCOL(Value), checkID=TRUE, table="Source")
	SampleID <- expandVar(Sample, nrow=NROW(Value), ncol=NCOL(Value), checkID=TRUE, table="Sample")
	QualityControlLevelID <- expandVar(QualityControlLevel, nrow=NROW(Value), ncol=NCOL(Value), checkID=TRUE, table="QualityControlLevel")

	#Adjust Dimension for Values without foreign key
	Offset <- expandVar(Offset, nrow=NROW(Value), ncol=NCOL(Value))
	# expandVar does not work for POSIX
	#Date <- expandVar(Date, nrow=NROW(Value), ncol=NCOL(Value))
	ValueAccuracy <- expandVar(ValueAccuracy, nrow=NROW(Value), ncol=NCOL(Value))

	time.range <- range(Date)
	
	for(column in 1:NCOL(Value)){
		cat("Importing column ", column, "out of", NCOL(Value), "\n")
		#check for existing entries
		database.entries  <- NULL
		todo("add ValueAccuracy")
		database.entries <- getDataValues(from=time.range[1], to=time.range[2], Site=unique(SiteID[,column]), Variable=unique(VariableID[,column]), Offset=unique(Offset[,column]), OffsetType=unique(OffsetTypeID[,column]), CensorCode=unique(CensorCodeNum[,column]), Qualifier=unique(QualifierID[,column]), Method=unique(MethodID[,column]), Source=unique(SourceID[,column]), Sample=unique(SampleID[,column]),QualityControlLevel=unique(QualityControlLevelID[,column]), show.deleted=TRUE)
		if(NROW(database.entries)>0){
			to.test <- merge(database.entries@values, DataZoo[,column])
			names(to.test) <- c("inDatabase", "toImport")
			if(any(different <- abs(to.test$inDatabase - to.test$toImport) > tolerance, na.rm=TRUE)){
				if(interactive()){
					plot.zoo(to.test$inDatabase, col="green", main=paste("Import of column", column), ylim=range(coredata(to.test)))
					points(to.test$toImport[different], col="red")
					legend("top", c("database records", "differing (to import)"), col=c("green", "red"), lty=c(1,NA), pch=c(NA,1))
					cat("Data to import is not matching data in database for", sum(different, na.rm=TRUE), "values (See plot)\nWhat shall I do?\n  1) Dischard data to import and import remaining, missing data\n  2) Overwrite values in database with new values\n  0) Stop and let you modify the data to import before another attempt\nEnter a number (0-2) for your choise.\n")
					choice <- "impossible"
					attempts <- 0
					if(!interactive()) {
						choice=1
						warning("non-interactive session. Not replacing data in database")
					}
					while(choice == "impossible"){
						next.step <- readline("What is your choice? ")
						choice <- switch(next.step, "1"=1,"2"=2,"0"=0, "impossible")
						attempts <- attempts + 1
						if(attempts == 10) choice <- 0
					} 
				} else {
					 choice <- 1 #Don't change too much
				}

				if(choice==0){
					cat("returning a xts object with the data in the database and the data to be imported\n")
					return(to.test)
				} else if (choice==2){
					to.update <- database.entries
					database.entries@values[different] <- to.test$toImport[different]
					updateDataValues(database.entries[different], paste("Replacement upon import on", date()))
				}
				#nothing to do for choice 1 because is.na(different) is false for differing values, so data will not be importet


				
			}
			the.missing <- is.na(different)
			do.import <- !is.na(to.test$toImport) & the.missing
			to.import <- to.test$toImport[do.import]
		} else {
			to.import <- Value[,column]
			do.import <- rep(TRUE, NROW(Value))
		}
		if(any(do.import)){
			IaddDataValues(getOption("odm.handler"),localDateTime=Date[do.import], values=to.import, TZ=strftime(Date, "%z")[do.import], SiteID=SiteID[do.import,column], VariableID=VariableID[do.import,column], Offset=Offset[do.import,column], OffsetTypeID=OffsetTypeID[do.import,column], CensorCode=CensorCodeNum[do.import], QualifierID=QualifierID[do.import,column], MethodID=MethodID[do.import,column], SourceID=SourceID[do.import,column], SampleID=SampleID[do.import,column],QualityControlLevelID=QualityControlLevelID[do.import,column], valueAccuracy=ValueAccuracy[do.import,column])
		}
		#import data
	}



}
