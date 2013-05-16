`remove_plateaus` <-
function(runoff){
    able <- diff(runoff)
    actionTime<-able!=0 & !is.na(able)
    first<-min(which(!is.na(runoff)))
    xval<-c(first,which(actionTime)+1)
    #Ansteige beginnen zu fr<c3><bc>h deshalb wechsel von neg. auf pos. Steigung suchen
    wechselZuAnstieg<-diff(sign(able[actionTime]))==2
    eventAnfang <- which(actionTime)[c(FALSE,wechselZuAnstieg)]
    #take together the times with data changes and event starts and order data
    xval.new<- c(eventAnfang,xval)[order(c(eventAnfang,xval))]
    interp<-approx(xval.new, runoff[xval.new], xout=(1:(NROW(runoff)-1)),  method="linear", ties="ordered")
    interp <- interp$y
    interp[is.na(runoff)] <- NA
    return(interp)
}

