#' Load the internal JAGS module provided by neojags
#'
#' @name load.neojagsmodule
#' @aliases load.neojagsmodule load.neojagsmodule unload.neoJAGSmodule unload.neoJAGSmodule
#'
#' @description
#' The neojags package contains a JAGS extension module that provides several additional distributions for use within JAGS (see details below).  This function is a simple wrapper to load this module.  The version of the module supplied within the neojags package can only be used with the rjags package, or with the rjags or rjparallel methods within runjags.  For a standalone JAGS module for use with any JAGS method (or independent JAGS runs) please see: https://sourceforge.net/projects/neojags/
#'
#' @details
#' This module provides the following distributions for JAGS:
#' 
#' Jones'S Skew Exponential Power: djskew.ep(mu, tau, nu1, nu2)
#' 
#' For \eqn{y<\mu}{y<\mu}:
#' \deqn{
#'   p(y) = c\sqrt{\tau }\exp \left[ -{{\left| \sqrt{\tau }(y-\mu ) \right|}^{{{\nu }_{1}}}} \right] 
#' }{
#'   p(y) = c\sqrt{\tau }\exp [ -{{| \sqrt{\tau }(y-\mu ) |}^{{{\nu }_{1}}}} ] 
#' }
#' 
#' For \eqn{y \ge \mu}{y \ge \mu}:
#' \deqn{
#'   p(y) = c\sqrt{\tau }\exp \left[ -{{\left| \sqrt{\tau }(y-\mu ) \right|}^{{{\nu }_{2}}}} \right]
#' }{
#'   p(y) = c\sqrt{\tau }\exp [ -{{| \sqrt{\tau }(y-\mu ) |}^{{{\nu }_{2}}}} ]
#' }
#' 
#' where 
#' 
#' \deqn{c = {{\left[ \Gamma \left( 1+{{\nu }_{1}}^{-1} \right)+\Gamma \left( 1+{{\nu }_{2}}^{-1} \right) \right]}^{-1}}}{c = {{\left[ \Gamma \left( 1+{{\nu }_{1}}^{-1} \right)+\Gamma \left( 1+{{\nu }_{2}}^{-1} \right) \right]}^{-1}}}
#' 
#' \deqn{-\infty < \mu < \infty, \tau > 0, \nu_1 > 0, \nu_2 > 0}{-\infty < \mu < \infty, \tau > 0, \nu_1 > 0, \nu_2 > 0}
#' 
#' 
#' GMSNBurr: dgmsnburr(mu, tau,alpha1,alpha2)
#' 
#' \deqn{
#'   p(y) = \frac{\tau \omega \left( {{\alpha }_{1}},{{\alpha }_{2}} \right)}{B\left( {{\alpha }_{1}},{{\alpha }_{2}} \right)}{{\left( \frac{{{\alpha }_{2}}}{{{\alpha }_{1}}} \right)}^{{{\alpha }_{2}}}}\frac{\exp \left( -{{\alpha }_{2}}\tau \omega \left( {{\alpha }_{1}},{{\alpha }_{2}} \right)\left( y-\mu  \right) \right)}{{{\left( 1+\frac{{{\alpha }_{2}}}{{{\alpha }_{1}}}\exp \left( -\tau \omega \left( {{\alpha }_{1}},{{\alpha }_{2}} \right)\left( y-\mu  \right) \right) \right)}^{({{\alpha }_{1}}+{{\alpha }_{2}})}}}
#' }{
#'   p(y) = (\tau \omega ( {{\alpha }_{1}},{{\alpha }_{2}} )) / (B( {{\alpha }_{1}},{{\alpha }_{2}} )) {{( ({{\alpha }_{2}}) / ({{\alpha }_{1}}))}^{{{\alpha }_{2}}}} (\exp ( -{{\alpha }_{2}}\tau \omega ( {{\alpha }_{1}},{{\alpha }_{2}} \right)\left( y-\mu  \right) \right)) / ({{\left( 1+\frac{{{\alpha }_{2}}}{{{\alpha }_{1}}}\exp \left( -\tau \omega \left( {{\alpha }_{1}},{{\alpha }_{2}} \right)\left( y-\mu  \right) \right) \right)}^{({{\alpha }_{1}}+{{\alpha }_{2}})}})
#' }
#' 
#' where 
#' 
#' \deqn{
#' {\omega \left( {{\alpha }_{1}},{{\alpha }_{2}} \right)=\frac{B\left( {{\alpha }_{1}},{{\alpha }_{2}} \right)}{\sqrt{2\pi }}{{\left( 1+\frac{{{\alpha }_{2}}}{{{\alpha }_{1}}} \right)}^{\left( {{\alpha }_{1}}+{{\alpha }_{2}} \right)}}{{\left( \frac{{{\alpha }_{2}}}{{{\alpha }_{1}}} \right)}^{-{{\alpha }_{2}}}}}{\omega \left( {{\alpha }_{1}},{{\alpha }_{2}} \right)=\frac{B\left( {{\alpha }_{1}},{{\alpha }_{2}} \right)}{\sqrt{2\pi }}{{\left( 1+\frac{{{\alpha }_{2}}}{{{\alpha }_{1}}} \right)}^{\left( {{\alpha }_{1}}+{{\alpha }_{2}} \right)}}{{\left( \frac{{{\alpha }_{2}}}{{{\alpha }_{1}}} \right)}^{-{{\alpha }_{2}}}}}
#' }
#' 
#' \deqn{-\infty < \mu < \infty, \tau > 0, \alpha_1 > 0, \alpha_2 > 0}{-\infty < \mu < \infty, \tau > 0, \alpha_1 > 0, \alpha_2 > 0}
#' 
#' 
#' MSNBurr: dmsnburr(mu, tau,alpha)
#' 
#' \deqn{
#'  p(y) = \frac{\tau \omega (\alpha )\exp \left( -\tau \omega (\alpha )(y-\mu ) \right)}{{{\left( 1+\frac{\exp \left( -\tau \omega (\alpha )(y-\mu ) \right)}{\alpha } \right)}^{\left( \alpha +1 \right)}}} 
#' }{
#'  p(y) = (\tau \omega (\alpha )\exp \left( -\tau \omega (\alpha )(y-\mu ) \right)) / ({{\left( 1+\frac{\exp \left( -\tau \omega (\alpha )(y-\mu ) \right)}{\alpha } \right)}^{\left( \alpha +1 \right)}})
#' }
#'
#' where 
#'
#' \deqn{
#' {\omega \left( \alpha  \right)=\frac{1}{\sqrt{2\pi }}{{\left( 1+\frac{1}{\alpha } \right)}^{\left( \alpha +1 \right)}}}{\omega \left( \alpha  \right)=\frac{1}{\sqrt{2\pi }}{{\left( 1+\frac{1}{\alpha } \right)}^{\left( \alpha +1 \right)}}}
#' }
#'
#' \deqn{- \infty < \mu < \infty , \tau > 0, \alpha > 0}{-\infty < \mu < \infty , \tau > 0, \alpha > 0}
#'
#'
#' MSNBurr-IIa: dmsnburr2a(mu, tau, alpha)
#' 
#' \deqn{
#'  p(y) = \frac{\tau \omega (\alpha )\exp \left( \tau \omega (\alpha )\left( y-\mu  \right) \right)}{{{\left( 1+\frac{\exp \left( \tau \omega (\alpha )\left( y-\mu  \right) \right)}{\alpha } \right)}^{\left( \alpha +1 \right)}}}
#' }{
#'  p(y) = (\tau \omega (\alpha )\exp \left( \tau \omega (\alpha )\left( y-\mu  \right) \right)) / ({{\left( 1+\frac{\exp \left( \tau \omega (\alpha )\left( y-\mu  \right) \right)}{\alpha } \right)}^{\left( \alpha +1 \right)}})
#' }
#' 
#' \deqn{-\infty < \mu < \infty , \tau > 0, \alpha > 0}{-\infty < \mu < \infty, \tau > 0, \alpha > 0}
#' 
#' 
#' Fernandez-Osiewalski-Steel Skew Exponential Power: dfskew.ep(mu, tau, nu, alpha)
#' 
#' 
#' For \eqn{y<\mu}{y<\mu}:
#' \deqn{
#'   p(y) = c\sqrt{\tau }\exp \left[ -\frac{1}{2}{{\left| \alpha \sqrt{\tau }\left( y-\mu  \right) \right|}^{\nu }} \right] 
#' }{
#'   p(y) = c\sqrt{\tau }\exp [ -(1/2) {{| \alpha \sqrt{\tau } ( y-\mu) |}^{\nu }} ] 
#' }
#' 
#' For \eqn{y \ge \mu}{y \ge \mu}:
#' \deqn{
#'   p(y) = c\sqrt{\tau }\exp \left[ -\frac{1}{2}{{\left| \frac{\sqrt{\tau }\left( y-\mu  \right)}{\alpha } \right|}^{\nu }} \right] 
#' }{
#'   p(y) = c\sqrt{\tau }\exp [ -(1/2){{| (\sqrt{\tau }\left( y-\mu  \right)) / (\alpha)  \right|}^{\nu }} \right] 
#' }
#' 
#' where 
#' 
#' \deqn{c = \alpha \nu {{\left[ \left( 1+{{\alpha }^{2}} \right){{2}^{1/\tau }}\Gamma (1/\nu ) \right]}^{-1}}}{c = \alpha \nu {{\left[ \left( 1+{{\alpha }^{2}} \right){{2}^{1/\tau }}\Gamma (1/\nu ) \right]}^{-1}}}
#' 
#' \deqn{-\infty < \mu < \infty , \tau > 0 , \nu > 0 , \alpha > 0}{-\infty < \mu < \infty , \tau > 0 , \nu > 0 , \alpha > 0}
#'  
#' 
#' Fernandes Steel Skew-t: dfskew.t(mu, tau, nu, alpha)
#' 
#' For \eqn{y<\mu}{y<\mu}:
#' \deqn{
#'   p(y) = c\sqrt{\tau }{{\left( 1+\frac{{{\alpha }^{2}}\tau {{(y-\mu )}^{2}}}{\nu } \right)}^{-(\nu +1)/2}}
#' }{
#'   p(y) = c\sqrt{\tau }{{( 1+({{\alpha }^{2}}\tau {{(y-\mu )}^{2}}) / (\nu) )}^{-(\nu +1)/2}}
#' }
#' 
#' For \eqn{y \ge \mu}{y \ge \mu}:
#' \deqn{
#'   p(y) = c\sqrt{\tau }{{\left( 1+\frac{\tau {{(y-\mu )}^{2}}}{{{\alpha }^{2}}\nu } \right)}^{-(\nu +1)/2}}
#' }{
#'   p(y) = c\sqrt{\tau }{{( 1+(\tau {{(y-\mu )}^{2}}) / ({{\alpha }^{2}}\nu ) )}^{-(\nu +1)/2}}
#' }
#' 
#' where 
#' 
#' \deqn{c = 2\alpha {{\left[ \left( 1+{{\alpha }^{2}} \right)B(1/2,\nu /2){{\nu }^{1/2}} \right]}^{-1}}}{c = 2\alpha {{\left[ \left( 1+{{\alpha }^{2}} \right)B(1/2,\nu /2){{\nu }^{1/2}} \right]}^{-1}}}
#' 
#' \deqn{-\infty < \mu < \infty , \tau > 0 , \nu > 0 , \alpha > 0}{-\infty < \mu < \infty , \tau > 0 , \nu > 0 , \alpha > 0}
#' 
#' 
#' Fernandes Steel Skew Normal: dfskew.norm(mu, tau, alpha)
#' 
#' For \eqn{y<\mu}{y<\mu}:
#' \deqn{
#'   p(y) = \frac{2\alpha \sqrt{\tau }}{\sqrt{2\pi }(1+{{\alpha }^{2}})}{\exp}\left( -\frac{{{\alpha }^{2}}\tau }{2}{{(y-\mu )}^{2}} \right)
#' }{
#'   p(y) = {2\alpha \sqrt{\tau }} / (\sqrt{2\pi }(1+{{\alpha }^{2}})){\exp}( -({{\alpha }^{2}}\tau)  / (2){{(y-\mu )}^{2}} )
#' }
#' 
#' For \eqn{y \ge \mu}{y \ge \mu}:
#' \deqn{
#'   p(y) = \frac{2\alpha \sqrt{\tau }}{\sqrt{2\pi }(1+{{\alpha }^{2}})}{\exp}\left( -\frac{\tau }{2{{\alpha }^{2}}}{{(y-\mu )}^{2}} \right)
#' }{
#'   p(y) = (2\alpha \sqrt{\tau }) / (\sqrt{2\pi }(1+{{\alpha }^{2}})){\exp}( - \tau  / (2{{\alpha }^{2}}){{(y-\mu )}^{2}})
#' }
#' 
#' \deqn{-\infty < \mu < \infty, \tau > 0, \alpha > 0}{-\infty < \mu < \infty, \tau > 0, \alpha > 0}
#' 
#' 
#' Lunetta Exponential Power : dlep(mu, tau, nu)
#' 
#' \deqn{
#'   p(y) = \frac{\sqrt{\tau }}{2{{\nu }^{1/\nu }}\Gamma (1+1/\nu )}{{e}^{-\frac{1}{\nu }{{\left| \sqrt{\tau }(y-\mu ) \right|}^{\nu }}}} 
#' }{
#'   p(y) = {\sqrt{\tau }}/{2{{\nu }^{1/\nu }}\Gamma (1+1/\nu )}{{e}^{-{1}/{\nu }{{| \sqrt{\tau }(y-\mu ) |}^{\nu }}}} 
#' }
#'
#' \deqn{-\infty < \mu < \infty, \tau > 0, \nu > 0}{-\infty < \tau < \infty, \tau > 0, \nu > 0}
#'
#' For an easier to read version of these PDF equations, see the userguide vignette.
#'
#' @param fail should the function fail using stop() if the module cannot be loaded?
#' @param silent if !fail, the function will by default print a diagnostic message if the module cannot be loaded - the silent option suppresses this message.
#'
#' @return Invisibly returns TRUE if able to (un)load the module, or FALSE otherwise
#' @keywords methods
#' @seealso
#'  \code{\link[rjags]{load.module}}
#'
#' @references
#' Choir, A. S. 2020. The New Neo-Normal Distributions and Their Properties, Doctoral dissertation, Institut Teknologi Sepuluh November.
#' 
#' Denwood, M.J. 2016. runjags: An R Package Providing Interface Utilities, Model Templates, Parallel Computing Methods and Additional Distributions for MCMC Models in JAGS. J. Stat. Softw. 71. doi:10.18637/jss.v071.i09.
#'
#' Fernandez, C., Osiewalski, J., & Steel, M. F. 1995. Modeling and inference with v-spherical distributions. Journal of the American Statistical Association, 90(432), 1331-1340.
#'
#' Fernandez, C., & Steel, M. F. 1998. On Bayesian modeling of fat tails and skewness. Journal of the american statistical association, 93(441), 359-371.
#'
#' Iriawan, N. 2000. Computationally Intensive Approaches to Inference in NeoNormal Linear Models, Doctoral dissertation, Curtin University of Technology, Perth, Australia.
#' 
#' Rigby, R. A., & Stasinopoulos, D. M. 2005. Generalized additive models for location, scale and shape. Journal of the Royal Statistical Society: Series C (Applied Statistics), 54(3), 507-554.
#' 
#' Lunetta, G. 1963. Di una Generalizzazione dello Schema della Curva Normale. Annali della Facolt`a di Economia e Commercio di Palermo, 17, 237–244. 
#' 
#' Rigby, R. A., Stasinopoulos, M. D., Heller, G. Z., & Bastiani, F. D. 2019. Distributions for Modeling Location, Scale, and Shape: Using GAMLSS in R. CLC Press.
#'
#' @examples
#' # Load the module for use with any rjags model:
#' available <- neojags::load.neojagsmodule(fail=FALSE)
#' if(available){
#' # A simple model to sample from a Jones's Skew Exponential Power Distribution distribution.
#' # (Requires the rjags or rjparallel methods)
#' m <- "model{
#'  L ~ djskew.ep(0,1,2,2)
#' 		}"
#' \donttest{
#' library(runjags)
#' neojags::load.neojagsmodule()
#' results <- run.jags(m, monitor="L", method="rjags")
#' }
#' }

