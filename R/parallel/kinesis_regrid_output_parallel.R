#===============================================================================
# Name   : kinesis_regrid_output_parallel
# Author : Jorge Flores
# Date   : 
# Version:
# Aim    : Regrid Kinesis output files with parallel package
# URL    : 
#===============================================================================
kinesis_regrid_output_parallel <- function(txtfile){
  library(akima)

  # Get 'sst' data from kinesis outputs
  old_dat <- read.table(txtfile, header = F)
  old_dat$V1 <- old_dat$V1 -360

  x <- old_dat[,1]
  y <- old_dat[,2]
  z <- old_dat[,3]
  
  # Define new lon-lat values for new grid (by = indicates spatial resolution in degrees)
  # x0 <- seq(from = -100, to = -70, by = 1/6)
  # y0 <- seq(from = -40 , to = 15 , by = 1/6) 
  
  # new_dat <- interp(x,y,z, xo = x0, yo = y0)
  new_dat <- interp(x,y,z)
  newz <- new_dat[[3]]

  # Get and store new .txt file with the new grid
  txtfile <- gsub(pattern = 'sst', replacement = 'SST', x = txtfile)
  write.table(newz, file = txtfile, row.names = F, col.names = F,eol = '\r')
}
#===============================================================================
# END OF PROGRAM
#===============================================================================
init <- Sys.time()
library(parallel)
numC <- detectCores() - 2

f <- list.files(path = '/home/jtam/Documentos/KINESIS/ANCHOVY/NinaAgosto/', pattern = paste0('sst','.*\\.dat'), full.names = T, recursive = T)

mclapply(f, mc.cores=numC, kinesis_regrid_output_parallel)
endit <- Sys.time()
print(endit - init)
