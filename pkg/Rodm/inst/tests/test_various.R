context("various")
#testPostgreSQL <- testMySQL <- TRUE
#testPostgreSQL  <- FALSE
#testMySQL  <- FALSE
testPostgreSQL <- testMySQL <- FALSE

cleanupMySQL <- function(){
		for(i in 1:6){
			try(dbGetQuery(con, "DROP TABLE if exists DataValues, DataValuesRepository;"), silent=TRUE)
			try( dbGetQuery(con, "DROP TABLE if exists `Categories`,  `DerivedFrom`, `GeneralCategoryCV`, `GroupDescriptions`, `Groups`, `ISOMetadata`, `LabMethods`, `Methods`, `ODMVersion`, `OffsetTypes`, `Qualifiers`, `QualityControlLevels`, `SampleMediumCV`, `Samples`, `SampleTypeCV`, `SeriesCatalog`, `Sites`, `Sources`, `SpatialReferences`, `SpeciationCV`, `TopicCategoryCV`, `Units`, `ValueTypeCV`, `VariableNameCV`, `Variables`, `Versions`, `VerticalDatumCV`, CensorCodeCV, DataTypeCV , DataValues, Synonyms;") , silent=TRUE)
		}
}
exampleCommands <- function(){
	try(getMetadata("Site"), silent=TRUE)
	addSite(Code="test", Name="Virtual test site", x=-5, y=46, LatLongDatum="WGS84", Elevation=1500, State="Germany")
	addVariable(Name="Distance", Unit="cm", ValueType="Field Observation", GeneralCategory="Instrumentation", Code="test_dist")
	addQualityControlLevel(ID=6,Code="ok", Definition="The default")

	addISOMetadata(TopicCategory="Unknown", Title="Testdata", Abstract="This data is created to test the functions of RObsDat")
	addSource(Organization="Your Org", SourceDescription="Madeup data", SourceLink="RObsDat Documentation", ContactName="Yourself", Metadata="Testdata")

	example.data <- xts(1:366, seq(as.POSIXct("2010-01-01", tz="UTC"), as.POSIXct("2011-01-01", tz="UTC"), length.out=366))
	example.data[50] <- 100
	example.data[200] <- 40

	addDataValues(example.data[1:100], Site="test", Variable="test_dist",  Source="Madeup", QualityControlLevel="ok")
	#Avoid duplicates autmatically
	addDataValues(example.data, Site="test", Variable="test_dist",  Source="Madeup", QualityControlLevel="ok")
	inDB <- getDataValues(Site=getID("Site","test"))
	plot(inDB)

	#Version management
	to.correct <- which(inDB@values < 100 & index(inDB@values) > as.POSIXct("2010-06-01"))
	inDB@values[to.correct] <- 200
	inDB@values[50] <- 50

	updateDataValues(inDB, "Correction of wrong value")

	ver2 <- inDB
	ver2@values[50:60] <- 90
	updateDataValues(ver2, "Changing more data")

	ver3 <- inDB
	ver3@values[50:60] <- 190
	updateDataValues(ver3, "Ups, I used 90 instead of 190 by mistake")

	to.delete <- inDB@values == 250
	if(any(to.delete)){
		deleteDataValues(inDB[to.delete],  "And finally remove a value")
	}

	getDataVersions()

	versionQuery <- getDataValues(Site=1, VersionID=1)

	plot(versionQuery)
	versionQuery <- getDataValues(Site=1, VersionID=2)
	plot(versionQuery)

}

test_that("NA data does not produce an error", {
	example(addDataValues)
	example.data <- xts(c(5,6,NA), seq(as.POSIXct("2012-01-01", tz="UTC"), as.POSIXct("2013-01-01", tz="UTC"), length.out=3))
	addDataValues(example.data, Site="test", Variable="test_dist",  Source="Madeup", QualityControlLevel="ok")
	})


test_that("multicolumn import works correctly with timeseries", {
	unlink("RODM.db")
	example(addDataValues)
	example.data <- xts(data.frame(a=1:3, b=4:6), seq(as.POSIXct("2012-01-01", tz="UTC"), as.POSIXct("2013-01-01", tz="UTC"), length.out=3))
	
	addVariable(Name="Distance", Unit="cm", ValueType="Field Observation", GeneralCategory="Instrumentation", Code="test_dist_2")
	addVariable(Name="Distance", Unit="cm", ValueType="Field Observation", GeneralCategory="Instrumentation", Code="test_dist_3")

	addDataValues(example.data, Site="test", Variable=c("test_dist_2", "test_dist_3"),  Source="Madeup", QualityControlLevel="ok")

	inDB <- getDataMatrix(variables=c("test_dist_2", "test_dist_3"), select.time=index(example.data))
	expect_that(inDB$data[1,1,], is_equivalent_to(coredata(example.data)[,1]))
	expect_that(inDB$data[1,2,], is_equivalent_to(coredata(example.data)[,2]))
	unlink("RODM.db")

	})

