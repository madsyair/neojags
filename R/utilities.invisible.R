getRvers <- function(){
	vers <- R.version$version.string
	version.string <- gsub("\\(.*?\\)","",vers,perl=FALSE)
	return(getvers(version.string))
}

getvers <- function(version.string){
	vers <- gsub("[[:space:]]","",gsub("[[:alpha:]]","",version.string))
	vers <- gsub("[[:punct:]]", "", gsub("."," ",vers, fixed=TRUE))
	vers <- strsplit(vers," ",fixed=TRUE)[[1]]
	version <- (10^((length(vers)-1):0))^3 * as.numeric(vers)
	version <- sum(version)
	return(version)
}

getjagsnames <- function(targets){

	retval <- unlist(lapply(1:length(targets), function(i){

		x <- targets[[i]]
		n <- names(targets)[i]
		new <- as.list(x)

		if(length(x)==1){
			names(new) <- n
			return(new)
		}
		if(!is.array(x)){
			names(new) <- paste(n, "[",1:length(x),"]",sep="")
			return(new)
		}else{
			dims <- apply(expand.grid(lapply(dim(x), function(x) return(1:x))),1,paste,collapse=",")
			names(new) <- paste(n,"[",dims,"]",sep="")
			return(new)
		}
		stop(paste("Unsupported argument type:",class(x)[1]))
	}))

	return(retval)
}

# Currently used only by glm.template - rjags and JAGS now respect initial ordering of variables:
alphabeticalvars <- function(x, always.last=c('resid.sum.sq','deviance')){

	stopifnot(is.character(x))
	stopifnot(is.character(always.last))
	stopifnot(all(!is.na(always.last)))

	splits <- strsplit(gsub(']','',x,fixed=TRUE),'[',fixed=TRUE)
	mnames <- sapply(splits, function(x) return(x[[1]]))

	indices <- lapply(splits, function(x){
		if(length(x)==1)
			return(numeric(0))
		else
			return(as.numeric(strsplit(x[2],',')[[1]]))
		})

	lengths <- sapply(indices,length)
	maxind <- max(lengths)+1

	sortmat <- matrix(0, nrow=length(x), ncol=maxind)
	for(i in 1:length(x)){
		if(lengths[i]>0)
			sortmat[i,2:(lengths[i]+1)] <- indices[[i]]
	}
	sortmat[,1] <- rank(mnames, ties.method='average')

	# If any match the always lasts chars:
	if(length(always.last)>0){
		for(i in 1:length(always.last)){
			sortmat[which(x==always.last[i]),1] <- nrow(sortmat)+i
		}
	}

	arglist <- lapply(1:ncol(sortmat), function(x) return(as.numeric(sortmat[,x])))
	return(x[do.call('order', args=arglist)])

}

getarraynames <- function(targets){

	vars <- gsub('\\[[[:print:]]*\\]','',names(targets))
	varnames <- unique(vars)
	indexes <- gsub("[[:alpha:][:punct:]]", "", gsub(","," ",names(targets)))
	indexes[indexes==""] <- 1
	dimensions <- lapply(indexes, function(y){
		if(!grepl(' ',y)) return(as.numeric(y)) else return(as.numeric(strsplit(y, split=" ",fixed=TRUE)[[1]]))		})

	if(any(sapply(varnames, function(x) return(grepl(',',x)))))
		stop("Invalid symbol in variable name")

	retlist <- lapply(varnames, function(x){
		ds <- sapply(dimensions[vars==x],length)
		stopifnot(all(ds==ds[1]))
		thisdim <- sapply(dimensions[vars==x], function(y) return(y))
		if(is.null(dim(thisdim))) dim(thisdim) <- c(1,length(thisdim))
    dims <- apply(thisdim,1,max)
		newarr <- targets[vars==x]
		dim(newarr) <- dims
		return(newarr)
	})
	names(retlist) <- varnames

	return(retlist)

}
swcat <- function(...){

  if(!runjags.getOption('silent.runjags')){
    pargs <- list(...)
    pasted <- do.call(paste, pargs)
    pasted <- gsub('\r', '\n', pasted)

    # White space is destroyed by strwrap so preserve \n by splitting on them (and append a ' ' [which is removed by strwrap anyway] to preserve any trailing \n)
    pasted <- unlist(strsplit(paste(pasted,' ',sep=''), '\n'))
    pasted <- strwrap(pasted)
    warning(paste(pasted, collapse='\n'))
  }
}


