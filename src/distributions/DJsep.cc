/*
 Copyright (C) 2023 Resi Ramadani <resi.ramadhi@gmail.com> and Achmad Syahrul Choir <madsyair@gmail.com>
 
 Distribution  : Jones's Skew Exponential Power (SEP4) 
 Created by    : Resi Ramadani and Achmad Syahrul Choir
 Reference     : Rigby et.al. (2019)
 
 This code of distribution is the result of converting the SEP4.R file in 'gamlss.dist' package, version 6.0-5 by Rigby et.al (2022) 

  This code is based on the DHalfCauchy.cc  (Copyright (C) 2018 Matthew Denwood <matthewdenwood@mac.com>). 
  This file is part of neojags.
 neojags is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.
 
 neojags is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.
 
 You should have received a copy of the GNU General Public License
 along with neojags  If not, see <http://www.gnu.org/licenses/>.
 
 */

#include "DJsep.h"
#include <util/nainf.h>
#include <rng/RNG.h>
#include <cmath>
#include <cfloat>
#include <JRmath.h>
#include <math.h>
/*#include <JRmath.h>*/
using namespace std;

// M_PI is defined in cmath for some architecures but not all
#define MU(par) (*par[0])
#define TAU(par) (*par[1])
#define SIGMA(par) (1/sqrt(*par[1]))
#define NU1(par) (*par[2])
#define NU2(par) (*par[3])

#ifndef INCLUDERSCALARDIST
namespace jags {
#endif  /* INCLUDERSCALARDIST */

namespace neojags {

DJsep::DJsep()
    : RScalarDist("djskew.ep", 4, DIST_UNBOUNDED)
{
}

bool DJsep::checkParameterValue (vector<double const *> const &par) const
{
  return (SIGMA(par)>0 && NU1(par)>0 && NU2(par)>0);
}

double
DJsep::d(double x, PDFType type,
vector<double const *> const &par, bool give_log) const
{
  double mu = MU(par);
  double tau = TAU(par);
  double nu1 = NU1(par);
  double nu2 = NU2(par);
  double z = (x-mu)*pow(tau,0.5);
  double lk1 = lgamma(1+(1/nu1));
  double lk2 = lgamma(1+(1/nu2));
  double k1 = exp(lk1);
  double k2 = exp(lk2);
  double loglik1 = -(pow(fabs(z),nu1));
  double loglik2 = -(pow(fabs(z),nu2));
  double loglik3 = (x<mu)? loglik1 : loglik2;        
  double loglik = loglik3 - log(k1+k2) + log(pow(tau,0.5));          
  if(give_log)
    return loglik;
  else
    return exp(loglik);
}

double
DJsep::p(double x, vector<double const *> const &par, bool lower, bool give_log)
  const
{
  double mu = MU(par);
  double tau = TAU(par);
  double nu1 = NU1(par);
  double nu2 = NU2(par);
  double lk1 = lgamma(1+(1/nu1));
  double lk2 = lgamma(1+(1/nu2));
  double lk = lk2 - lk1; 
  double k = exp(lk);     
  double z = (x-mu)*pow(tau,0.5);             
  double s1 = pow(fabs(z),nu1);         
  double s2 = pow(fabs(z),nu2);
  double cdf1 = 1-pgamma(s1,1/nu1,1.0,1,0);
  double cdf2 = 1+k*pgamma(s2,1/nu2,1.0,1,0);
  double cdf = (x < mu)? cdf1 : cdf2;
  cdf = cdf/(1+k);
  cdf = (lower)? cdf : 1.0-cdf;
  cdf = (give_log)?  log(cdf): cdf;
  return cdf;
}

double
DJsep::q(double p, vector<double const *> const &par, bool lower,
	bool log_p) const
{
  double mu = MU(par);
  double tau = TAU(par);
  double nu1 = NU1(par);
  double nu2 = NU2(par);
  double xp = (log_p)? exp(p): p;
  xp = (lower)? xp: 1-xp;
  double lk1 = lgamma(1+(1/nu1));
  double lk2 = lgamma(1+(1/nu2));
  double lk = lk2 - lk1;
  double k = exp(lk);
  //qgamma(p, shape, rate = 1, scale = 1/rate, lower.tail = TRUE,log.p = FALSE)
  double q1 = mu - pow(tau, -0.5)*pow((qgamma( 1-xp*(1+k), 1/nu1,1.0,1,0)),(1/nu1));
  double q2 = mu + pow(tau,-0.5)*pow((qgamma( (-1/k)*(1-xp*(1+k)),1/nu2,1.0,1,0)),(1/nu2));
  double q = (xp < (1/(1+k)))? q1 : q2;
  return q;
}

double DJsep::r(vector<double const *> const &par, RNG *rng) const
{
    return q(rng->uniform(), par, true, false);
}

}  // namespace neojags

#ifndef INCLUDERSCALARDIST
}  // namespace jags
#endif  /* INCLUDERSCALARDIST */
