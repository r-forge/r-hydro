!module sub
!contains
!end module sub

!===============================================================================
subroutine abcmodel(vect, vect_len, G0, a, b, c, Q)
!-------------------------------------------------------------------------------
!use sub
implicit none
!-------------------------------------------------------------------------------
!INPUT
! Vector with precipitation data
real(8),dimension(vect_len),intent(in):: vect
integer,intent(in):: vect_len
! model parameter a
real(8),intent(in):: a
! model parameter b
real(8),intent(in):: b
! model parameter c
real(8),intent(in):: c
!-------------------------------------------------------------------------------
! OUTPUT
! groundwater storage initial value
real(8), intent(inout):: G0
! vector with stream flow
real(8),dimension(vect_len+1),intent(out):: Q
!-------------------------------------------------------------------------------
!LOCAL
integer:: i
! current groundwater storage
real(8):: Gi
!-------------------------------------------------------------------------------
! CODE
do i=1,vect_len
  Gi   = (1-c)*G0 + a*vect(i)
  Q(i) = (1-a-b)*vect(i) + c*G0
  G0   = Gi
end do
end subroutine abcmodel
!===============================================================================


!===============================================================================
subroutine getrmse(num_blocks, block_len, block_idx, num_par_sets, series_len, mc, truth, rmse)
!-------------------------------------------------------------------------------
!use sub
implicit none
!-------------------------------------------------------------------------------
!INPUT
! number of blocks
integer,intent(in):: num_blocks
! length of each block
integer,intent(in):: block_len
! Vector with block indices
integer,dimension(num_blocks,block_len),intent(in):: block_idx
! number of parameter sets tested in Monte Carlo simulation
integer,intent(in):: num_par_sets
! length of flow time series
integer,intent(in):: series_len
! Results of Monte Carlo simulation of stream flow
real(8),dimension(series_len,num_par_sets),intent(in):: mc
! True stream flow
real(8),dimension(series_len),intent(in):: truth
!-------------------------------------------------------------------------------
! OUTPUT
! matrix of rmse with num_blocks rows and num_par_sets columns
real(8),dimension(num_par_sets, num_blocks),intent(out):: rmse
!-------------------------------------------------------------------------------
!LOCAL
integer:: i
integer:: j
integer:: k
real(8):: mse
!-------------------------------------------------------------------------------
! CODE
do i=1,num_blocks
  do j=1,num_par_sets
    mse = 0
    do k=1, block_len
      mse = mse + (mc(block_idx(i,k),j) - truth(block_idx(i,k)))**2
    end do
    rmse(j,i) =  mse**(0.5)
  end do  
end do
end subroutine getrmse
!===============================================================================


subroutine hbv(p, t, vect_len, snow, sm, suz, slz, cfmax, tt, fc, minsm, beta, lp, &
corr, k_perc, k0, luz, k1, k2, maxbas, etpmean, tmean, unithg, delta_t, Q)
!-------------------------------------------------------------------------------
implicit none
!-------------------------------------------------------------------------------
!INPUT
! Vector with precipitation data
integer,intent(in):: vect_len              !length of time series
real(8),dimension(vect_len),intent(in):: p !precipitation [mm]
real(8),dimension(vect_len),intent(in):: t !temperature [°C]


!STATE VARIABLES
! snow storage initial value
real(8)		, intent(inout)					:: snow
! soil moisture storage initial value
real(8)		, intent(inout)					:: sm
! soil upper zone storage initial value
real(8)		, intent(inout)					:: suz
! soil lower zone storage initial value
real(8)		, intent(inout)					:: slz


