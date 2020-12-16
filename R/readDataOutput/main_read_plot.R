#=============================================================================#
# Name   : main_read_plot
# Author : Jorge Flores
# Date   : 
# Version:
# Aim    : 
# URL    : 
#=============================================================================#
dirpath      <- 'C:/Users/jflores/Documents/JORGE/colaboradores/Takeshi/outM2/'
max_paticles <- 9540

#=============================================================================#
#===================== Do not change anything from here ======================#
#=============================================================================#

#========== Load functions and packages ==========#
source('R/readDataOutput/load_packages_functions.R')

nfiles  <- length(list.files(path = dirpath, pattern = paste0('output','.*\\.txt'), full.names = T, recursive = T))

#========== Read raw data ==========#
if(file.exists(x = paste0(dirpath, 'df.RData'))){
  print('An [R.data] file already exists ...')
}else{
  print('Reading [.txt] data ...')
  readDataOutput(dirpath = dirpath, max_paticles = max_paticles, nfiles = nfiles)
  print('Saving RData ...')
}
#=============================================================================#
# END OF PROGRAM
#=============================================================================#