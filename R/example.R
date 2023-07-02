# This file is copied and modified from runjags package
# Copyright (C) 2013 Matthew Denwood <matthewdenwood@mac.com> and Achmad Syahrul Choir <madsyair@gmail.com>
# 
# This code allows the distributions provided by the neojags module
# to be tested from within R.  
# 
# This version of the module is compatible with JAGS version 3 and 4.
# Some necessary modifications are controlled using the INCLUDERSCALARDIST
# macro which is defined by makevars if JAGS version 3 is detected.
# Once JAGS version 3 becomes obsolete the redundant code will be
# removed from neojags.
# 
# neojags is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# neojags is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with runjags  If not, see <http://www.gnu.org/licenses/>.
example_neojags <- function(...){
    neojagsprivate$modulelocation <- gsub('/$','', file.path(find.package("neojags", quiet = TRUE, lib.loc = .libPaths()), 'libs', paste0(.Platform$r_arch, if(.Platform$r_arch!="") "/" else ""))) 
 	X <- c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10)
	Y <- c(10.8090157039524, 13.9434806085521, 15.787689123995, 16.9569401422281, 22.0824675991525, 21.2058041795089, 24.403335735507, 27.6592408754351, 28.6753194874265, 28.9965911129099)
	model <- "model {
	for(i in 1 : N){
		Y[i] ~ dmsnburr(alpha,true.y[i], precision);
		true.y[i] <- (m * X[i]) + c
	}
	alpha~dunif(0.1,10)
	m ~ dunif(-1000,1000)
	c ~ dunif(-1000,1000)
	precision ~ dexp(1)
	}"

	data <- list(X=X, Y=Y, N=length(X))
	inits1 <- list(alpha=1,m=1, c=1, precision=1,
	.RNG.name="base::Super-Duper", .RNG.seed=1)
	inits2 <- list(alpha=1.3,m=0.1, c=10, precision=1,
	.RNG.name="base::Wichmann-Hill", .RNG.seed=2)
	if (requireNamespace("neojags", quietly = TRUE)){
	  neojags::load.neojagsmodule()
	} 
	out <- runjags::run.jags(model=model, monitor=c("alpha","m", "c", "precision"),
	data=data, n.chains=2, inits=list(inits1,inits2),...)

	return(out)

}