#' @rdname load.neojagsmodule
#' @export
load.neojagsmodule <- function(fail=TRUE, silent=FALSE){
	intfun <- function(){
	 	# Make sure this is not the module-less version from sourceforge:
	  	if(neojagsprivate$modulelocation=='')
	  		return('The internal neojags module is not installed - please reinstall the full version of the package from CRAN, or alternatively you can download a standalone version of the JAGS module from the sourceforge page at http://sourceforge.net/projects/neojags/')
	 #  neojagsprivate$modulelocation==''
		# Also makes sure JAGS is installed:
		if(!loadandcheckrjags(FALSE))
			return("The rjags package is required to use the internal neojags module - alternatively you can download a standalone version of the JAGS module from the sourceforge page at http://sourceforge.net/projects/neojags/")

		# Check the JAGS major version is as expected:
		if(packageVersion('rjags')$major < neojagsprivate$minjagsmajor)
			return(paste('JAGS version ', neojagsprivate$minjagsmajor, '.x.x to ', neojagsprivate$maxjagsmajor, '.x.x is required for this version of the neojags module - please update JAGS and rjags',sep=''))
		if(packageVersion('rjags')$major > neojagsprivate$maxjagsmajor)
			return(paste('This version of theneojags module was designed for JAGS version ', neojagsprivate$minjagsmajor, '.x.x to ', neojagsprivate$maxjagsmajor, '.x.x - please update the neojags package', sep=''))

		success <- try(rjags::load.module('neojags',neojagsprivate$modulelocation))

		if(inherits(success, 'try-error')){

			rvers <- paste('version ', R.version$major, sep='')
			if(grepl('mac.binary', .Platform$pkgType, fixed=TRUE)){
				# A specific error may be because of SL vs Mavericks version on OS X for JAGS version 3.4:
				mavericks <- grepl('mavericks', .Platform$pkgType)
				if(mavericks)
					rvers <- paste(rvers, ' - Mavericks', sep='')
				else
					rvers <- paste(rvers, ' - Snow Leopard', sep='')
			}

			return(paste("The internal neojags module could not be loaded - perhaps the package was not built using the same versions of R [", rvers, "] and JAGS [version ", testjags(silent=TRUE)$JAGS.version, "] as available on this system?", sep=''))

		}
		return(TRUE)
	}

	retval <- intfun()

	if(retval==TRUE){
		invisible(TRUE)
	}else{
		if(fail)
			stop(retval)

		if(!silent)
			swcat(retval,'\n',sep='')

		invisible(FALSE)
	}
}

