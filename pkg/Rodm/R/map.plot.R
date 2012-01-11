map.plot <- function(data, col.names=names(data), print.plot=TRUE, colors=colorRampPalette(c("yellow","yellowgreen","springgreen","turquoise3","mediumblue"),space="rgb")(200), ...){
	
	stopifnot(class(data)!="data.frame")
	stopifnot("FIPS" %in% names(data))

	world<-readShapePoly(gsub("\\.shp","",system.file("world_simplified2.shp", package="RODM")))
	world$order <- 1:NROW(world)
	merge.data<-merge(data, world, by="FIPS",all = TRUE)   # merges two tables by field
	merge.data <- merge.data[order(merge.data$order),]
	attr1=data.frame(merge.data, row.names=0:197) 
	SrDf1 = SpatialPolygonsDataFrame(world, attr1)
	p1<-spplot(SrDf1, col.names,main=list(label=col.names,cex=1), col.regions=colors, col="darkgrey", lwd=0.1, cuts=20, ...)
	if(print.plot) print(p1)
	return(p1)
}
