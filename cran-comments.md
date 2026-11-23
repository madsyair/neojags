## Submission summary

This is an update of neojags (0.1.7 -> 0.1.8). It fixes the ERROR reported
on the CRAN check results page for neojags,
https://cran.r-project.org/web/checks/check_results_neojags.html
namely the installation failure on r-devel-windows-x86_64, which appeared
after the CRAN Windows machines moved to JAGS 5.0.2:

    cannot find -ljags-4
    ERROR: compilation failed for package 'neojags'

The cause was that src/Makevars.ucrt hard-coded JAGS major version 4.

## Changes

* Compiler and linker flags now come from `rjags::pkg.compile.flags()`
  (rjags >= 4-18), following the scheme contributed by Matt Denwood and
  also used by runjags 2.3.0. neojags is therefore always built against the
  same JAGS (4.x or 5.x) as rjags, and the module is loaded with
  `rjags::load.pkg.module()`, which checks binary compatibility.
  `Imports` now requires rjags (>= 4-18).
* The old configure script, src/Makevars.in and src/Makevars.ucrt were
  removed.
* The JAGS maths library is linked explicitly (`-ljrmath` / `-ljrmath-0`),
  because the distributions call JRmath functions.
* Spelling test and WORDLIST fixed; no changes to the distributions
  themselves.

## Test environments

* GitHub Actions
  - ubuntu-latest, R release and R devel, JAGS 5.0.2 + rjags 5-5
  - ubuntu-latest, R release, JAGS 4.3.x + rjags 4-18
  - windows-latest, R devel, JAGS 5.0.1 + CRAN binary rjags
  - windows-latest, R release, JAGS 5.0.1 + CRAN binary rjags
  - macos-latest, R release, JAGS 5.0.0
* Local: Ubuntu 24.04, R 4.3.3, with JAGS 4.3.2 and with JAGS 5.0.2
* win-builder: R devel

## R CMD check results

0 errors | 0 warnings | 0 notes

## Reverse dependencies

There are currently no reverse dependencies on CRAN.
