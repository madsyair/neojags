/*Copyright (C) 2023 S Sifa'ul Khusna M.M <syifaulkhusnam.m@gmail.com> and Achmad Syahrul Choir <madsyair@gmail.com>
 
 Distribution  : Fernandez-Osiewalski-Steel Skew Exponential Power (SEP3) 
 Created by    : S Sifa'ul Khusn M.M and Achmad Syahrul Choir
 Reference     : Rigby et.al. (2019)
 
 This code of distribution is the result of converting the SEP3.R file in 'gamlss.dist' package, version 6.0-5 by Rigby et.al (2022) 
 This code is based on the pareto distribution in JAGS version 3.3.	
 This file is part of neojags
 Original DPar.cc file is Copyright (C) 2002-10 Martyn Plummer, 
 from the source for JAGS version 3.3, licensed under GPL-2
 
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


#include "DFossep.h"
#include <util/nainf.h>
#include <rng/RNG.h>
#include <JRmath.h>
#include <cmath>
#include <cfloat>
/*#include <JRmath.h>*/
using namespace std;
using std::vector;
using std::exp;
using std::log;
using std::pow;
//using std::gamma_distribution;

//nu--> alpha
//tau -->nu
// M_PI is defined in cmath for some architecures but not all
#define MU(par) (*par[0])
#define TAU(par) (*par[1])
#define SIGMA(par) (1/sqrt(*par[1]))
#define NU(par) (*par[2])
#define ALPHA(par) (*par[3])

#ifndef INCLUDERSCALARDIST
namespace jags {
#endif  /* INCLUDERSCALARDIST */

namespace neojags {

DFossep::DFossep()
  : RScalarDist("dfskew.ep", 4, DIST_UNBOUNDED)
{
  
}


bool DFossep::checkParameterValue (vector<double const *> const &par) const
{
  return (TAU(par) > 0 && ALPHA(par) > 0 && NU(par) > 0 );
}

//Computing pdf
double DFossep::d(double x, PDFType type,vector<double const *> const &par, bool give_log) const
{  
  double mu = MU(par);
  double tau = TAU(par);
  double alpha = ALPHA(par);
  double nu = NU(par);
  double e = x-mu;
  double z = e*pow(tau,0.5) ;
  double logpdf1 = (-0.5)*pow((alpha*fabs(z)),nu);  //beda di absolutnya
  double logpdf2 = (-0.5)*pow((fabs(z)/alpha),nu);
  double logpdf = (x < mu)? logpdf1 : logpdf2;
  logpdf = logpdf + log(alpha) - log(1+pow(alpha,2)) - ((1/nu)*log(2)) - lgamma(1+(1/nu)) + (0.5)*log(tau) ;
  if(give_log) 
    return logpdf;
  else 
    return exp(logpdf);
}


//Computing CDF
double DFossep::p(double x, vector<double const *> const &par, bool lower, bool give_log)
const  
{
  double mu = MU(par);
  double tau = TAU(par);
  double alpha = ALPHA(par);
  double nu = NU(par);
  double k = pow(alpha,2);
  double z1 = (alpha*(x-mu)*pow(tau,0.5))/(pow(2,1/nu));
  double z2 = (x-mu)*pow(tau,0.5)/(alpha*(pow(2,1/nu)));
  double s1 = pow(fabs(z1),nu);
  double s2 = pow(fabs(z2),nu);
  double cdf1 = 1-pgamma(s1,1/nu,1.0,1,0); //di R pgamma(q,shape, scale)
  double cdf2 = 1+k*pgamma(s2,1/nu,1.0,1,0);	
  double cdf = (x < mu)? cdf1 : cdf2;
  cdf = cdf/(1+k);
  
  cdf = (lower)? cdf : 1.0-cdf;
  cdf = (give_log)?  log(cdf): cdf;
  return cdf;
  
}

//Computing Invers CDF

double 
DFossep::q(double p, vector<double const *> const &par, bool lower, bool log_p)
const
{
  
  double mu=MU(par);
  double tau=TAU(par);
  double alpha=ALPHA(par); 
  double nu=NU(par);
  double xp = (log_p)? exp(p): p;
  xp = (lower)? xp: 1-xp;
  double k = pow(alpha,2);
  double q1 = mu - (pow(tau,-0.5)*pow(2,1/nu)/alpha)*pow((qgamma( 1-xp*(1+k), 1/nu,1.0,1,0)),(1/nu)); 
  double q2 = mu + (pow(tau,-0.5)*alpha*pow(2,1/nu))*pow((qgamma( (-1/k)*(1-xp*(1+k)),1/nu,1.0,1,0)),(1/nu));
  double q = (xp<(1.0/(1.0+k)))? q1 : q2;
  return q;
}  

//Generating random number
double 
DFossep::r(vector<double const *> const &par, RNG *rng) const
{
  return q(rng->uniform(), par, true, false);
}

}  // namespace neojags

#ifndef INCLUDERSCALARDIST
}  // namespace jags
#endif  /* INCLUDERSCALARDIST */
