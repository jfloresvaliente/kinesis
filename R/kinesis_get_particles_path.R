#===============================================================================
# Name   : kinesis_get_particles_path
# Author : Jorge Flores
# Date   : 
# Version:
# Aim    : get av-SL.txt files from KINESIS MODEL output
# URL    : 
#===============================================================================

kinesis_get_particles_path <- function(dirpath){
  dirpath <- dirpath # directory of outputs / where images will be saved
  output_files <- list.files(path = dirpath, pattern = 'output',full.names = T, recursive = T)
  
  path_mat <- NULL
  for(i in output_files){
    dat2 <- read.table(i, header = F)
    path_mat <- rbind(path_mat, dat2)
  }
  return(path_mat)
}

#===============================================================================
# END OF PROGRAM
#===============================================================================
