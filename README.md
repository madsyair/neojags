# neojags

**neojags** is an R package that serves as a *JAGS extension module*, providing a family of "neo-normal" distributions for use in Bayesian models. JAGS (Just Another Gibbs Sampler) is a popular engine for Markov Chain Monte Carlo (MCMC) sampling, and `neojags` extends JAGS by adding several flexible distributions that relax the assumptions of normality (allowing for skewness and heavy tails). These distributions can be used as priors or likelihoods in JAGS models to better fit data that exhibit skewed or heavy-tailed behavior. The package is useful in situations where a standard Normal or t-distribution is too restrictive, offering more flexibility in modeling data.

`neojags` is available on both [CRAN](https://cran.r-project.org/package=neojags) and [GitHub](https://github.com/madsyair/neojags). It was developed by Achmad Syahrul Choir *et al.* as part of research on neo-normal distributions for robust statistical modeling. The module works with **JAGS version 4.3.0 or higher**, so make sure you have a compatible JAGS installation.

## Installation

You can install the stable release of **neojags** from CRAN or the development version from GitHub:

-   **Install from CRAN:** In R, you can install the package directly from CRAN with:

    ``` r
    install.packages("neojags")
    ```

-   **Install from GitHub:** You can install the latest development version from the GitHub repository (assuming you have the **devtools** or **remotes** package installed):

    ``` r
    # install.packages("devtools")  # run this if devtools is not yet installed
    devtools::install_github("madsyair/neojags")
    ```

After installation, **neojags** needs **JAGS** to be installed on your system (JAGS is external to R). Ensure that JAGS (\>= 4.3.0) is installed and accessible. On Windows, you might need to have JAGS in your PATH or specify its location if building from source. On most systems, if JAGS is installed, the R package will find it automatically.

## Supported Distributions

The **neojags** module introduces a family of neo-normal distributions in JAGS. These distributions extend or generalize the normal distribution by introducing one or more shape parameters to capture skewness and kurtosis variations. The following distributions are included:

-   **MSNBurr** – A neo-normal distribution derived from a modification of the Burr Type II distribution (also known as "Modified to be Stable as Normal Burr"). It has a single shape parameter that allows tails heavier than the normal distribution.
-   **MSNBurr-IIa** – A variant of the MSNBurr distribution (sometimes called Type IIa Burr modification). It also uses one shape parameter but with a slightly different formulation, providing an alternative way to model asymmetry or tail behavior.
-   **GMSNBurr** – The Generalized MSNBurr distribution with two shape parameters. This generalization offers even more flexibility in modeling the tail heaviness and asymmetry by allowing separate control of two shape parameters.
-   **Lunetta Exponential Power** – An exponential power distribution as proposed by Lunetta (1963). This distribution generalizes the normal by a kurtosis parameter (similar to a Subbotin or generalized Gaussian distribution), allowing the peak and tails to vary from sharp (platykurtic) to heavy-tailed (leptokurtic).
-   **Fernandez–Steel Skew t** – A skewed version of the Student-t distribution introduced by Fernández and Steel (1998). It adds a skewness parameter to the t-distribution, permitting asymmetry in addition to the heavy tails of the t-distribution.
-   **Fernandez–Steel Skew Normal** – A skewed version of the Normal distribution (also by Fernández and Steel). It introduces a shape (skewness) parameter to the normal distribution, allowing the distribution to lean to the left or right instead of being symmetric.
-   **Fernandez–Osiewalski–Steel Skew Exponential Power** – A skewed exponential power distribution from Fernández, Osiewalski, and Steel (1995). This distribution has parameters to control both skewness and tail thickness, generalizing the exponential power (EP) distribution with asymmetry.
-   **Jones’s Skew Exponential Power** – A two-parameter skew exponential power distribution (as formulated by a method of M. C. Jones). It has separate tail parameters for the left and right sides, which means it can model distributions with different degrees of heaviness in the left vs right tails (a very flexible skewed distribution).

In JAGS model syntax, each of these distributions is available as a probability distribution function prefixed with `d` (for "density"), similar to how you would use `dnorm` or `dt`. For example, the MSNBurr distribution is used as `dmsnburr(mu, tau, alpha)` inside a JAGS model, and the Jones’s Skew Exponential Power is `djskew.ep(mu, tau, nu1, nu2)`. All distributions follow the parameterization given in the package documentation (generally `mu` is a location parameter, `tau` is a precision or scale parameter similar to 1/σ², and the additional parameters like `alpha`, `nu`, etc., are shape parameters specific to each distribution).

## Basic Example

Below is a basic example of how to use **neojags** in a JAGS model. In this example, we will sample from one of the neo-normal distributions as a demonstration:

``` r
# Load R packages
library(rjags)      # for interfacing with JAGS
library(neojags)    # contains the neo-normal JAGS module

# Load the neojags module into JAGS (so JAGS knows about the new distributions)
load.neojagsmodule()

# Define a simple JAGS model string using an MSNBurr distribution for a parameter
model_string <- "
model {
  # Prior for theta using the MSNBurr distribution (mu=0, tau=1, alpha=1)
  theta ~ dmsnburr(0, 1, 1)
}
"

# Initialize and run the JAGS model
jags_model <- jags.model(textConnection(model_string), data=list(), inits=list(theta=0), n.chains=1)
update(jags_model, 1000)  # burn-in iterations
samples <- coda.samples(jags_model, variable.names="theta", n.iter=5000)

# Inspect the results (e.g., summary of the sampled theta values)
summary(samples)
```

In this model, we used `theta ~ dmsnburr(0, 1, 1)` to specify that the parameter `theta` is distributed according to an MSNBurr distribution with location `mu = 0`, precision `tau = 1`, and shape `alpha = 1`. We first call `load.neojagsmodule()` to load the neo-normal distribution module into JAGS (this is required before compiling the model so that JAGS recognizes `dmsnburr` as a valid distribution). We then run the model using the standard `rjags` workflow: create a JAGS model with `jags.model`, burn-in, and draw samples with `coda.samples`. The result is a set of random draws from the specified MSNBurr distribution (since we did not supply any data, this is essentially sampling from the prior). In a real analysis, you would incorporate these distributions into your model for your data (either as priors or as part of the likelihood for observed data).

You can similarly use any of the other supported distributions in place of `dmsnburr` in the model. Just replace the distribution name and provide the appropriate parameters. For example, to use the Fernandez–Steel Skew t distribution, you might have a model line like `y ~ dfskew.t(mu, tau, nu, alpha)` with your chosen parameters or hyperparameters for `mu`, `tau`, `nu`, and `alpha`. Once the `neojags` module is loaded, JAGS will be able to sample from these distributions just like its built-in ones.

## License

This package is open-source software released under the **GNU General Public License v2.0 (GPL-2)**. You are free to use and redistribute it under the terms of this license. Please note that JAGS itself is licensed separately (JAGS is under the GPL as well), and you should comply with the licenses of all software involved.

## Citation

If you use **neojags** in your research or analysis, please consider citing the package and the authors' work. You can obtain the official citation information by running the R command:

``` r
citation("neojags")
```

This will provide the recommended citation, which may reference the authors and title of the package or associated publications. The development of **neojags** is academically driven (see Achmad Syahrul Choir's 2020 dissertation on neo-normal distributions, and related publications), so citing it helps acknowledge the effort and research behind the package. In absence of a specific paper for the package, you may cite it as "Choir A.S. (2025). *neojags: Neo-Normal Distributions Family for MCMC Models in JAGS*. R package version X.Y.Z" (replacing X.Y.Z with the package version you used), or as instructed by the `citation()` function output.

## Additional Resources

-   **CRAN Package Page:** The CRAN page for neojags (accessible [here](https://cran.r-project.org/package=neojags)) contains the reference manual and a vignette with more technical details on the distributions (including their mathematical definitions and properties).
-   **GitHub Repository:** For the source code, development updates, or to report issues, visit the [GitHub repository](https://github.com/madsyair/neojags). The README and vignettes there may provide further examples and usage tips.
-   **JAGS Documentation:** To learn more about JAGS and writing JAGS models, see the official JAGS user manual. Understanding JAGS syntax will help in effectively using the new distributions provided by **neojags**.
-   **References:** The theoretical background of these distributions is described in various papers and dissertations (for example, Fernández & Steel (1998) for skew distributions, Fernández, Osiewalski & Steel (1995) for skew exponential power, Iriawan (2000) and Choir (2020) for neo-normal theory, etc.). Refer to the package manual or vignette for a full list of references if you're interested in the underlying statistics.

With **neojags**, you can extend your Bayesian models in JAGS to use more flexible distributions, improving your ability to model real-world data that deviate from normality. 
