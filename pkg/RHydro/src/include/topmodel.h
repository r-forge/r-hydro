#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <time.h>
#include <R.h>

#define	ZERO		0.0000001

/* topmodel.output.c */
void	topmodel_output();
/* topmodel.start.c */
void	topmodel_memory_allocation();
void	topmodel_memory_free();
void	topmodel_topidx_calc();
/* NS.c */
double	NS();
/* topmodel.misc */
void	get_Ad();
double	get_lambda();
/* topmodel.init */
void	topmodel_init();
/* topmodel.infilt.c */
double	topmodel_infilt();
/* topmodel.core.c */
void	topmodel_run();

#ifdef MAIN
#	define	GLOBAL
#else
#	define	GLOBAL	extern
#endif

/* Topographic index statistics */
GLOBAL	struct
{
	double	*atb, *Aatb_r;
} idxstats;

GLOBAL	struct
{
	double	qs0, lnTe, m, Sr0, Srmax, td, vr, n;
	double	K0, CD, dt;
	double	*d, *Ad_r;
} params;

GLOBAL	struct
{
	/* Model efficiency */
	double	Em;
	int	ndelay, nreach;
	double	lnTe, vr;
	double	lambda;
	double	qss, qs0;
	double	Qobs_mean;
	/* params.nch's */
	double	*tch;
	/* misc.nreach's */
	double	*Ad;
	/* input.ntimestep's */
	double	*Qobs;
	double	*Qt;
	double	*qs;	/* spatially constant! */
	double	*S_mean;
	double	*f;
	double	*fex;
	/* input.ntimestep * (nidxclass + 1)'s */
	double	**qt, **qo, **qv, **qint;
	/* input.ntimestep * nidxclass's */
	double	**Srz, **Suz;
	double	**S;
	double	**Ea;
	double	**ex;
	/* Miscellaneous variables */
	int	timestep, idxclass;
} misc;



