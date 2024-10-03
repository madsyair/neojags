#' @import utils
#' @import coda
#' @import stats
#' @import runjags
#' @import rjags
#' @importFrom stats na.omit
#' @importFrom utils capture.output compareVersion data find flush.console packageVersion packageDescription read.csv read.table
#' @importFrom runjags findjags testjags run.jags 
#' @importFrom rjags jags.model

.onLoad <- function(libname, pkgname){

	neojagsprivate$neojagsversion <- utils::packageDescription(pkgname, fields='Version')

	# Get and save the library location, getting rid of any trailing / caused by r_arch being empty:
	modloc <- gsub('/$','', file.path(libname, pkgname, 'libs', if(.Platform$r_arch!="") .Platform$r_arch else ""))
	if(!file.exists(file.path(modloc, paste('neojags', .Platform$dynlib.ext, sep=''))))
		modloc <- ''
	neojagsprivate$modulelocation <- modloc


	# To ensure that cleanup.jags is run when R is quit:
	reg.finalizer(neojagsprivate, .onDetach, onexit = TRUE)
}


.onDetach <- function(libpath){
	# Just in case it is not always safe to try and access an element of an env that is in the process of being deleted (when R quits):
	if(!is.null(neojagsprivate$dynlibname)) dynunloadmodule()
}
