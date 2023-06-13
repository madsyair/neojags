/*
 Copyright (C) 2018 Achmad Syahrul Choir <madsyair@gmail.com>
 
 Distribution  : GMSNBurr
 Created by    : Achmad Syahrul Choir
 Reference     : Choir  (2020)
 Date          : Jan 15, 2018
 
 This code is based on the DHalfCauchy.cc  (Copyright (C) 2018 Matthew Denwood <matthewdenwood@mac.com>) 
 
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

#include "DGmsnburr.h"

#include <util/nainf.h>
#include <rng/RNG.h>
#include <cmath>
#include <cfloat>
#include <JRmath.h>
using std::vector;
using std::exp;
using std::log;
using std::pow;


#define MYPI 3.141592653589793238462643383280

#define MU(par) (*par[0])
#define TAU(par) (*par[1])
#define SIGMA(par) (1/(*par[1]))
#define ALPHA1(par) (*par[2])
#define ALPHA2(par) (*par[3])

#ifndef INCLUDERSCALARDIST
namespace jags {
#endif  /* INCLUDERSCALARDIST */

namespace neojags{

DGmsnburr::DGmsnburr()
  : RScalarDist("dgmsnburr",4, DIST_UNBOUNDED)
{}

bool DGmsnburr::checkParameterValue (vector<double const *> const &par) const
{
  return (TAU(par) > 0 && ALPHA1(par) > 0 && ALPHA2(par) > 0 );
}

//Computing pdf

double
DGmsnburr::d(double x, PDFType type, vector<double const *> const &par, bool give_log) const
{

  double mu = MU(par);
  double sigma = SIGMA(par);
  double alpha1 = ALPHA1(par);
  double alpha2 = ALPHA2(par);
  double lomega;
  double omega;
  /*double epart1;*/
  double lpart;
  double lp;
  double logpe;
  double zt;
 /* omega=(1/sqrt(2*MYPI))*beta(alpha1,alpha2)*pow((alpha2/alpha1),-alpha2)*pow(1+(alpha2/alpha1),(alpha1+alpha2));*/
  lomega=-0.5*log(2*MYPI)+lbeta(alpha1,alpha2)-alpha2*(log(alpha2)-log(alpha1))+(alpha1+alpha2)*log1p(alpha2/alpha1);
  omega=exp(lomega);
 /* epart1=exp(-alpha2*omega*((z-mu)/sigma));*/
  /*epart=exp(-omega*((z-mu)/sigma));*/
    /*epart=exp(-omega*((z-mu)/sigma));*/
    zt=omega*((x-mu)/sigma);
    lpart=-zt+log(alpha2)-log(alpha1);
    if(lpart<=-37){
      logpe=exp(lpart);
    }else if(lpart<=18){
      logpe=log1p(exp(lpart));
    }else if(lpart<=33){
      logpe=lpart+exp(-lpart);
    }else{
      logpe=lpart;
    }
     lp= lomega-log(sigma)+alpha2*(log(alpha2)-log(alpha1))-alpha2*zt-(alpha1+alpha2)*logpe-lbeta(alpha1,alpha2);
  return give_log?lp: exp(lp);

}

//Computing CDF
double
DGmsnburr::p(double x, vector<double const *> const &par, bool lower, bool give_log)
const
{
  double mu = MU(par);
  double sigma = SIGMA(par);
  double alpha1 = ALPHA1(par);
  double alpha2 = ALPHA2(par);
  double omega;
  double lomega;
  lomega=-0.5*log(2*MYPI)+lbeta(alpha1,alpha2)-alpha2*(log(alpha2)-log(alpha1))+(alpha1+alpha2)*log1p(alpha2/alpha1);
  omega=exp(lomega);
  double ep = exp(-omega*(x-mu)/sigma);
  return pF(ep,2*alpha2,2*alpha1,!lower,give_log);
 }

//Computing Invers CDF

double
DGmsnburr::q(double p, vector<double const *> const &par, bool lower, bool log_p)
const
{
  if ( (log_p  && p > 0) || (!log_p && (p < 0 || p > 1)) )
    return JAGS_NAN;

  double mu = MU(par);
  double sigma = SIGMA(par);
  double alpha1 = ALPHA1(par);
  double alpha2 = ALPHA2(par);
 double omega;
  double lomega;
  lomega=-0.5*log(2*MYPI)+lbeta(alpha1,alpha2)-alpha2*(log(alpha2)-log(alpha1))+(alpha1+alpha2)*log1p(alpha2/alpha1);
  omega=exp(lomega);
  double zf =qF(p,2*alpha2,2*alpha1,!lower,log_p);
  return mu-(sigma/omega)*log(zf);

}

double
DGmsnburr::r(vector<double const *> const &par, RNG *rng) const
{
  double mu = MU(par);
  double sigma = SIGMA(par);
  double alpha1 = ALPHA1(par);
  double alpha2 = ALPHA2(par);
 double omega;
  double lomega;
  lomega=-0.5*log(2*MYPI)+lbeta(alpha1,alpha2)-alpha2*(log(alpha2)-log(alpha1))+(alpha1+alpha2)*log1p(alpha2/alpha1);
  omega=exp(lomega);
  double zf =rF(2*alpha2,2*alpha1,rng);
  return mu-(sigma/omega)*log(zf);

  /*return q(rng->uniform(), par,true, false);  */
}

}
#ifndef INCLUDERSCALARDIST
}  // namespace jags
#endif  /* INCLUDERSCALARDIST */