#' @rdname load.neojagsmodule
#' @export
unload.neojagsmodule <- function(){

	if(!loadandcheckrjags(FALSE))
		stop("The rjags package is required to use the internal neojags module - alternatively you can download a standalone version of the JAGS module from the sourceforge page at http://sourceforge.net/projects/neojags/")

	suppressWarnings(success <- try(rjags::unload.module('neojags')))

	if(inherits(success, 'try-error')){
		warning("There was a problem unloading the internal neojags module - if you installed this package from CRAN, please file a bug report to the package author")
		invisible(FALSE)
	}else{
		invisible(TRUE)
	}
}

#' @rdname load.neojagsmodule
#' @export
load.neoJAGSmodule <- load.neojagsmodule

#' @rdname load.neojagsmodule
#' @export
unload.neoJAGSmodule <- unload.neojagsmodule


# These utility functions are NOT exported, and are primarily used for unit testing.
# Availability and/or operation of these functions may change without warning.

dynloadmodule <- function(){

	# Sets environmental variables we need for Windows:
	if(.Platform$OS.type=='windows'){
		if(!loadandcheckrjags(FALSE))
			stop('The rjags package is required to load the internal dynlib')
	}

	if(neojagsprivate$modulelocation==''){
		warning('The neojags module has not been installed with this version of the package - try again using the CRAN binary')
		invisible(FALSE)
	}

	# Check the JAGS major version is as expected:
	if(testjags(silent=TRUE)$JAGS.major < neojagsprivate$minjagsmajor)
		return(paste('JAGS version ', neojagsprivate$minjagsmajor, '.x.x to ', neojagsprivate$maxjagsmajor, '.x.x is required for this version of the neojags module - please update JAGS and rjags',sep=''))
	if(testjags(silent=TRUE)$JAGS.major > neojagsprivate$maxjagsmajor)
		return(paste('This version of the neojags module was designed for JAGS version ', neojagsprivate$minjagsmajor, '.x.x to ', neojagsprivate$maxjagsmajor, '.x.x - please update the neojags package', sep=''))

	# Find and load the neojags shared library (only required for these tests and using the rjags call 'load.modue()' so NOT loaded at runtime):
	slibpath <- file.path(neojagsprivate$modulelocation, paste('neojags', .Platform$dynlib.ext, sep=''))
	swcat("Loading shared library from:  ", slibpath, "\n", sep="")
	success <- try(dyn.load(slibpath))

	if(inherits(success, 'try-error')){

		rvers <- paste('version ', R.version$major, sep = '')
		if(grepl('mac.binary', .Platform$pkgType, fixed = TRUE)){
			# A specific error may be because of SL vs Mavericks version on OS X for JAGS version 3.4:
			mavericks <- grepl('mavericks', .Platform$pkgType)
			if( mavericks)
				rvers <- paste(rvers, ' - Mavericks', sep='')
			else
				rvers <- paste(rvers, ' - Snow Leopard', sep = '')
		}

		return(paste("The neojags dynlib could not be loaded - perhaps the package was not built using the same versions of R [", rvers, "] and JAGS [version ", testjags(silent = TRUE)$JAGS.version, "] as available on this system?", sep = ''))

	}

	neojagsprivate$dynlibname <- success
	invisible(TRUE)

}

