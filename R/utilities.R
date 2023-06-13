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
#' @importFrom runjags new_unique
#' @importFrom runjags timestring

neojagsprivate <- new.env()
# Use 'expression' for functions to avoid having to evaluate before the package is fully loaded:
assign("defaultoptions",list(jagspath=expression(findjags()),method=expression(if('rjags' %in% .packages(TRUE)){'rjags'}else{if(Sys.info()['user']=='nobody') 'simple' else 'interruptible'}), tempdir=TRUE, plot.layout=c(2,2), new.windows=TRUE, modules="", factories="", bg.alert='beep', linenumbers=TRUE, inits.warning=TRUE, rng.warning=TRUE, summary.warning=TRUE, blockcombine.warning=TRUE, blockignore.warning=TRUE, tempdir.warning=FALSE, nodata.warning=TRUE, adapt.incomplete='warning', repeatable.methods=FALSE, silent.jags=FALSE, silent.runjags=FALSE, predraw.plots=FALSE, force.summary=FALSE, mode.continuous=expression('modeest' %in% .packages(TRUE)), timeout.import=30, partial.import=FALSE, keep.crashed.files=TRUE, full.cleanup=FALSE, debug=FALSE, jags5=FALSE), envir=neojagsprivate)

assign("simfolders", character(0), envir=neojagsprivate)
assign("failedsimfolders", character(0), envir=neojagsprivate)
assign("minjagsmajor", 3, envir=neojagsprivate)
assign("maxjagsmajor", 4, envir=neojagsprivate)
assign("warned_version_mismatch", FALSE, envir=neojagsprivate)