/*
	 Copyright (C) 2018 Achmad Syahrul Choir <madsyair@gmail.com>
 
 Distribution  :  LunettaExponential Power 
 Created by    : Achmad Syahrul Choir
 Reference     : Lunetta (1963)
 Date          : Jan 15, 2018
 
 This code is based on the DHalfCauchy.cc  (Copyright (C) 2018 Matthew Denwood <matthewdenwood@mac.com>) 
 This code is based source code in package 'normp', https://cran.r-project.org/web/packages/normalp/
 */
#include "DLep.h"
#include <util/nainf.h>
#include <rng/RNG.h>
#include <cmath>
#include <cfloat>
#include <JRmath.h>
/*#include <JRmath.h>*/

using namespace std;

// M_PI is defined in cmath for some architecures but not all

#define MU(par) (*par[0])
#define TAU(par) (*par[1])
#define SIGMA(par) (1/sqrt(*par[1]))
#define NU(par) (*par[2])


#ifndef INCLUDERSCALARDIST
namespace jags {
#endif  /* INCLUDERSCALARDIST */

namespace neojags {

DLep::DLep()
    : RScalarDist("dlep", 3, DIST_UNBOUNDED)
{
}

bool DLep::checkParameterValue (vector<double const *> const &par) const
{
  return (SIGMA(par) > 0&&NU(par)>0);
}
double
DLep::d(double x, PDFType type,
vector<double const *> const &par, bool give_log) const
{
  double mu=MU(par);
  double sigma=SIGMA(par);
  double v=NU(par);
  double lcost=log(2)+(1/v)*log(v)+lgamma(1+1/v)+sigma;
  double logpdf;
  logpdf=-lcost-pow((abs(x-mu))/sigma,v)/v;
  return give_log?logpdf: exp(logpdf);
}

double
DLep::p(double x, vector<double const *> const &par, bool lower, bool give_log)
  const
{
  double mu=MU(par);
  double sigma=SIGMA(par);
  double v=NU(par);
  double z=(x-mu)/sigma;
  double zz=pow(abs(z),v);
  double zv=pgamma(zz,1/v,v,1,0);
  zv=zv/2;
	  if (z<0){
		  zv=(0.5-zv);
	  }
	  else{
		  zv=(0.5+zv);
	  }
	  if (lower){
		  return (give_log)?log(zv):zv;
	  }
	  else{
	  	  return (give_log)?log(1-zv):(1-zv);
	  }

}

double
DLep::q(double p, vector<double const *> const &par, bool lower,
	bool log_p) const
{
  double mu=MU(par);
  double sigma=SIGMA(par);
  double v=NU(par);
  double xp = (log_p)? exp(p): p;
  xp = (lower)? xp: 1-xp;
  double zv;
  if (xp<0.5){
  zv=0.5-xp;
  }
  else{
  zv=xp-0.5;
  }
  zv=2*zv;
 double qg=qgamma(zv,1/v,v,1,0);
 double z;
  if (xp<0.5){
  z=-pow(qg,(1/v));
  }
  else{
  z=pow(qg,(1/v));
  }
return(mu+z*sigma);
}

double DLep::r(vector<double const *> const &par, RNG *rng) const
{
    return q(rng->uniform(), par, true, false);
}

}  // namespace neojags

#ifndef INCLUDERSCALARDIST
}  // namespace jags
#endif  /* INCLUDERSCALARDIST */
