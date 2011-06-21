plot_rainfall.runoff <- function(rain, q.model, q.measured=NULL,
myColors=data.frame(measured=c("grey"), modelled=c("black"), rain=c("black")),
q.units="mm/h", p.units="mm/h", mar=c(3,4,2,4)+0.1, cex.rain=1, ...){
    data.count <- 3
    theXRange <- NA
    theQRange <- NA
    max.rain <- NA
    if(!is.null(rain)){
        if(class(rain) != "zoo") stop("rain must be object of class zoo")
        max.rain <- max(rain, na.rm=TRUE)
    } else {
        data.count <- data.count - 1
    }
    if(!is.null(q.measured)){
        if(class(q.measured) != "zoo") stop("q.model must be object of class zoo")
        theXRange <- range(index(q.measured), na.rm=TRUE)
        theQRange <- range(q.measured, na.rm=TRUE)
    } else {
        data.count <- data.count - 1
    }
    if(!is.null(q.model)){
        if(class(q.model) != "zoo") stop("q.measured must be object of class zoo")
        if(all(is.na(theXRange))){
             theXRange <- range(index(q.model), na.rm=TRUE)
        } else {
             theXRange <- range(c(theXRange, index(q.model)), na.rm=TRUE)
        }
        if(all(is.na(theQRange))){
                theQRange <- range(q.model, na.rm=TRUE)
        } else {
                theQRange <- range(c(theQRange,q.model), na.rm=TRUE)
        }

    } else {
        data.count <- data.count - 1
    }
    if(data.count==0) return()
    par(mar=mar)
    if(all(is.na(theQRange))){ #no discharge to plot
        #rain must exist (because data.count >0)
        plot(index(rain), c(0,max.rain), type="n",xlab="time", ylab=paste("preciptiation", p.units))
        show.rain.axis=FALSE
    } else {
        plot(theXRange, theQRange, type="n",xlab="time", ylab=paste("discharge", q.units),...)
        if(!is.null(q.model)){
            for(i in 1:NCOL(q.model)){
                lines(index(q.model), q.model[,i],col=as.character(myColors$modelled))
            }
        }
        if(!is.null(q.measured)){
            for(i in 1:NCOL(q.measured)){
                lines(index(q.measured), q.measured[,i],col=as.character(myColors$measured))
            }
        }
        if(!is.na(max.rain)){  #set range for rain
                plot.window(range(index(q.model)), c(2*max.rain,0))
                show.rain.axis=TRUE
        }
    }
    if(!is.na(max.rain)){ #output rain
        if(NCOL(rain)!=1) warning("NCOL(rain)!=1. Different rainfall series hard to distinguish")
        for(i in 1:NCOL(rain)){
             lines(index(rain), rain[,i], type="h",col=as.character(myColors$rain))
        }
        if(show.rain.axis){
            axis(4)
            mtext(side=4, line=2, paste("preciptiation", p.units), cex=cex.rain)
        }
    }
    legend("topright", inset=0.1, c("measured","modell"), lty=1, col=c(as.character(myColors$measured),as.character(myColors$modelled)))
}
