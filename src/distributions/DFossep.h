/*Copyright (C) 2023 S Sifa'ul Khusna M.M <syifaulkhusnam.m@gmail.com> and Achmad Syahrul Choir <madsyair@gmail.com>
 
 Distribution  : Fernandez-Osiewalski-Steel Skew Exponential Power (SEP3) 
 Created by    : S Sifa'ul Khusn M.M and Achmad Syahrul Choir
 Reference     : Rigby et.al. (2019)
 
 This code is based on the pareto distribution in JAGS version 3.3.	
 This file is part of neojags
 Original DPar.h file is Copyright (C) 2002-10 Martyn Plummer, 
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

#ifndef DFOSSEP_H_
#define DFOSSEP_H_
// Checks the JAGS version and sets necessary macros:

#include "../jagsversions.h"

#ifndef INCLUDERSCALARDIST
#include <distribution/RScalarDist.h>
namespace jags {
#else
#include "jags/RScalarDist.h"
#endif  /* INCLUDERSCALARDIST */

namespace neojags {

/**
 * <pre>
 * x ~ DFossep(mu,tau,nu,alpha)
 * f(x|mu,tau,nu,alpha) = (c*sqrt(tau))*exp((-1/2)*pow((abs(alpha*z),nu)) ;x < mu
 * f(x|mu,tau,nu,alpha) = (c*sqrt(tau))*exp((-1/2)*pow((abs(z/alpha),nu)) ;x >= mu
 * where z = (x-mu)*sqrt(tau) , 
 *       c = (alpha*nu)(1/((1+pow(alpha,2))(pow(2,1/nu))*pgamma(1/nu))
 * * </pre>
 *@short Fernandez-Osiewalski-Steel Skew Exponential Power distribution
 */
class DFossep : public RScalarDist {
public:
  DFossep();
  
  double d(double x, PDFType type,
           std::vector<double const *> const &parameters, bool give_log) const;
  double p(double q, std::vector<double const *> const &parameters, bool lower,
           bool give_log) const;
  double q(double p, std::vector<double const *> const &parameters, bool lower,
           bool log_p) const;
  double r(std::vector<double const *> const &parameters, RNG *rng) const;
  
  
  bool checkParameterValue(std::vector<double const *> const &parameters) const;
  
  /**
   * Exploits the capacity to sample truncted normal distributions
   * that is built into the JAGS library, overloading the generic
   * functionality of RScalarDist.
   */
  
};
}// namespace neojags
#ifndef INCLUDERSCALARDIST
}  // namespace jags
#endif  /* INCLUDERSCALARDIST */
#endif /* DFOSSEP_H_ */
