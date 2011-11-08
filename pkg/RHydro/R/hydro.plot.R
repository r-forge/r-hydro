# plots precipitation and stream flow into one plot
#ToDo - make compatible with other R-Functions
hydro.plot = function(prec,flow,idxtime=NULL, idxtruth=NULL,xtime=NULL) {
  op = par( mar=1.*c(9,6,5,5))
  if(is.null(idxtime) ) idxtime =1:length(prec)
  if(is.null(idxtruth)) idxtruth=1:nrow(flow)
  matplot(xtime, flow[idxtime,idxtruth], type='l', lty='solid', 
    xlab='time step', ylab='flow (mm/d)', main='Precipitation and synthetic stream flow', col=colors()[1:length(idxtruth)])
  par(new=T)
  plot(-prec[idxtime],type='h', axes=F, col='darkgrey', lwd=3, xlab='', ylab='')
  axis(side=4)
  mtext('precipitation (mm)',side=4,line=2)
  par(op)
}

