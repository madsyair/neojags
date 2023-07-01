/*
 Copyright (C) 2018 Achmad Syahrul Choir <madsyair@gmail.com>
 
 Distribution  : MSNBurr2a
 Created by    : Achmad Syahrul Choir
 Reference     : Choir (2020)
 Date          : Jan 5, 2018

 This file is part of neojags
 
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

#ifndef DMSNBURR2A_H_
#define DMSNBURR2A_H_
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
 * x ~ dmsnburr2a(mu, tau,alpha)
 * f(x|mu,tau,alpha)=(omega/(1/tau))*exp(omega*((x-mu)/(1/tau)))*(1+ exp(omega*((x-mu)/(1/tau)))/alpha)^(-alpha+1)
 *  where omega=(1/sqrt(2*pi))*(1+1/alpha)^(alpha+1)
 * </pre>
 * @short MSNBurr-IIa distribution
 */
class DMsnburr2a : public RScalarDist {
 public:
  DMsnburr2a();

  double d(double x, PDFType type,
	   std::vector<double const *> const &parameters,
	   bool give_log) const;
  double p(double q, std::vector<double const *> const &parameters, bool lower,
	   bool give_log) const;
  double q(double p, std::vector<double const *> const &parameters, bool lower,
	   bool log_p) const;
  double r(std::vector<double const *> const &parameters, RNG *rng) const;
  /**
   * Checks that tau > 0
   */
  bool checkParameterValue(std::vector<double const *> const &parameters) const;
  /**
   * Exploits the capacity to sample truncted msnburr2a distributions
   * that is built into the JAGS library, overloading the generic
   * functionality of RScalarDist.
   */


};
}// namespace neojags
#ifndef INCLUDERSCALARDIST
}  // namespace jags
#endif  /* INCLUDERSCALARDIST */
#endif /* DNeonorm_H_ */
