#===============================================================================
# Name   : kinesis_regrid_input
# Author : Jorge Flores
# Date   : 
# Version:
# Aim    : Regrid Kinesis input files
# URL    : 
#===============================================================================
kinesis_regrid_input <- function(dirpath, variable = NULL){
  library(akima)
  
  mask <- as.matrix(read.table(paste0(dirpath, 'mask_grid.csv'), header = F))
  lon  <- as.matrix(read.table(paste0(dirpath, 'lon_grid.csv'), header = F))
  lat  <- as.matrix(read.table(paste0(dirpath, 'lat_grid.csv'), header = F))
  
  if(is.null(variable)){
    files <- list.files(path = dirpath, pattern = paste0('.*\\.txt'), full.names = T)
  }else{
    files <- list.files(path = dirpath, pattern = paste0(variable,'.*\\.txt'), full.names = T)
  }

  for(i in files){
    
    # Get irregular data
    old_dat <- read.table(i, header = F)
    old_dat[is.na(old_dat)] <- 0
    x <- old_dat[,1]
    y <- old_dat[,2]
    z <- old_dat[,3]
    
    # Define new lon-lat values for new grid (by = indicates spatial resolution in degrees)
    x0 <- seq(from = -100, to = -70, by = 1/6)
    y0 <- seq(from = -40 , to = 15 , by = 1/6) 
    
    new_dat <- interp(x,y,z, xo = x0, yo = y0)
    newz <- new_dat[[3]]
    newz <- (newz*mask)
    
    # Get and store new .txt file with the new grid
    new_dat <- data.frame(as.vector(lon), as.vector(lat), as.vector(newz));
    new_dat <- new_dat[order(new_dat[,2], decreasing = F),]; #head(new_dat) # transformar al orden de datos que  requiere takeshi
    write.table(new_dat, file = i, row.names = F, col.names = F,eol = '\r')
    
    # Print file name and time
    print(paste(i, format(Sys.time(), "%X %Y")))
  }
}

#===============================================================================
# END OF PROGRAM
#===============================================================================
