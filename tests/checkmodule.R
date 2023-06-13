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



library("neojags")
library("runjags")
runjags::runjags.options(nodata.warning=FALSE)

# Checks that the neojags module distributions are correct.

# Loading the dynlib requires rjags for Windows:
if(.Platform$OS.type != 'windows' || requireNamespace('rjags')){
  
  loaded <- neojags:::dynloadmodule()
  if(!loaded)
    stop("The internal JAGS dynlib could not be loaded - if you installed this package from CRAN, please file a bug report to the package author")
  
  cat('Running module tests\n')
  
  # Required for nchain etc:
  library("coda")
  
  
  
  
  
  
  cat("The internal module tests were passed\n")
}else{
  cat("The internal module tests were skipped (not available on Windows)\n")
}


# Require the rjags library to run the rest of the checks:
dotests <- TRUE
if(!require("rjags")){
  cat("The module checks were not performed as rjags is not installed\n")
  dotests <- FALSE
}

if(dotests){
  
  # Try to load the module:
  loaded <- load.neojagsmodule(fail=FALSE)
  if(!loaded){
    warning("The module checks were not performed as the internal JAGS module could not be loaded")
    dotests <- FALSE
  }
  
  # Now check the JAGS implementations just to make sure the functions are found OK:
  
  m <- "model{

		r0 ~ dmsnburr(0,1,1)
		f0 ~ dmsnburr(0,1,1)
		d0 <- dmsnburr(0.5,0,1,1)
		p0 <- pmsnburr(0.5,0,1,1)
		q0 <- qmsnburr(0.5,0,1,1)

		r1 ~ dmsnburr2a(0,1,1)
		f1 ~ dmsnburr2a(0,1,1)
		d1 <- dmsnburr2a(0.5,0,1,1)
		p1 <- pmsnburr2a(0.5,0,1,1)
		q1 <- qmsnburr2a(0.5,0,1,1)

		r2 ~ dgmsnburr(0,1,1,1)
		f2 ~ dgmsnburr(0,1,1,1)
		d2 <- dgmsnburr(0.5,0,1,1,1)
		p2 <- pgmsnburr(0.5,0,1,1,1)
		q2 <- qgmsnburr(0.5,0,1,1,1)

		r3 ~ dfskew.norm(0,1,1)
		f3 ~ dfskew.norm(0,1,1)
		d3 <- dfskew.norm(0.5,0,1,1)
		p3 <- pfskew.norm(0.5,0,1,1)
		q3 <- qfskew.norm(0.5,0,1,1)

	  r4 ~ dfskew.t(0,1,10,1)
		f4 ~ dfskew.t(0,1,10,1)
		d4 <- dfskew.t(0.5,0,1,10,1)
		p4 <- pfskew.t(0.5,0,1,10,1)
		q4 <- qfskew.t(0.5,0,1,10,1)

	 r5 ~ dlep(1,1,1)
		f5 ~ dlep(1,1,1)
		d5 <- dlep(0.5,1,1,1)
		p5 <- plep(0.5,1,1,1)
		q5 <- qlep(0.5,1,1,1)

		
		r6 ~ djskew.ep(0,1,2,2)
		f6 ~ djskew.ep(0,1,2,2)
		d6 <- djskew.ep(0.5,0,1,2,2)
		p6 <- pjskew.ep(0.5,0,1,2,2)
		q6 <- qjskew.ep(0.5,0,1,2,2)
    
    
		#monitor# r0,d0,p0,q0,r1,d1,p1,q1,r2,d2,p2,q2,r3,d3,p3,q3,r4,d4,p4,q4, r5,d5,p5,q5,r6,d6,p6,q6,
		#data# f0, f1, f2, f3, f4, f5, f6
	
	}"
 
  f0=f1=f2=f3=f4=f5=f6<- 2
  
  r <- runjags::run.jags(m, n.chains=2, burnin=100, sample=100, method='rjags')
  stopifnot(nchain(as.mcmc.list(r))==2)
  
  
  # Now check that my p and q functions are symmetric:
  
  m <- "model{

		qsn <- qnorm(sp, cont1, pos1)
		psn <- pnorm(qsn, cont1, pos1)

		qsg <- qgamma(sp, pos1, pos2)
		psg <- pgamma(qsg, pos1, pos2)

		qsl <- qlnorm(sp, cont1, pos2)
		psl <- plnorm(qsl, cont1, pos2)

		qsp <- qmsnburr(sp, cont1, pos1, pos2)
		psp <- pmsnburr(qsp, cont1, pos1, pos2)

		qsp1 <- qmsnburr2a(sp, cont1, pos1, pos2)
		psp1 <- pmsnburr2a(qsp1, cont1, pos1, pos2)

		qsp2 <- qgmsnburr(sp, cont1, pos1, pos2, pos3)
		psp2 <- pgmsnburr(qsp2, cont1, pos1, pos2, pos3)

		qsp3 <- qfskew.norm(sp, cont1, pos1, pos2)
		psp3 <- pfskew.norm(qsp3, cont1, pos1, pos2)

		qsp4 <- qfskew.t(sp, cont1, pos1, pos2, pos3)
		psp4 <- pfskew.t(qsp4, cont1, pos1, pos2, pos3)

		qsp5 <- qlep(sp, pos1, pos1, pos2)
		psp5 <- plep(qsp5, pos1, pos1, pos2)

		
		qsp6 <- qjskew.ep(sp, cont1, pos1, pos2,pos3)
		psp6 <- pjskew.ep(qsp6, cont1, pos1, pos2,pos3)


		#monitor# psn, psg, psl, psp, psp1, psp2, psp3, psp4, psp5, psp6


		#psp,
		#data# sp, cont1,  pos1, pos2, pos3
	
	}"
  
  
  sp <- 1:7/10
  set.seed(1)
  cont1 <- runif(1,-10,10)
  cont2 <- runif(1,-10,10)
  pos1 <- rgamma(1,1,1)
  pos2 <- rgamma(1,1,1)
  pos3 <- rgamma(1,1,1)
  
  r <- run.jags(m, burnin=100, sample=10, n.chains=1, method='rjags', summarise=FALSE)
  
  sp <- rep(sp,10)
  ps <- combine.mcmc(r,vars='ps')[1,]
  stopifnot(length(sp)==length(ps))
  if(!isTRUE(all.equal(sp,ps))){
    # Reduce stringency of the test - roughly 10^7 different on linux:
    problem <- abs(sp-ps) > max(10^-4, .Machine$double.eps^0.5)
    if(any(problem)) stop(paste("Error with ps/sp check (which expected observed):  ", paste(paste(names(ps)[which(problem)], " ", sp[problem], " ", ps[problem], ";  ", sep=""), collapse=""), sep=""))
  }
  
  cat("The neojags module tests were passed\n")
  
}else{
  cat("The neojags module tests were skipped (rjags not installed)\n")
}

cat("All module checks passed\n")

