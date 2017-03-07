.First <- function() {
  
#############################################
################# HOME ######################
  ## Exports home-directory of the current host into the global variable
  ## HOME. Using relative paths all octave scripts can be run on the workstation
  ## at the MPI or on a local computer within its filesystem

  HOST <- system( "hostname" , intern = TRUE )

  ## HOME will be per default the user-home-directory. Exceptions for specific
  ## hosts have to be added.

  if ( HOST == "pks-t440p.mpipks-dresden.mpg.de" ) {
    USERHOME <<- "/home/phil/pks_home/" 
  } else if ( HOST == "behemoth" ) {
    USERHOME <<- "/home/phil/pks_home/" 
  }  else
    USERHOME <<- "/home/phmu/" 
  
  ## Loading some frequently used packages
  suppressPackageStartupMessages( library( climex, quietly = TRUE ) )
  suppressPackageStartupMessages( library( microbenchmark, quietly = TRUE ) )
  suppressPackageStartupMessages( library( knitr, quietly = TRUE ) )
  suppressPackageStartupMessages( library( roxygen2, quietly = TRUE ) )
  suppressPackageStartupMessages( library( devtools, quietly = TRUE ) )
  suppressPackageStartupMessages( library( gridExtra, quietly = TRUE ) )

  # Path to the package source of a deseasonalization package
  Sys.setenv( X13_PATH = paste0( USERHOME, "software/x-13/" ) )
  
  ## default package repository
  options( repos = "http://cran.us.r-project.org" )

  ## set the path for downloading the data for the climex package
  CLIMEX.PATH <<- "/home/phil/R/climex/"
}
