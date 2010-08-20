long.wave.radiation.balance <- function(t.air, t.atm = t.air, t.snow=NULL, sigma= 4.9*10^-9 #MJ * 1/m²*1/day*1/K^4
		, vap.pres, cloud.cover=0, sky.view=0, emiss.snow=1){
	#emissivity of atmosphere dingman 5-40
	emiss.atmosp <- (1-sky.view)*1.72*(vap.pres/(t.air+273.2))^(1/7)*(1+0.22*cloud.cover^2)+sky.view
	#dingman 5-41
	if(is.null(t.snow)){
		t.snow <- t.air - 2.5
		if(NCOL(t.snow)==1){
			t.snow[ coredata(t.snow) > 0 ] <- 0
		} else {
			for(i in 1:NCOL(t.snow))
				t.snow[ coredata(t.snow)[,i] > 0 , i] <- 0
		}
	}
	#dingman 5-35
	L.in <- emiss.atmosp*sigma*(t.atm+273.2)^4
	L.out <- emiss.snow*sigma*(t.snow+273.2)^4+(1-emiss.snow)*L.in
	return(list(L=L.in -L.out, L.in= L.in, L.out=L.out, e.at= emiss.atmosp))
}
