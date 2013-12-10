wasim.read.ModelParameters <- function(file){

  content <- scan(file, what="character",
                   sep="\n",blank.lines.skip=TRUE,
                   comment.char="#",strip.white=TRUE,quiet=TRUE)
  
  par.list <- list()
  block.start <- c(grep("\\[", content), length(content))  #find section headers
                                           #and add last element
  
  for(i in 1:(length(block.start)-1)){
        par.list[[ content[ block.start[i] ] ]] <-
             content[ (block.start[i]+1):(block.start[i+1]-1) ]
  }
  return(par.list)
}
