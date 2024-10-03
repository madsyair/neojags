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