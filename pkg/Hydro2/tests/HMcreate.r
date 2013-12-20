
library(Hydro)
options(error = recover)
library(spacetime)


#### Alternative 2
# HMData as above




# We could create the observations empty
hmobs = HMData(Spatial = list(),
	Temporal = list(),
	SpatioTemporal = list()
)

# and add it to the HM-object:
hm1 = HM(Obs = hmobs)

hm1

# Alternatively fill it with data
par = list(a = c(0,1), b = c(0.1,10), cc = c(-5,-1))
sp = SpatialPoints(cbind(1:3,4:6))
library(xts)
time = as.xts(1:3,as.POSIXct(1:3, origin = "1970-01-01"))
st = STF(sp, time)

hmobs2 = HMData(Spatial = list(precipitationGauges = sp),
SpatioTemporal = list(precipitation = st))

hm2 = HM(Obs = hmobs2)

hm2

Calib = HMData(Temporal = list(runoff = as.xts((1:10)/10,as.POSIXct(1:10, origin = "1970-01-01"))))

hm3 = HM(Obs = hmobs2,  Parameters = par)

hm3

