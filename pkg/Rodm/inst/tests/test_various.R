context("various")
#testPostgreSQL <- testMySQL <- TRUE
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
		con <- dbConnect(m, user="reusser", password="4nsp", dbname="obsdat_test")
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

test_that("", {
	#Setup

	#Confirmations
	expect_that(1, equals(1))
	expect_that(1:10, is_equivalent_to(1:10))
		})