test_that("multicolumn import works correctly with multi variable, multi site data", {
	example(addDataValues)
	example.data <- data.frame(a=1:3, b=4:6)

	
	addVariable(Code="test_dist_2", Name="Distance", Unit="cm", ValueType="Field Observation", GeneralCategory="Instrumentation")
	addVariable(Name="Distance", Unit="cm", ValueType="Field Observation", GeneralCategory="Instrumentation", Code="test_dist_3")

	addSite(Code="test_2", Name="Virtual test site 2", x=-5, y=46, LatLongDatum="WGS84", Elevation=1500, State="Germany")
	addSite(Code="test_3", Name="Virtual test site 3", x=-5, y=46, LatLongDatum="WGS84", Elevation=1500, State="Germany")

	addDataValues(Date=as.POSIXct("2012-01-01", tz="UTC"), Value=example.data, Site=c("test","test_2","test_3"), Variable=c("test_dist_2", "test_dist_3"),  Source="Madeup", QualityControlLevel="ok")


	#let's fail if too many entries in database
	options(warn=2)
	inDB <- getDataMatrix(variables=c("test_dist_2", "test_dist_3"), select.time=as.POSIXct("2012-01-01", tz="UTC"))
	options(warn=1)
	expect_that(inDB[,1], equals(example.data[,1]))
	expect_that(inDB[,2], equals(example.data[,2]))
	unlink("RODM.db")

	})


test_that("no duplicates are generated from multiple calls", {
	#Setup
	unlink("RODM.db")
	example(addDataValues)
	  #count records
	c.variable <- NROW(getMetadata("Variable"))
	c.site <- NROW(getMetadata("Site"))
	c.meta <- NROW(getMetadata("ISOMetadata"))
	c.source <- NROW(getMetadata("Source"))
	c.data <- NROW(getDataValues()@values)
	  #second call
	exampleCommands()
	#example(addDataValues)
	#Confirmations
	expect_that(c.variable, equals(NROW(getMetadata("Variable"))))
	expect_that(c.site, equals(NROW(getMetadata("Site"))))
	expect_that(c.meta, equals(NROW(getMetadata("ISOMetadata"))))
	expect_that(c.source, equals(NROW(getMetadata("Source"))))
	#ToDo: check why one is missing.
	expect_that(c.data, equals(NROW(getDataValues()@values)))
		})

test_that("Duplicates in dataset to import are detected", {
	example(addDataValues)
	example.data4 <- cbind(101:109)
	addVariable(Name="Water depth", Unit="cm", ValueType="Field Observation", GeneralCategory="Instrumentation", Code="test_height")

	date.data4 <- seq(as.POSIXct("2011-02-02", tz="UTC"), as.POSIXct("2012-01-01", tz="UTC"), length.out=3)
	expect_error(addDataValues(Value=example.data4, Date=rep(date.data4, 3), Site="test", Variable=rep(c("test_height", "test_dist", "test_height"), each=3),  Source="Madeup", QualityControlLevel="ok"))


		})

test_that("Multicolumn-Data can be imported", {
	example(addDataValues)
	addVariable(Name="Water depth", Unit="cm", ValueType="Field Observation", GeneralCategory="Instrumentation", Code="test_height")
	example.data2 <- xts(2001:2366, seq(as.POSIXct("2010-01-01", tz="UTC"), as.POSIXct("2011-01-01", tz="UTC"), length.out=366))
	addDataValues(example.data2, Site="test", Variable="test_height",  Source="Madeup", QualityControlLevel="ok")

	example.data3 <- xts(cbind(1:10,11:20), seq(as.POSIXct("2011-01-02", tz="UTC"), as.POSIXct("2012-01-01", tz="UTC"), length.out=10))
	addDataValues(example.data3, Site="test", Variable=c("test_height", "test_dist"),  Source="Madeup", QualityControlLevel="ok")


	#Worldbank example
	example.data4 <- cbind(101:120)
	date.data4 <- seq(as.POSIXct("2011-02-02", tz="UTC"), as.POSIXct("2012-01-01", tz="UTC"), length.out=10)
	addDataValues(Value=example.data4, Date=c(date.data4, date.data4), Site="test", Variable=rep(c("test_height", "test_dist"), each=10),  Source="Madeup", QualityControlLevel="ok")


		})
test_that("Download of QUASHI vocabulary works", {
	#Setup
	try(getMetadata("Site"))
	getMetadata("Site")
	unit.meta <- getMetadata("Units")
	

	#Confirmations
	expect_that(NROW(unit.meta)>200, equals(TRUE))
		})
test_that("postgreSQL works", {
	#Setup
        if(testPostgreSQL){
		require("RObsDat")
		require("RPostgreSQL")
		m <- dbDriver("PostgreSQL")
		con <- dbConnect(m, user="reusser", password="4nsp", dbname="obsdat_test", port="5433", host="localhost")
		sqhandler <-  new("odm1_1Ver", con=con)
		options(odm.handler=sqhandler)

		exampleCommands()

		dbGetQuery(con, "DROP SCHEMA public CASCADE;")
		dbGetQuery(con, "CREATE SCHEMA public ;")


		#Confirmations
	} else {
	expect_that(1, equals(1))
	}
		})
test_that("MySQL works", {
	#Setup
        if(testMySQL){
		require("RObsDat")
		require("RMySQL")
		m <- dbDriver("MySQL")
		con <- dbConnect(m, user="a_user", password="secret", dbname="obsdat_test")
		sqhandler <-  new("odm1_1Ver", con=con)
		options(odm.handler=sqhandler)


		exampleCommands()

		cleanupMySQL()



		#Confirmations
	} else {
	expect_that(1, equals(1))
	}
		})
test_that("CV table not working correctly with wrong arguments", {
	#Setup
	#oldwarn <- getOption("warn")
	#options(warn=2)
        expect_that(
		getMetadata(table = "VariableName", EXACT = TRUE, ID = 0),
		throws_error("Multiple datasets")
		)
	#must produce an error, not a warning
	#options(warn=oldwarn)

	#Confirmations
	#expect_that(1, equals(1))
	#expect_that(1:10, is_equivalent_to(1:10))
		})

test_that("", {
	#Setup

	#Confirmations
	expect_that(1, equals(1))
	expect_that(1:10, is_equivalent_to(1:10))
		})
