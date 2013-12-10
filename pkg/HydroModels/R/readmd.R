readmd <- function(mid) {  
   # Read Model Decisions
   # Author: Claudia Vitolo
   #
   # Args:
   #   mid:     model identification number
   #
   # Returns:
   #   It prints on the screen a desciption of the selected model 
     
   data(modlist)
       
   selectedmodel<-list("rferr"=modlist[mid,2],
                       "arch1"=modlist[mid,3],
                       "arch2"=modlist[mid,4],
                       "qsurf"=modlist[mid,5],
                       "qperc"=modlist[mid,6],
                       "esoil"=modlist[mid,7],
                       "qintf"=modlist[mid,8],
                       "q_tdh"=modlist[mid,9])
       
   #---------------------------------------------------------------------------
   #(1) rainfall error
   if (selectedmodel$rferr == 11) print("[11] rferr = additive_e (additive rainfall error)")
   if (selectedmodel$rferr == 12) print("[12] rferr = multiplc_e (multiplicative rainfall error)")
   #---------------------------------------------------------------------------
   #(2) upper-layer architecture
   if (selectedmodel$arch1 == 21) print("[21] arch1 = onestate_1 (upper layer defined by a single state variable)")
   if (selectedmodel$arch1 == 22) print("[22] arch1 = tension1_1 (upper layer broken up into tension and free storage)")
   if (selectedmodel$arch1 == 23) print("[23] arch1 = tension2_1 (tension storage sub-divided into recharge and excess)")
   #---------------------------------------------------------------------------
   #(3) lower-layer architecture and baseflow
   if (selectedmodel$arch2 == 31) print("[31] arch2 = fixedsiz_2 (baseflow reservoir of fixed size)")
   if (selectedmodel$arch2 == 32) print("[32] arch2 = tens2pll_2 (tension reservoir plus two parallel tanks)")
   if (selectedmodel$arch2 == 33) print("[33] arch2 = unlimfrc_2 (baseflow resvr of unlimited size (0-HUGE), frac rate)")
   if (selectedmodel$arch2 == 34) print("[34] arch2 = unlimpow_2 (baseflow resvr of unlimited size (0-HUGE), power recession)")
   if (selectedmodel$arch2 == 35) print("[35] arch2 = topmdexp_2 (Topmodel exponential reservoir (not in modlist?))")
   #---------------------------------------------------------------------------
   #(4) surface runoff
   if (selectedmodel$qsurf == 41) print("[41] qsurf = arno_x_vic (ARNO/Xzang/VIC parameterization (upper zone control))")
   if (selectedmodel$qsurf == 42) print("[42] qsurf = prms_varnt (PRMS variant (fraction of upper tension storage))")
   if (selectedmodel$qsurf == 43) print("[43] qsurf = tmdl_param (TOPMODEL parameterization (only valid for TOPMODEL qb))")
   #---------------------------------------------------------------------------
   #(5) percolation
   if (selectedmodel$qperc == 51) print("[51] qperc = perc_f2sat (water from (field cap to sat) avail for percolation)")
   if (selectedmodel$qperc == 52) print("[52] qperc = perc_lower (perc defined by moisture content in lower layer (SAC))")
   if (selectedmodel$qperc == 53) print("[53] qperc = perc_w2sat (water from (wilt pt to sat) avail for percolation)")
   #---------------------------------------------------------------------------
   #(6) evaporation
   if (selectedmodel$esoil == 61) print("[61] esoil = rootweight (root weighting)")
   if (selectedmodel$esoil == 62) print("[62] esoil = sequential (sequential evaporation model)")
   #---------------------------------------------------------------------------
   #(7) interflow
   if (selectedmodel$qintf == 71) print("[71] qintf = intflwnone (no interflow)")
   if (selectedmodel$qintf == 72) print("[72] qintf = intflwsome (interflow)")
   #---------------------------------------------------------------------------
   #(8) time delay in runoff
   if (selectedmodel$q_tdh == 81) print("[81] q_tdh = no_routing (no routing)")
   if (selectedmodel$q_tdh == 82) print("[82] q_tdh = rout_gamma (use a Gamma distribution with shape parameter = 2.5)")
   #---------------------------------------------------------------------------
       
   #    return()
}

