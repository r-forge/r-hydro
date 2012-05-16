addVariable <- function(Code, Name, 
			Speciation=rep("Unknown", NROW(Code)), 
			Unit, 
			SampleMedium =rep("Unknown", NROW(Code)),
			ValueType=rep("Unknown", NROW(Code)),
			IsRegular=rep("True", NROW(Code)),
			TimeSupport=rep(0, NROW(Code)),
			TimeUnits=rep("Julian year", NROW(Code)),
			DataType=rep("Unknown", NROW(Code)),
			GeneralCategory=rep("Unknown", NROW(Code)),
			NoDataValue=rep(-999999, NROW(Code))
		       	){
	#Handle CV-Fields: VariableName, Speciation, SampleMedium, ValueType, DataType, GeneralCategory
	stopifnot(length(Name) == length(Code))
	VariableNameID <- getID("VariableName",Name)
	stopifnot(length(Speciation) == length(Code))
	SpeciationID <- getID("Speciation",Speciation)
	stopifnot(length(SampleMedium) == length(Code))
	SampleMediumID <- getID("SampleMedium",SampleMedium)
	stopifnot(length(ValueType) == length(Code))
	ValueTypeID <- getID("ValueType",ValueType)
	stopifnot(length(DataType) == length(Code))
	DataTypeID <- getID("DataType",DataType)
	stopifnot(length(GeneralCategory) == length(Code))
	GeneralCategoryID <- getID("GeneralCategory",GeneralCategory)
	#Other Fields with foreign key: VariableUnits, TimeUnits
	stopifnot(length(Unit) == length(Code))
	VariableUnitsID <- getID("Units",Unit)
	stopifnot(length(TimeUnits) == length(Code))
	TimeUnitsID <- getID("Units",TimeUnits)
	#Fields with no reference
	stopifnot(length(NoDataValue) == length(Code))
	stopifnot(length(IsRegular) == length(Code))
	stopifnot(length(TimeSupport) == length(Code))

	#check for existing entries
	if(NROW(existing <- getMetadata("Variable",Name=Name, Speciation = Speciation, SampleMedium=SampleMedium, ValueType=ValueType, DataType=DataType, GeneralCategory=GeneralCategory))>0){
		warning(paste("Skiping existing ISOMetadata entry:", Name))
		return()
	}


	IaddVariable(getOption("odm.handler"), Code=Code, Name=VariableNameID, Speciation=SpeciationID, Unit=VariableUnitsID, SampleMedium=SampleMediumID,ValueType=ValueTypeID, IsRegular=IsRegular, TimeSupport=TimeSupport, TimeUnits=TimeUnitsID, DataType=DataTypeID, GeneralCategory=GeneralCategoryID, NoDataValue=NoDataValue)


}
