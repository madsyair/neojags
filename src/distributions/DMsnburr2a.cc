/*
 Copyright (C) 2018  Achmad Syahrul Choir <madsyair@gmail.com>
 
 Distribution  : MSNBurr2a
 Created by    : Achmad Syahrul Choir
 Reference     : Choir  (2020)
 Date          : Jun 4th, 2023

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

#include "DMsnburr2a.h"
#include <util/nainf.h>
#include <rng/RNG.h>

#include <cmath>
#include <cfloat>

/*#include <JRmath.h>*/
using std::vector;
using std::exp;
using std::log;
using std::pow;


#define MYPI 3.141592653589793238462643383280
#define MU(par) (*par[0])
#define TAU(par) (*par[1])
#define SIGMA(par) (1/(*par[1]))
#define ALPHA(par) (*par[2])

#ifndef INCLUDERSCALARDIST
namespace jags {
#endif  /* INCLUDERSCALARDIST */

namespace neojags {

DMsnburr2a::DMsnburr2a()
  : RScalarDist("dmsnburr2a", 3, DIST_UNBOUNDED)
{}

bool DMsnburr2a::checkParameterValue (vector<double const *> const &par) const
{
  return (SIGMA(par) > 0 && ALPHA(par) > 0);
}

//Computing pdf

double
DMsnburr2a::d(double x, PDFType type,
            vector<double const *> const &par, bool give_log) const
{
  double omega;
  /*double epart1;
  double epart2;*/
  double lpart;
  double alpha = ALPHA(par);
  double mu = MU(par);
  double sigma = SIGMA(par);
  double logpe;
  double zt;
  omega=(1/sqrt(2*MYPI))*pow(1+(1/alpha),(alpha+1));
  zt=omega*((x-mu)/sigma);
  /*epart1=exp(-alpha*omega*((z-mu)/sigma));
  epart2=exp(-omega*((z-mu)/sigma));*/
  lpart=-zt+log(alpha);
  if(lpart<=-37){
    logpe=exp(lpart);
  }else if(lpart<=18){
    logpe=log1p(exp(lpart));
  }else if(lpart<=33){
    logpe=lpart+exp(-lpart);
  }else{
    logpe=lpart;
  }
  double lp=log(omega)-log(sigma)+(alpha+1)*log(alpha)-alpha*zt-(alpha+1)*logpe;
  return give_log?lp: exp(lp);
  }

//Computing CDF
double
DMsnburr2a::p(double x, vector<double const *> const &par, bool lower, bool give_log)
const
{


  double mu = MU(par);
  double sigma = SIGMA(par);
  double alpha = ALPHA(par);
  double omega=(1/sqrt(2*MYPI))*pow(1+(1/alpha),(alpha+1));
  double epart=exp(omega*((x-mu)/sigma));
  double q;
   q=pow(1+(epart/alpha),-alpha);

  if (!lower) {
    return give_log ? log(q) : q;
  }
  else {
    return give_log ? log(1 - q) : (1-q);
  }
}

//Computing Invers CDF

double
DMsnburr2a::q(double p, vector<double const *> const &par, bool lower, bool log_p)
const
{
  if ( (log_p  && p > 0) || (!log_p && (p < 0 || p > 1)) )
    return JAGS_NAN;

  double mu = MU(par);
  double sigma = SIGMA(par);
  double alpha = ALPHA(par);
  double omega;
  double tp;

  if (!lower) {
    if (log_p)
      tp = exp(p);
    else
      tp = p;
  }
  else {
    if (log_p)
      tp = 1-exp(p);
    else
      tp = 1-p;
  }
  omega=(1/sqrt(2*MYPI))*pow(1+(1/alpha),(alpha+1));
  return mu+(sigma/omega)*(log(alpha)+log(pow(tp,(-1/alpha))-1));
}

double
DMsnburr2a::r(vector<double const *> const &par, RNG *rng) const
{
  return q(rng->uniform(), par,false, false);
}

}
#ifndef INCLUDERSCALARDIST
}  // namespace jags
#endif  /* INCLUDERSCALARDIST */
