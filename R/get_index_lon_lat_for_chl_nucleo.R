#=============================================================================#
# Name   : 
# Author : Jorge Flores
# Date   : 
# Version:
# Aim    : 
# URL    : 
#=============================================================================#
library(maps)
fileTxt <- '/home/marissela/Documents/KINESIS/ORIGINAL_SOURCE/anchovy/input/c20010103.txt'
dat <- read.table(file = fileTxt, header = F, sep = '')

lon <- dat[,1]
lat <- dat[,2]
chl <- dat[,3]

lon <- matrix(data = lon, nrow = 181, ncol = 331)
lat <- matrix(data = lat, nrow = 181, ncol = 331)
chl <- matrix(data = chl, nrow = 181, ncol = 331)

x11()
image.plot(lon, lat, chl)

a = which(chl == 50, arr.ind = T)

alon <- lon[a[,]]
max(alon)
min(alon)


alat <- lat[a[,]]
max(alat)
min(alat)
#=============================================================================#
# END OF PROGRAM
#=============================================================================#