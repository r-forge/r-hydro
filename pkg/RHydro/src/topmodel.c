#define	MAIN
#include "include/topmodel.h"
#undef	MAIN

void topmodel(double *parameters,
	      double *topidx,
	      double *delay,
	      double *rain,
	      double *ET0,
	      double *Qobs,
	      int *nidxclass,
	      int *ntimestep,
	      int *iterations,
	      int *nch,
	      int *whattoreturn,
              double *perfNS,
	      double *result)
{
  int i,j;

  topmodel_topidx_calc(topidx, *nidxclass);
  topmodel_memory_allocation(*nch, *ntimestep, *nidxclass);

  if(*iterations > 1) Rprintf("Iteration:         ");
#ifdef win32
  R_flushConsole();
  R_ProcessEvents();
#endif

  for(i=0; i<*iterations; i++) {
    R_CheckUserInterrupt();
    if(*iterations > 1) Rprintf ("\b\b\b\b\b\b\b\b%8i",i+1);

    topmodel_init(parameters, delay, *nch, i, *nidxclass, *ntimestep);

    /* run the model for each time step */
    for(j=0; j<*ntimestep; j++)
      topmodel_run(rain,ET0,*nidxclass,j,*ntimestep);

    /* TODO: separate routing */

    /* return simulations? */
    if(whattoreturn[0] > 0) {
      topmodel_output(result, *ntimestep, *iterations, whattoreturn[0], *nidxclass, i);
    }

    /* return NS? */
    if(whattoreturn[1]) {
      perfNS[i] = NS(misc.Qt, Qobs, *ntimestep);
    }	
  }

  if(*iterations > 1) Rprintf("\n");
  topmodel_memory_free(*nch, *ntimestep, *nidxclass);
  return;
}
