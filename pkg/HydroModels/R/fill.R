# fill gaps in a time series
fill = function(indat) {
  idx = which(is.na(indat))
  outdat = indat
  outdat[idx] = approx(1:length(indat),indat,xout=idx)$y
  cat(paste(length(idx),'out of',length(indat),'filled.\n'))
  return(outdat)
}

