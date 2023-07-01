/*
 
 Copyright (C) 2019 Achmad Syahrul Choir <madsyair@gmail.com>
 
 Distribution  : Fernandez-Steel Skew normal 
 Created by    : Achmad Syahrul Choir
 Reference     : Rigby et.al. (2019)
 
 This code of distribution is the result of converting the SN2.R file in 'gamlss.dist' package, version 6.0-5 by Rigby et.al (2022). 
 his code is based on the DHalfCauchy.cc  (Copyright (C) 2018 Matthew Denwood <matthewdenwood@mac.com>). This file is part of neojags. 
  

 */

#include "DSkewnf.h"
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
#define ALPHA(par) (*par[2])

#ifndef INCLUDERSCALARDIST
namespace jags {
#endif  /* INCLUDERSCALARDIST */

namespace neojags {

DSkewnf::DSkewnf()
    : RScalarDist("dfskew.norm", 3, DIST_UNBOUNDED)
{
}

bool DSkewnf::checkParameterValue (vector<double const *> const &par) const
{
  return (TAU(par) > 0&&ALPHA(par)>0);
}

double
DSkewnf::d(double x, PDFType type,
vector<double const *> const &par, bool give_log) const
{
  double mu=MU(par);
  double sigma=SIGMA(par);
  double alpha=ALPHA(par);
  double alpha2 = alpha*alpha;
  double e =  x-mu;
  double z = e/sigma;
  double logpdf1 = dnorm((alpha*z),0,1,1);
  double logpdf2 = dnorm(e/(sigma*alpha),0,1,1);
  double logpdf = (e < 0)? logpdf1 : logpdf2;
  logpdf += log(2.0*alpha/(1.0+alpha2)) - log(sigma);
  if(give_log)
    return logpdf;
  else
    return exp(logpdf);

}

double
DSkewnf::p(double x, vector<double const *> const &par, bool lower, bool give_log)
  const
{
  double mu=MU(par);
  double sigma=SIGMA(par);

  double alpha=ALPHA(par);
  double alpha2 = alpha*alpha;
  double e =  x-mu;
  double cdf1 = 2.0*pnorm(alpha*e/sigma,0,1 , 1,0);
  double cdf2 = 1 + 2.0*alpha2*(pnorm(e/(sigma*alpha),  0,1,1,0)-0.5);
  double cdf = (e<0)? cdf1 : cdf2;
  cdf = cdf/(1.0+alpha2);
  cdf = (lower)? cdf : 1.0-cdf;
  cdf = (give_log)?  log(cdf): cdf;
  return cdf;

}

double
DSkewnf::q(double p, vector<double const *> const &par, bool lower,
	bool log_p) const
{
  double mu=MU(par);
  double sigma=SIGMA(par);
    double alpha=ALPHA(par);
  double alpha2 = alpha*alpha;
  double xp = (log_p)? exp(p): p;
  xp = (lower)? xp: 1-xp;
  double q1 = mu+(sigma/alpha)*qnorm(xp*(1.0+alpha2)/2,0,1,  1,0);
  double q2 = mu+(sigma*alpha)*qnorm((xp*(1.0+alpha2)-1.0)/(2.0*alpha2) + 0.5,0,1,  1,0);
  double q = (xp<(1.0/(1.0+alpha2)))? q1 : q2;
  return q;

}

double DSkewnf::r(vector<double const *> const &par, RNG *rng) const
{
    return q(rng->uniform(), par, true, false);
}

}  // namespace neojags

#ifndef INCLUDERSCALARDIST
}  // namespace jags
#endif  /* INCLUDERSCALARDIST */