!PARAMETERS
real(8)		,intent(in) 					:: cfmax  !Degree day factor for snow melt, CFMAX (mm/°C/d)
real(8)		,intent(in) 					:: tt    !Temperature threshold below which precipitation falls as snow, TT (°C)
real(8)		,intent(in) 					:: fc    ! field capacity [mm] 
real(8)		,intent(in) 					:: minsm  ! minimum soil moisture for storage sm [mm]
real(8)		,intent(in) 					:: beta   ! Parameter to control the fraction of rain and snow melt partitioned for groundwater recharge [-]
real(8)		,intent(in) 					:: lp     !Fraction of soil moisture-field capacity-ratio above which actual evapotranspiration equals potential evapotranspiration [-]
real(8)		,intent(in) 					:: corr   !Correction factor for potential evapotranspiration [-]
real(8)		,intent(in)						:: k_perc !percolation coefficient [1/d]
real(8)		,intent(in)						:: k0     !Fast storage coefficient of soil upper zone [1/d]
real(8)		,intent(in) 					:: luz    !Threshold above which soil upper zone storage empties at rate computed by storage coefficient K0 [mm]
real(8)		,intent(in)						:: k1     !Slow storage coefficient of soil upper zone [1/d]
real(8)		,intent(in)						:: k2     !Storage coefficient of soil lower zone [1/d]
integer(4)	,intent(in) 					:: maxbas !Length of (triangular) unit hydrograph [timesteps]
real(8)		,intent(in) 					:: etpmean !mean evaporation [mm/d]
real(8)		,intent(in) 					:: tmean !mean temperatures [°C]
real(8)		,dimension(maxbas),intent(in out)	:: unithg !dimensionless unit hydrograph
real(8)		,intent(in) 					:: delta_t !length of timestep [days]
  


!-------------------------------------------------------------------------------
! OUTPUT
! vector with stream flow
real(8),dimension(vect_len),intent(out)	:: Q
!-------------------------------------------------------------------------------
!LOCAL
integer:: i
integer:: j
real(8):: melt
real(8):: eta
real(8):: frac
real(8):: delta_q
real(8):: delta_sm
real(8):: perc
real(8):: q0
real(8):: q1
real(8):: q2
real(8):: qsum
real(8) :: infiltr, loose_water, delta_suz, q_xs, sd

!-------------------------------------------------------------------------------
! CODE
if (sum(unithg)==0) then !generate triangular unit hydrograph, if not specified from outside
	unithg = 1.
	if (maxbas>1) then
		do i=1,maxbas/2 
			unithg(i) = i				
		end do

		do i=max(1,maxbas/2),maxbas 
			unithg(i) = maxbas - i + 1.				
		end do
		unithg = unithg/sum(unithg)
	end if
end if
	
do i=1,vect_len
	
	q_xs = 0
	melt    = MIN(MAX(cfmax * (t(i) - tt), 0.)* delta_t, snow)   !snow melt [mm]
	eta		= MIN(MAX(1. + corr * (t(i) - tmean),0.0) * etpmean, 2. * etpmean) * MIN(sm / (fc * lp), 1.) * delta_t !evapotranspiration [mm]
	eta = MIN(sm, eta)
	
	if (sm > fc) then !soil moisture above field capacity? -> quick runoff
		q_xs = sm-fc
		sm = fc
	end if	
	
	frac    = (sm/fc)**beta
	infiltr = melt + p(i)
	sd = fc-sm				!saturation deficit [mm]
	if (infiltr > sd  ) then !saturation excess?
		q_xs = q_xs + infiltr - sd !add to quick runoff 
		infiltr = sd               !restrain infiltr to saturation deficit
	end if
	
	delta_q = frac *         infiltr  !infiltration to upper zone (suz) [mm]
	delta_sm= (1. - frac) *  infiltr  !infiltration soil (sm) [mm]
	
	
	snow = MAX(snow - melt                     , 0.)  !snow storage [mm]
	sm   = MAX(sm   + delta_sm - eta           , minsm) !upper soil layer governing infiltration and evapotranspiration [mm]
	suz  = suz  + delta_q  !update upper zone storage due to infiltration [mm]
	
	perc    = MIN (suz, k_perc * suz * delta_t) !percolation [mm]
	
	loose_water = MAX (suz - luz, 0.) !loosely bound water prone to quick drainage
	q0      = MIN (loose_water, k0 * loose_water * delta_t) ! [mm]
	
	q1      = k1 * suz * delta_t !interflow [mm]

	q2      = MIN (slz, k2 * slz * delta_t) !ground water [mm]


	delta_suz= q0 + q1 + perc !potential change in upper zone
	if (delta_suz > suz) then !if potential changes exceed total water content, reduce all components accordingly
		q0 =     q0 * suz/delta_suz
		q1 =     q1 * suz/delta_suz
		perc = perc * suz/delta_suz
		delta_suz = suz
	end if

	qsum    = q_xs + q0 + q1 + q2
	do j=1, maxbas
		if (i+j-1 > vect_len) exit               ! beyond array bounds, exit
		q(i+j-1) = q(i+j-1) + qsum * unithg(j) !total runoff [mm]
	end do

	suz  = suz  - delta_suz
	slz  = MAX(slz  - q2                 + perc, 0.) 
	
  
end do


end subroutine hbv
!===============================================================================
