run.sql.script <- function(con, script.file){

	script  <- readLines(script.file)
	script <- gsub("--.*", "", script)
	script <- gsub("\t", "", script)
	script <- paste(script, collapse=" ")
	scriptparts <- strsplit(script, ";")[[1]]

	for(i in seq(along=scriptparts)){
	  statement <- gsub("COMMENT.'[^']*'", "",scriptparts[i] )
	  if(class(con)=="SQLiteConnection"){
		statement <- gsub("ENGINE.*", "",statement )
		statementa <- gsub("int\\(11\\)  NOT NULL auto_increment", "INTEGER PRIMARY KEY",statement)
		if(statementa != statement){
			statement <- gsub(", *PRIMARY KEY *\\([^)]*\\)","",statementa)
		}
	  }
	  tablename <- gsub("CREATE TABLE *([[:alpha:]]+).* ","\\1",statement)
	  tablename <- gsub("[[:space:]]*", "", tablename)
	  if(!dbExistsTable(con, tablename)){
		  if(getOption("verbose.queries", default=FALSE)) print(statement)
		  rs1 <- dbSendQuery(con, statement) 
	  }
	}

}
