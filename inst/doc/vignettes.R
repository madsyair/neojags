## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----setup--------------------------------------------------------------------
if (requireNamespace("neojags", quietly = TRUE)){
	  neojags::load.neojagsmodule()
} 
if (requireNamespace("neojags", quietly = TRUE)){
	  library(rjags)
} 

## -----------------------------------------------------------------------------
mod <- "
model {
  # Likelihood
  for (i in 1:100) {
    x[i] ~ djskew.ep(2,1,0.8,1)
  }
}
"

## -----------------------------------------------------------------------------
modelv <- jags.model(textConnection(mod), n.chains=1, inits = list(".RNG.name" = "base::Wichmann-Hill",".RNG.seed" = 314159))

## -----------------------------------------------------------------------------
samplesv <- coda.samples(modelv, variable.names = c("x"), n.iter = 1)
gen_datav <- (as.data.frame(as.matrix(samplesv)))
x <- as.numeric(gen_datav[1,])

## -----------------------------------------------------------------------------
model_string <- "
model {
  # Likelihood
  for (i in 1:100) {
    x[i] ~ djskew.ep(mu, tau,nu1, nu2)
  }
  
  # Prior distributions
  mu ~ dnorm(2,10000)
  tau ~ dgamma(10,10)
  nu1 ~ dgamma(10,10)
  nu2 ~ dgamma(10,10)
}
"

## -----------------------------------------------------------------------------
model <- jags.model(textConnection(model_string), data = list(x=c(x)),n.chains=2)

## -----------------------------------------------------------------------------
samples<- coda.samples(model, variable.names = c("mu", "tau", "nu1", "nu2"), n.iter = 2000)

## -----------------------------------------------------------------------------
summary(samples)

## -----------------------------------------------------------------------------
traceplot(samples)

## -----------------------------------------------------------------------------
model_string1 <- "
model {
    d <- djskew.ep(0.5,2,2,2,2)
		p <- pjskew.ep(0.5,2,2,2,2)
		q <- qjskew.ep(0.5,2,2,2,2)
}
"

## -----------------------------------------------------------------------------
model1 <- jags.model(textConnection(model_string1),  n.chains=2)

## -----------------------------------------------------------------------------
samples1<- coda.samples(model1, variable.names = c("d","p","q"), n.iter = 2)

## -----------------------------------------------------------------------------
summary(samples1)

