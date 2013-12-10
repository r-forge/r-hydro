`remove_plateaus` <-
function(runoff, method="start"){
    able <- diff(runoff)
    if (method=="start")
    {  
      actionTime <- able!=0 & !is.na(able)   #index to periods of change (no plateaus)
      first<-min(which(!is.na(runoff)))      #index to first non-NA value
      xval<-c(first,which(actionTime)+1)     #first valid value and periods of change
      #Ansteige beginnen zu fr<c3><bc>h deshalb wechsel von neg. auf pos. Steigung suchen
      change2rising <- diff(sign(able[actionTime]))==2 #indices where slope changes from negative to positive
      eventBegin <- which(actionTime)[c(FALSE,change2rising)]
      #take together the times with data changes and event starts and order data
      xval.new<- c(eventBegin,xval)[order(c(eventBegin,xval))]
      interp<-approx(xval.new, runoff[xval.new], xout=(1:(NROW(runoff)-1)),  method="linear", ties="ordered")
      interp <- interp$y
      interp[is.na(runoff)] <- NA
    }
    if (method=="center")
    {  
      plateaus_i = able==0 & !is.na(able)   #index to plateaus
      p_begin= which(diff(plateaus_i)== 1)+1 #index to plateau begin
      p_end  = which(diff(plateaus_i)==-1)+1 #index to plateau end
      if(p_begin[1] >= p_end[1])          p_begin=c(min(which(!is.na(runoff)))+1, p_begin)  #series starts with plateau
      if(length(p_begin) > length(p_end)) p_end  =c(p_end, max(which(!is.na(runoff)))-1)  #series ends with plateau
      
      nodes_before = p_begin - 1 #index to values just before plateaus
      nodes_after  = p_end   + 1 #index to values just after plateaus
      nodes_center = (p_begin + p_end) %/% 2
      
      na_before = !is.finite(runoff[nodes_before]) #na vals before plateau
      na_after  = !is.finite(runoff[nodes_after ]) #na vals after  plateau
      nodes_after[na_after]   = nodes_after [na_after]  - 1 #use last plateau value instead
      nodes_before[na_before] = nodes_before[na_before] + 1 #use firest plateau value instead
      nodes_center = nodes_center[!(na_before | na_after) & (nodes_after != length(runoff))] #do not use center node
      #adjacent_plateaus= nodes_after[-length(nodes_after)] == nodes_before[-1] +1
      adjacent_plateaus= (nodes_after-1) %in% nodes_before
      half_steps_x=nodes_after-0.5
      half_steps_y=cbind(runoff[nodes_after], runoff[nodes_after-1])
      
      
      nodes_all = sort(unique(c(nodes_before[!c(FALSE,adjacent_plateaus)], nodes_center, nodes_after[!c(adjacent_plateaus, FALSE)])))
            
      interp<-approx(nodes_all, runoff[nodes_all], xout=1:NROW(runoff),  method="linear")
      interp <- interp$y
      plateaus_i = (c(FALSE,plateaus_i) | c(plateaus_i, FALSE))
      interp[!plateaus_i] <- runoff[!plateaus_i]
    }
    return(interp)
}