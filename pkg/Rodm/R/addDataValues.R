addDataValues <- function(DataZoo=NULL, Date=NULL, Value=NULL, ValueAccuracy=rep(NA, NCOL(DataZoo)), Site, Variable, Offset=rep(NA, NCOL(DataZoo)), OffsetType=rep('No', NCOL(DataZoo)), CensorCode = rep("nc", NCOL(DataZoo)), Qualifier=rep(NA, NCOL(DataZoo)), Method=rep(0, NCOL(DataZoo)), Source, Sample=rep("No", NCOL(DataZoo)), DerivedFrom=NULL, QualityControlLevel, tolerance=0){
	#mandatory: DataValue,  Site, Variable, CensorCode, Method, Source, QualityControlLevel

	todo("UnitConversion")
	if(is.null(DataZoo) & (is.null(Date) | is.null(Value))) stop("You must provide information either as DataZoo or Date and Value")

	if(is.null(Date)) Date <- index(DataZoo)
	stopifnot("POSIXt" %in%  class(Date))
	if(NROW(Date)==1){Date <- rep(Date, NROW(Value))}
	if(is.null(Value)) Value <- coredata(DataZoo)
	if(is.null(dim(Value))) dim(Value)  <-  c(NROW(Value),NCOL(Value) )

	


	#check variables with foreign keys
	SiteID <- expandVar(Site, nrow=NROW(Value), ncol=NCOL(Value), checkID=TRUE, table="Site")
	VariableID <- expandVar(Variable, nrow=NROW(Value), ncol=NCOL(Value), checkID=TRUE, table="Variable")
	stopifnot(length(Offset)==NCOL(Value))
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
	
	for(column in NCOL(Value)){
		#check for existing entries
		todo("reactivate check of existing entries with column restrictions")
		database.entries  <- NULL
		todo("add ValueAccuracy")
		#database.entries <- getDataValues(from=time.range[1], to=time.range[2], SiteID=SiteID[,column], VariableID=VariableID[,column], Offset=Offset[,column], OffsetTypeID=OffsetTypeID[,column], CensorCode=CensorCode, QualifierID=QualifierID[,column], MethodID=MethodID[,column], SourceID=SourceID[,column], SampleID=SampleID[,column],QualityControlLevelID=QualityControlLevelID[,column])
		if(NROW(database.entries)>0){
			#to.test <- merge(database.entries$DataValue, Value[,column])
			to.test <- merge(zoo(as.numeric(coredata(database.entries$num$DataValue)),order.by=index(database.entries$num)), Value[,column])
			names(to.test) <- c("inDatabase", "toImport")
			if(any(different <- abs(to.test$inDatabase - to.test$toImport) > tolerance, na.rm=TRUE)){
				plot(to.test$inDatabase[!different], col="green")
				points(to.test$toImport[different], col="red")
				legend("top", c("matching data", "differing (to import)"), col=c("green", "red"), lty=c(1,NA), pch=c(NA,1))
				cat("Data to import is not matching data in database for", sum(different, na.rm=TRUE), "values (See plot)\nWhat shall I do?\n  1) Dischard data to import and import remaining, missing data\n  2) Overwrite values in database with new values\n  3) Stop and let you modify the data to import before another attempt\nEnter a number (1-3) for your choise.\n")
				choice <- "impossible"
				while(choice == "impossible"){
					next.step <- readline("What is your choice? ")
					choice <- switch(next.step, "1"=1,"2"=2,"3"=3, "impossible")
				} 

				if(choice==3){
					cat("returning a zoo object with the data in the database and the data to be imported\n")
					return(to.test)
				} else if (choice==2){
					todo("Implement updating")
					browser()
				}
				#nothing to do for choice 1 because is.na(different) is false for differing values, so data will not be importet


				
			}
			the.missing <- is.na(different)
			do.import <- !is.na(to.test$toImport) & the.missing
			to.import <- to.test$toImport[do.import]
		} else {
			to.import <- Value[,column]
		}
		IaddDataValues(getOption("odm.handler"),localDateTime=Date, values=to.import, TZ=strftime(Date, "%z"), SiteID=SiteID[,column], VariableID=VariableID[,column], Offset=Offset[,column], OffsetTypeID=OffsetTypeID[,column], CensorCode=CensorCode, QualifierID=QualifierID[,column], MethodID=MethodID[,column], SourceID=SourceID[,column], SampleID=SampleID[,column],QualityControlLevelID=QualityControlLevelID[,column], valueAccuracy=ValueAccuracy[,column])
		#import data
	}



}
