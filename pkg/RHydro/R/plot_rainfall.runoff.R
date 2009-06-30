plot_rainfall.runoff <- function(rain, q.model, q.measured=NULL,
q.units="mm/h", p.units="mm/h", mar=c(3,4,2,4)+0.1, ...){
    if(class(rain) != "zoo") stop("rain must be object of class zoo")
    if(class(q.model) != "zoo") stop("q.model must be object of class zoo")
    if(!is.null(q.measured)){
        if(class(q.measured) != "zoo") stop("q.measured must be object of class zoo")
    }
    par(mar=mar)
    plot(q.model, plot.type="single",col="blue",xlab="time", ylab=paste("discharge", q.units),...)
    if(!is.null(q.measured)){
        for(i in 1:NCOL(q.measured)){
            lines(index(q.measured), q.measured[,i])
        }
    }
    plot.window(range(index(q.model)), c(2*max(rain),0))
    if(NCOL(rain)!=1) warning("NCOL(rain)!=1. Different rainfall series hard to distinguish")
    for(i in 1:NCOL(rain)){
         lines(index(rain), rain[,i], type="h")
    }
    axis(4)
    mtext(side=4, line=2, paste("preciptiation", p.units))
    legend("topright", inset=0.1, c("measured","modell"), lty=1, col=c("black","blue"))
}