versionmatch <- function(required, actual){
	actual <- as.character(actual)

	matched <- FALSE
	for(r in as.character(required)){
		# Default:
		type <- "gteq"
		# If only an equals match precise version:
		if(grepl("=", r, fixed=TRUE)) type <- "eq"
		# Greater than takes precedence:
		if(grepl(">", r, fixed=TRUE)) type <- "gt"
		# Greater than or equal also possible:
		if(grepl(">=", r, fixed=TRUE)) type <- "gteq"
		r <- gsub(">|=", "", r)
		if((compareVersion(actual, r)==0) & (type=="eq" | type=="gteq")){
			matched <- TRUE
		}
		if((compareVersion(actual, r)==1) & (type=="gt" | type=="gteq")){
			matched <- TRUE
		}
	}

	return(matched)
}


#### Keeping in case of problems





getargs <- function(functions, passed, returnall=TRUE, otherfnames=character(0)){

	N <- length(functions)
	args <- vector('list', length=N)
	names <- vector('list', length=N)

	# Argument names for the functions relative to this function:
	for(i in 1:N){
		args[[i]] <- as.list(formals(get(functions[i], sys.frame(sys.parent(n=1)))))
		args[[i]] <- args[[i]][names(args[[i]])!="..."]
		names[[i]] <- names(args[[i]])
	}

 	argnames <- unique(unlist(names))
 	argmatch <- pmatch(names(passed), argnames)

 	if(any(is.na(argmatch))){

     nomatches <- names(passed)[which(is.na(argmatch))]

		functions <- c(otherfnames, functions)
 		functstring <- paste(if(length(functions)>1) paste(functions[1:(length(functions)-1)], collapse="', '"), if(length(functions)>1)"' or '", functions[length(functions)], "' function", if(length(functions)>1) "s", sep="")

 		argstring <- paste(if(length(nomatches)>1) "s", " '", if(length(nomatches)>1) paste(nomatches[1:(length(nomatches)-1)], collapse="', '"), if(length(nomatches)>1)"' or '", nomatches[length(nomatches)], "'", sep="")

		stop(paste("unused argument(s)", argstring, " (no unambiguous match in the '",functstring,")", sep=""), call.=FALSE)
 	}

	names(passed) <- argnames[argmatch]
	passed <- passed[!is.na(argmatch)]

	if(returnall){
		# Now get defaults from specified functions, giving priority to earlier functions if arguments appear in more than 1:
		alreadymatched <- names(passed)
		for(i in 1:N){
			newget <- names[[i]][!(names[[i]] %in% alreadymatched)]
			newargs <- lapply(newget, function(x) try(as.expression(get(x, pos=args[[i]])), silent=TRUE))
			names(newargs) <- newget
			newargs <- newargs[!sapply(newargs,class)=="try-error"]
			passed <- c(passed, newargs)
			alreadymatched <- c(alreadymatched, newget)
		}
	}
	return(passed)
}
checkmodfact <- function(tocheck, type){
	if(identical(tocheck,'')) tocheck <- list()
	stopifnot(type%in%c('module','factory'))

  	# In case any are blank:
  	if(length(tocheck)>0)
		tocheck <- tocheck[sapply(tocheck, function(x) return(!all(x=='')))]

	nl <- switch(type, module=2, factory=3)

  	if(is.character(tocheck)){
		if(length(tocheck)>0 && any(grepl(',', tocheck, fixed=TRUE)))
			stop('Use of commas in module or factory specifications is not allowed - separate name type and status with a space', call.=FALSE)
		tocheck <- gsub('[\\(\\)]',' ',tocheck)
	  	tocheck <- strsplit(gsub('[[:space:]]+', ' ', tocheck),' ')
  	}

	if(!is.list(tocheck)){
		stop(paste('Invalid ', type, ' specification - it must be either a character vector or a list', sep=''), call.=FALSE)
	}

	# If a blank list return '':
	if(identical(list(), tocheck)) return('')

  	validated <- lapply(tocheck, function(x){
		origx <- x

	  	# If not specified, assume it wants to be on:
	  	if(length(x) < nl)
			x <- c(x, "TRUE")

		# Check length is correct:
		if(length(x)!=nl)
			stop(paste('Incorrect number of elements for ', type, ' specification "', paste(origx,collapse=' '), '": ', length(origx), ' found but ', nl, ' expected', sep=''), call.=FALSE)

	  	# Replace on with TRUE and off with FALSE:
	  	x[nl] <- gsub('on','TRUE',x[nl])
	  	x[nl] <- gsub('ON','TRUE',x[nl])
	  	x[nl] <- gsub('off','FALSE',x[nl])
	  	x[nl] <- gsub('OFF','FALSE',x[nl])
	  	x[nl] <- as.character(as.logical(x[nl]))

		# Check factory type is valid:
	  	if(type=='factory' && !x[2]%in%c('sampler','monitor','rng'))
			stop(paste('The type of ', type, ' specification "', paste(origx,collapse=' '), '" must be one of sampler, monitor or rng', sep=''), call.=FALSE)

	  	# Check they are all logicable:
	  	if(is.na(x[nl]))
	  		stop(paste('The status "', origx[nl], '" of ', type, ' specification "', paste(origx, collapse=' '), '" is not interpretable as logical', sep=''), call.=FALSE)

		return(x)
	})

  validated <- unique(validated)
  if(type=='module')
    tocheck <- sapply(validated,function(x) return(x[1]))
  if(type=='factory')
    tocheck <- sapply(validated,function(x) return(paste(x[1],x[2],sep=' ')))
	if(length(unique(tocheck))!=length(tocheck))
		stop(paste('Replicated ', type, ' name(s) with conflicting status in "', paste(sapply(validated,paste,collapse=' '), collapse=', '), '"', sep=''), call.=FALSE)
	if(identical(list(), validated)) validated <- ''

	return(validated)
}

