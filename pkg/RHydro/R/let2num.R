let2num <- function(l,letcase=TRUE){
# This routine transforms model list's elements 
# from strings to numbers (letcase = TRUE) and viceversa (letcase = FALSE)
# l = model list as dataframe (for original model list see data(modlist))
  
  nr <- dim(l)[1]
  nc <- dim(l)[2]
  l2 <- l
  l2[,2:nc] <- NA
  
  for (r in 1:nr){
  if (letcase == TRUE) {
   #---------------------------------------------------
   #(1) rainfall error
   if (as.character(l[r,"rferr"]) == "additive_e") l2[r,"rferr"] <- 11 
   if (as.character(l[r,"rferr"]) == "multiplc_e") l2[r,"rferr"] <- 12
   #---------------------------------------------------
   #(2) upper-layer architecture
   if (as.character(l[r,"arch1"]) == "onestate_1") l2[r,"arch1"] <- 21
   if (as.character(l[r,"arch1"]) == "tension1_1") l2[r,"arch1"] <- 22
   if (as.character(l[r,"arch1"]) == "tension2_1") l2[r,"arch1"] <- 23
   #---------------------------------------------------
   #(3) lower-layer architecture and baseflow
   if (as.character(l[r,"arch2"]) == "fixedsiz_2") l2[r,"arch2"] <- 31
   if (as.character(l[r,"arch2"]) == "tens2pll_2") l2[r,"arch2"] <- 32
   if (as.character(l[r,"arch2"]) == "unlimfrc_2") l2[r,"arch2"] <- 33
   if (as.character(l[r,"arch2"]) == "unlimpow_2") l2[r,"arch2"] <- 34
   if (as.character(l[r,"arch2"]) == "topmdexp_2") l2[r,"arch2"] <- 35
   #---------------------------------------------------
   #(4) surface runoff
   if (as.character(l[r,"qsurf"]) == "arno_x_vic") l2[r,"qsurf"] <- 41
   if (as.character(l[r,"qsurf"]) == "prms_varnt") l2[r,"qsurf"] <- 42
   if (as.character(l[r,"qsurf"]) == "tmdl_param") l2[r,"qsurf"] <- 43
   #---------------------------------------------------
   #(5) percolation
   if (as.character(l[r,"qperc"]) == "perc_f2sat") l2[r,"qperc"] <- 51
   if (as.character(l[r,"qperc"]) == "perc_lower") l2[r,"qperc"] <- 52
   if (as.character(l[r,"qperc"]) == "perc_w2sat") l2[r,"qperc"] <- 53
   #---------------------------------------------------
   #(6) evaporation
   if (as.character(l[r,"esoil"]) == "rootweight") l2[r,"esoil"] <- 61
   if (as.character(l[r,"esoil"]) == "sequential") l2[r,"esoil"] <- 62
   #---------------------------------------------------
   #(7) interflow
   if (as.character(l[r,"qintf"]) == "intflwnone") l2[r,"qintf"] <- 71
   if (as.character(l[r,"qintf"]) == "intflwsome") l2[r,"qintf"] <- 72
   #---------------------------------------------------
   #(8) time delay in runoff
   if (as.character(l[r,"q_tdh"]) == "no_routing") l2[r,"q_tdh"] <- 81
   if (as.character(l[r,"q_tdh"]) == "rout_gamma") l2[r,"q_tdh"] <- 82
   #---------------------------------------------------
  }else{
   #---------------------------------------------------
   #(1) rainfall error
   if (as.character(l[r,"rferr"]) == 11) l2[r,"rferr"] <- "additive_e"
   if (as.character(l[r,"rferr"]) == 12) l2[r,"rferr"] <- "multiplc_e"
   #---------------------------------------------------
   #(2) upper-layer architecture
   if (as.character(l[r,"arch1"]) == 21) l2[r,"arch1"] <- "onestate_1"
   if (as.character(l[r,"arch1"]) == 22) l2[r,"arch1"] <- "tension1_1"
   if (as.character(l[r,"arch1"]) == 23) l2[r,"arch1"] <- "tension2_1"
   #---------------------------------------------------
   #(3) lower-layer architecture and baseflow
   if (as.character(l[r,"arch2"]) == 31) l2[r,"arch2"] <- "fixedsiz_2"
   if (as.character(l[r,"arch2"]) == 32) l2[r,"arch2"] <- "tens2pll_2"
   if (as.character(l[r,"arch2"]) == 33) l2[r,"arch2"] <- "unlimfrc_2"
   if (as.character(l[r,"arch2"]) == 34) l2[r,"arch2"] <- "unlimpow_2"
   if (as.character(l[r,"arch2"]) == 35) l2[r,"arch2"] <- "topmdexp_2"
   #---------------------------------------------------
   #(4) surface runoff
   if (as.character(l[r,"qsurf"]) == 41) l2[r,"qsurf"] <- "arno_x_vic"
   if (as.character(l[r,"qsurf"]) == 42) l2[r,"qsurf"] <- "prms_varnt"
   if (as.character(l[r,"qsurf"]) == 43) l2[r,"qsurf"] <- "tmdl_param"
   #---------------------------------------------------
   #(5) percolation
   if (as.character(l[r,"qperc"]) == 51) l2[r,"qperc"] <- "perc_f2sat"
   if (as.character(l[r,"qperc"]) == 52) l2[r,"qperc"] <- "perc_lower"
   if (as.character(l[r,"qperc"]) == 53) l2[r,"qperc"] <- "perc_w2sat"
   #---------------------------------------------------
   #(6) evaporation
   if (as.character(l[r,"esoil"]) == 61) l2[r,"esoil"] <- "rootweight"
   if (as.character(l[r,"esoil"]) == 62) l2[r,"esoil"] <- "sequential"
   #---------------------------------------------------
   #(7) interflow
   if (as.character(l[r,"qintf"]) == 71) l2[r,"qintf"] <- "intflwnone"
   if (as.character(l[r,"qintf"]) == 72) l2[r,"qintf"] <- "intflwsome"
   #---------------------------------------------------
   #(8) time delay in runoff
   if (as.character(l[r,"q_tdh"]) == 81) l2[r,"q_tdh"] <- "no_routing"
   if (as.character(l[r,"q_tdh"]) == 82) l2[r,"q_tdh"] <- "rout_gamma"
   #---------------------------------------------------
  }
 } 
  return(l2)
}
