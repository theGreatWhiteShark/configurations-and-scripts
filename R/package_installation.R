## This file is intended to ease the switching to a new R version by installing all required packages.
required.packages <- c( "arfima", "astsa", "bfast", "curl", "data.table", "deseasonalize", "devtools",
                    "pbkrtest", "lme4", "tibble", "dplyr", "RColorBrewer", "alabama", "numDeriv",
                    "forecast", "ggmap", "ggplot2", "ggvis", "RcppArmadillo", "pander",
                    "ggExtra", "gridExtra", "gridSVG", "inline", "RCurl", "bookdown",
                    "knitr", "Lmoments", "lubridate", "maps", "maptools", "markdown",
                    "minpack.lm", "ncdf", "ncdf.tools", "nloptr", "nlstools", "pear",
                    "pracma", "Rcpp", "readr", "readxl", "rmarkdown",
                    "roxygen2", "season", "seasonal", "testthat", "covr",
                    "xtable", "xts", "zoo", "latex2exp", "shiny", "shinyjs",
                    "shinydashboard", "tidyr", "DT", "qrage", "dygraphs",
                    "metricsgraphics", "plotly", "networkD3", "rvest", "png",
                    "jpeg", "sp", "MazamaSpatialUtils", "rkt", "npst",
                    "psych", "microbenchmark", "OpenStreetMap", "ncdf4" )

lapply( required.packages [ !required.packages %in% installed.packages() ],
	install.packages, repos = "https://cloud.r-project.org" )

devtools::install_github( "theGreatWhiteShark/climex" )