dynunloadmodule <- function(){

if(is.null(neojagsprivate$dynlibname)){
		warning('Unable to load the dynlib as it has not been loaded')
		invisible(FALSE)
	}
	# Find and unload the neojags shared library (only required for these tests and using the rjags call 'load.modue()' so NOT loaded at runtime):
	slibpath <- system.file("libs", paste(.Platform$r_arch, if(.Platform$r_arch != "") "/" else "", if(.Platform$OS.type=="unix") "neojags.so" else "neojags.dll", sep=""), package="neojags")
	swcat("Unloading shared library from:  ", slibpath, "\n", sep = "")
	success <- try(dyn.unload(slibpath))
	if(inherits(success, 'try-error'))
		warning("The internal dynlib could not be unloaded")

	neojagsprivate$dynlibname <- NULL
	invisible(TRUE)
}

useneojagsmodule <- function(distribution, funtype, parameters, x, uselog=FALSE, lower=TRUE){

	if(is.null(neojagsprivate$dynlibname)){
		stopifnot(dynloadmodule())
	}

	if(!is.character(distribution)) stop("The distribution type must be one of par1, par2, par3, par4, lomax, mouch, genpar or halfcauchy")
	disttype <- switch(distribution, par1=1, par2=2, par3=3, par4=4, lomax=5, mouch=6, genpar=7, hcauchy=8, halfcauchy=8, 0)
	if(disttype==0) stop("The distribution type must be one of par1, par2, par3, par4, lomax, mouch, genpar or halfcauchy")

	if(!is.character(funtype)) stop("The function type must be one of d, p and q")
	dpqr <- switch(funtype, d=1, p=2, q=3, r=4, 0)
	if(dpqr==0) stop("The function type must be one of d, p and q")
	if(dpqr==4) stop("The function type must be one of d, p and q - r is not available")

	npars <- length(parameters)
	N <- length(x)
	values <- numeric(N)

	# Having problems with bools on sparc, so use ints here:
	output <- .C("testneojags",disttype=as.integer(disttype),dpqr=as.integer(dpqr),uselog=as.integer(uselog),lower=as.integer(lower),N=as.integer(N), x=as.double(x),npars=as.integer(npars),parameters=as.double(parameters),values=as.double(values),status=integer(1),PACKAGE='neojags')

	if(output$status==1) stop("Incorrect number of parameters provided")
	if(output$status==2) stop("Unrecognised distribution type")
	if(output$status==3) stop("Invalid parameter values provided")
	if(output$status==4) stop("Function type not valid")
	if(output$status==5) stop("Function type not valid")

	return(output$values)

}
