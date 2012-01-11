context("various")
test_that("no duplicates are generated from multiple calls", {
	#Setup
	example(addDataValues)
	  #count records
	c.variable <- NROW(getMetadata("Variable"))
	c.site <- NROW(getMetadata("Site"))
	c.meta <- NROW(getMetadata("ISOMetadata"))
	c.source <- NROW(getMetadata("Source"))
	c.data <- NROW(getDataValues()$Values)
	browser()
	  #second call
	example(addDataValues)
	#Confirmations
	expect_that(1, equals(1))
	expect_that(1:10, is_equivalent_to(1:10))
		})



test_that("", {
	#Setup

	#Confirmations
	expect_that(1, equals(1))
	expect_that(1:10, is_equivalent_to(1:10))
		})
