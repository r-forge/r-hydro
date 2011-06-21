addVariable <- function(Code, Name, 
			Speciation=rep("No", NROW(Code)), 
			Unit, 
			SampleMedium =rep("No", NROW(Code)),
			ValueType=rep("No", NROW(Code)),
			IsRegular=rep("True", NROW(Code)),
			TimeSupport=rep(1, NROW(Code)),
			TimeUnits=rep("year", NROW(Code)),
			DataType=rep("No", NROW(Code)),
			GeneralCategory=rep("No", NROW(Code)),
			NoDataValue=rep("Null", NROW(Code))
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
	todo("check for existing variables")
	IaddVariable(getOption("odm.handler"), Code=Code, Name=VariableNameID, Speciation=SpeciationID, Unit=VariableUnitsID, SampleMedium=SampleMediumID,ValueType=ValueTypeID, IsRegular=IsRegular, TimeSupport=TimeSupport, TimeUnits=TimeUnitsID, DataType=DataTypeID, GeneralCategory=GeneralCategoryID, NoDataValue=NoDataValue)


}
