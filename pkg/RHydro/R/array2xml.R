array2xml <- function(date,time,idata,string) {

   # transform an input array into a xml document based on a fixed tree
   # idata = data for generating XML
   # string = file path for saving save 

   #library(XML)
   # from the package documentation:
   b = newXMLNode("element")
   saveXML(b)
   f = tempfile()
   saveXML(b, f)
   doc = xmlInternalTreeParse(f)
   saveXML(doc)
   con <- xmlOutputDOM()
   
   j<-1
   odata <- rep(NA,6*length(idata)-1)
   for (i in 1:length(idata)) {
      odata[j]<-as.character(date[i,1])    #date
      j <- j+1
      odata[j] <- " "     #space
      j <- j+1
      odata[j]<-as.character(time[i,1])    #time
      j <- j+1
      odata[j] <- " "     #space
      j <- j+1
      odata[j]<-idata[i]  #value
      j <- j+1
      odata[j]<-","       #comma
      j <- j+1
   }
   
   con$addTag("values", odata)
   
   saveXML(con$value(), file = string)

}
