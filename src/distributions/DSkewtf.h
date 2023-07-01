/*
	Copyright (C) 2013 Matthew Denwood <matthewdenwood@mac.com>
 */


#ifndef DSKEWTF_H_
#define DSKEWTF_H_

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
 * x ~ dfskew.t(mu, tau, nu, alpha);
 * f(x) = c/(1/sqrt(tau)) (1+(nu^2 ((x-mu)/(1/sqrt(tau)))^2)/alpha)^(-(alpha+1)/2); x < mu 
 * f(x) = c/(1/sqrt(tau)) (1+((x-mu)/(1/sqrt(tau)))^2/(nu^2 alpha))^(-(alpha+1)/2); x >= mu
 * where c = 2 nu [(1+nu^2 )B(1/2,tau/2) tau^(1/2) ]^(-1)
 * </pre>
 * @short Fernandes Steel Skew-t distribution
 */

class DSkewtf : public RScalarDist {
 public:
  DSkewtf();

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
