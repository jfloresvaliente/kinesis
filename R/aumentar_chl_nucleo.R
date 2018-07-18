#===============================================================================
# Name   : 
# Author : Jorge Flores
# Date   : 
# Version:
# Aim    : Agrega nucleos (cuadrados) de clorifila en los inputs
# URL    : 
#===============================================================================
library(fields)
library(maps)

mainPath <- 'G:/hacer_hoy/KINESIS_ORIGINAL_SOURCE/anchovy/input/'
ndiv <- 40 # Numero de grados centigrados que se aumentar? la temperatura

inputOriginal <- 'original_chl/'
inputNew <- paste0('VariosNucleosChl' , ndiv, '/')

#---------------Dont change anything--------------------#

dir.create(file.path(mainPath, inputNew), showWarnings = F)
cfiles <- list.files(path = paste0(mainPath, inputOriginal), pattern = paste0('c','.*\\.txt'))
mat <- read.table(paste0(mainPath,inputOriginal,cfiles[1]), header = F, sep = '')

coast_index <- read.table('G:/hacer_hoy/KINESIS_ORIGINAL_SOURCE/anchovy/input/coastIndex.csv')

#-----------------#
for(i in 1:length(cfiles)){
  dat <- read.table(paste0(mainPath, inputOriginal, cfiles[i]), header = F, sep = '')
  
  lon <- matrix(data = dat[,1], nrow = 331, ncol = 181, byrow = T)
  lat <- matrix(data = dat[,2], nrow = 331, ncol = 181, byrow = T)
  chl <- matrix(data = dat[,3], nrow = 331, ncol = 181, byrow = T) # 331,181
  
  # image.plot(lon,lat, chl)
  
  # Para agregar un solo nucleo
  # chl[130:180,60:100] <- ndiv
  
  # Si se desea aumentar mas de un nucleo
  chl[260:280,60:100] <- ndiv
  chl[160:180,60:100] <- ndiv
  chl[70:90,60:100] <- ndiv
  # x11()
  # image.plot(lon,lat, chl)
  
  new_dat <- data.frame(as.vector(lon), as.vector(lat), as.vector(chl));
  new_dat <- new_dat[order(new_dat[,2], decreasing = F),]; #head(new_dat) # transformar al orden de datos que  requiere takeshi
  
  write.table(new_dat, file = paste0(mainPath, inputNew, cfiles[i]), row.names = F, col.names = F,eol = '\r')
  print(cfiles[i])
}
