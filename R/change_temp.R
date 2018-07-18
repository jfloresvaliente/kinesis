#===============================================================================
# Name   : change_temp
# Author : Jorge Flores
# Date   : 
# Version:
# Aim    : Aumenta la temperatura de todo el input
# URL    : 
#===============================================================================
dirpath   <- '/home/marissela/Documents/KINESIS/KINESIS_ORIGINAL_SOURCE/anchovy/input/interanual/zlev20/'
ndiv      <- 2 # Numero de grados centigrados que se aumentara la temperatura
vari      <- 't'
inputNew  <- paste0(vari, '_' , ndiv, '/')

#---------------Dont change anything--------------------#
dir.create(paste0(dirpath, inputNew), showWarnings = F)
tfiles <- list.files(path = dirpath, pattern = paste0(vari,'.*\\.txt'), full.names = F)

for(i in 1:length(tfiles)){
  dat <- read.table(paste0(dirpath,tfiles[i]), header = F, sep = '')
  dat[,3] <- dat[,3] + ndiv
  write.table(x = dat, file = paste0(dirpath, inputNew, tfiles[i]), row.names = F, col.names = F,eol = '\r')
  print(tfiles[i])
}

#===============================================================================
# END OF PROGRAM
#===============================================================================

# #---------------------#
# ylim <- c(0,1e6)
# xlim <- c(0,40)
# 
# png(filename = paste0(dirpath, inputOriginal,'tempOriginal.png'), width = 1050, height = 850, res = 120)
# par(mar = c(3,3,3,1))
# hist(x = Tvalues, xlim = xlim, ylim = ylim)
# dev.off()
# 
# png(filename = paste0(dirpath, inputNew,'tempMas', ndiv ,'.png'), width = 1050, height = 850, res = 120)
# par(mar = c(3,3,3,1))
# hist(x = TvaluesNew, xlim = xlim, ylim = ylim)
# dev.off()
