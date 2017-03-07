#!/bin/bash

# Bash script for initializing my R configuration by installing loads of pacakages
Rscript --no-init-file -e "options( repos = 'https://cran.uni-muenster.de/'); source( '~/git/configurations-and-scripts/R/package_installation.R' )"
