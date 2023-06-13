/*
	Copyright (C) 2013 Matthew Denwood <matthewdenwood@mac.com>

	This header is based on the pareto distribution in JAGS version 3.3,
	and specifies the half cauchy distribution

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


#ifndef DLEP_H_
#define DLEP_H_

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
 * x ~ dlep(mu,tau,nu);
 * f(x) = (sqrt(tau))/(2nu^(1/nu)  Gamma(1+1/nu) ) e^(-1/nu |sqrt(tau)(x-mu)|^nu )
 * </pre>
 * @short Lunetta Exponential Power distribution
 */
class DLep : public RScalarDist {
 public:
  DLep();

  double d(double x, PDFType type,
	   std::vector<double const *> const &parameters, bool give_log) const;
  double p(double q, std::vector<double const *> const &parameters, bool lower,
	   bool give_log) const;
  double q(double p, std::vector<double const *> const &parameters, bool lower,
	   bool log_p) const;
  double r(std::vector<double const *> const &parameters, RNG *rng) const;

  bool checkParameterValue(std::vector<double const *> const &parameters) const;
};

}  // namespace neojags

#ifndef INCLUDERSCALARDIST
}  // namespace jags
#endif  /* INCLUDERSCALARDIST */

#endif /* DSkewnf_H_ */
