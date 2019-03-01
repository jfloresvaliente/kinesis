#=============================================================================#
# Name   : change_chl_coast
# Author : Jorge Flores
# Date   : 
# Version:
# Aim    : Aumenta la clorofila en la costa (usando un index-position de costa)
# URL    : 
#=============================================================================#
dirpath   <- '/home/marissela/Documents/KINESIS/KINESIS_ORIGINAL_SOURCE/anchovy/input/interanual/zlev20/'
ndiv      <- 30 # Numero en que se aumentara la clorofila
vari      <- 'c'
inputNew  <- paste0(dirpath,vari,'_', ndiv, '_oceano0/')
coastline <- '/home/marissela/Documents/KINESIS/KINESIS_ORIGINAL_SOURCE/anchovy/input/CoastLine.csv'

#---------------Dont change anything--------------------#
dir.create(inputNew, showWarnings = F)
cfiles <- list.files(path = dirpath, pattern = paste0(vari,'.*\\.txt'))[1:73]
coast_index <- as.matrix(read.table(coastline))
coast_index[coast_index == 1] <- ndiv

for(i in 1:length(cfiles)){
  dat <- read.table(paste0(dirpath, cfiles[i]), header = F, sep = '')
  
  lon <- matrix(data = dat[,1], nrow = 181, ncol = 331, byrow = F)
  lat <- matrix(data = dat[,2], nrow = 181, ncol = 331, byrow = F)
  VAR <- matrix(data = dat[,3], nrow = 181, ncol = 331, byrow = F) # 331,181
  VAR <- VAR + coast_index
  
  new_dat <- data.frame(as.vector(lon), as.vector(lat), as.vector(VAR));
  new_dat <- new_dat[order(new_dat[,2], decreasing = F),]; #head(new_dat) # transformar al orden de datos que  requiere takeshi
  
  write.table(new_dat, file = paste0(inputNew, cfiles[i]), row.names = F, col.names = F,eol = '\r')
  print(cfiles[i])
}
#=============================================================================#
# END OF PROGRAM
#=============================================================================#