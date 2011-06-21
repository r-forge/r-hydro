h.m <- function(object) #handler.message
	stop("Please define the RODM Handler using an appropriate database connection.\nFor example\n\n\tlibrary(RSQLite) \n\tm <- dbDriver('SQLite') \n\tcon <- dbConnect(m, dbname = 'odm2.db') \n\tsqhandler <-  new('odm1_1Ver', con=con) \n\toptions(odm.handler=sqhandler)\n")



