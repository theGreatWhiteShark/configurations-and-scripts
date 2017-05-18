## This file is intended to ease the switching to a new R version by installing all required packages.
install.packages( c( "arfima", "astsa", "bfast", "curl", "data.table", "deseasonalize", "devtools",
                    "doMPI", "doParallel", "doSNOW", "dplyr", "evd", "pbkrtest", "lme4",
                    "extRemes", "doMC",
                    "foreach", "forecast", "ggmap", "ggplot2", "ggvis",
                    "ggExtra", "gsarima", "gridExtra", "gridSVG", "Hmisc", "inline", "ismev",
                    "knitr", "Lmoments", "lubridate", "magrittr", "maps", "maptools", "markdown",
                    "minpack.lm", "ncdf", "ncdf.tools", "nloptr", "nlstools", "pear",
                    "pracma", "Rcpp", "readr", "readxl", "rmarkdown", "Rmpi",
                    "roxygen2", "seas", "season", "seasonal", 
                    "xtable", "xts", "zoo", "zoom", "latex2exp", "shiny", "shinyjs",
                    "shinydashboard", "tidyr", "DT", "qrage", "dygraphs",
                    "metricsgraphics", "plotly", "networkD3", "rvest", "png",
                    "jpeg", "sp", "MazamaSpatialUtils", "rkt", "npst",
                    "psych", "microbenchmark" ) )
devtools::install_github( "theGreatWhiteShark/climex" )