checkvalidforjags <- function(object){

	if(length(object)==1 && is.na(object)) return(list(valid=TRUE, probstring=""))

	if(inherits(object, "runjagsdata") || inherits(object, "runjagsinits")) class(object) <- "character"
	if(!is.list(object) && !is.character(object)) return(list(valid=FALSE, probstring="object must be either a named list or a character vector in the R dump format"))

	if(!is.list(object)) object <- list.format(object, checkvalid=FALSE)

	if(any(names(object) == "")){
		return(list(valid=FALSE, probstring="missing variable name(s)"))
	}

	if(!length(unique(names(object))) == length(object)){
		return(list(valid=FALSE, probstring="duplicated variable name(s)"))
	}

	problems <- sapply(object, function(x){

		# Catch potential problems with the data being passed through:
		if(length(x)==0){
			return("")
		}
		if(is.null(x)){
			return("NULL")
		}
		if(inherits(x, "data.frame")){
			return("inherits from class 'data.frame' - try converting it to a valid type using as.matrix")
		}
		if(length(x)==0){
			return("length zero")
		}
		if(inherits(x, "logical") && !all(is.na(x))){
			return("TRUE/FALSE")
		}
		if(inherits(x,"character") && !all(is.na(x))){
			return("character")
		}
		if(inherits(x,"factor") && !all(is.na(x))){
			return("factor")
		}
		if(any(x==Inf, na.rm=TRUE)){
			return("Inf")
		}
		if(any(x==-Inf, na.rm=TRUE)){
			return("Inf")
		}
		return("")
	})

	problems[names(problems)==".RNG.name"] <- ""

	if(all(problems=="")){
		return(list(valid=TRUE, probstring=""))
	}else{
		problems <- problems[problems!=""]
		probstring <- paste("invalid variable value(s) - ", paste(names(problems), " (", problems, ")", sep=""), collapse=", ", sep="")
		return(list(valid=FALSE, probstring=probstring))
	}

}

loadandcheckrjags <- function(stop=TRUE, silent=FALSE){

	fail <- FALSE

	if(!any(.packages(TRUE)=="rjags")){
		if(!silent)
			swcat("\nThe rjags package is not installed - either install the package from CRAN or from https://sourceforge.net/projects/mcmc-jags/files/rjags/\n")
		fail <- TRUE
	}

	if(!fail && !requireNamespace("rjags")){
		if(!silent)
			swcat("\nThe rjags package is installed, but could not be loaded - run the testjags() function for more detailed information\n", sep="")
		fail <- TRUE
	}
	if(!fail && packageVersion('rjags') < "3.9"){
		if(!silent)
			swcat("\nPlease update the rjags package to version 3-9 or later\n", call.=FALSE)
		fail <- TRUE
	}

	if(fail && stop)
		stop("Loading the rjags package failed (diagnostics are given above this error message)", call.=FALSE)

	return(!fail)
}

jags_obs_stoch_var_name <- "_osv_"

# Utility function to determine if we should generate JAGS 5 compatible code (currently a placeholder):
jags5 <- function() FALSE

