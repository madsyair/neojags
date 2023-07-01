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
