/*
 Copyright (C) 2023 Resi Ramadani <resi.ramadhi@gmail.com> and Achmad Syahrul Choir <madsyair@gmail.com>
 
 Distribution  : Jones's Skew Exponential Power (SEP4) 
 Created by    : Resi Ramadani and Achmad Syahrul Choir
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



#ifndef DJSEP_H_
#define DJSEP_H_

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
 * x ~ djskew.ep(mu, tau, nu1, nu2);
 * f(x) = c/(1/sqrt(tau))  exp⁡[-|(x-mu)/(1/sqrt(tau))|)^nu1]; x < mu
 * f(x) = c/(1/sqrt(tau))  exp⁡[-|(x-mu)/(1/sqrt(tau))|)^nu2]; x >= mu
 * where c=[Gamma(1+nu_1^(-1) )+Gamma(1+nu_2^(-1) )]^(-1)
 * </pre>
 * @short Jones'S Skew Exponential Power distribution
 */

class DJsep : public RScalarDist {
 public:
  DJsep();

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

#endif /* DSkewtf_H_ */
