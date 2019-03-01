#=============================================================================#
# Name   : DividirCorrientes
# Author : Jorge Flores
# Date   : 
# Version:
# Aim    : 
# URL    : 
#=============================================================================#
mainPath <- 'G:/ROMS_SIMULATIONS/ROMS6B_VINCENT_SIMULATION/year1995/zlev1/'
ndiv <- 5 # Factor por el cual se dividen las corrientes

inputNew <- paste0('currents_entre' , ndiv, '/')

#---------------Dont change anything--------------------#

dir.create(file.path(mainPath, inputNew), showWarnings = F)
dir.create(file.path(mainPath, 'currents_original/'), showWarnings = F)

vfiles <- list.files(path = mainPath, pattern = paste0('v','.*\\.txt'))
ufiles <- list.files(path = mainPath, pattern = paste0('u','.*\\.txt'))

mat <- read.table(paste0(mainPath,vfiles[1]), header = F, sep = '')

#-------------------------------#
Vvalues    <- matrix(data = NA, nrow = dim(mat)[1], ncol = length(vfiles))
VvaluesNew <- matrix(data = NA, nrow = dim(mat)[1], ncol = length(vfiles))

for(i in 1:length(vfiles)){
  dat <- read.table(paste0(mainPath, vfiles[i]), header = F, sep = '')
  write.table(x = dat, file = paste0(mainPath, 'currents_original/', vfiles[i]), row.names = F, col.names = F,eol = '\r')
  Vvalues[,i] <- dat[,3]
  dat[,3] <- dat[,3]/ndiv
  write.table(x = dat, file = paste0(mainPath, inputNew, vfiles[i]), row.names = F, col.names = F,eol = '\r')
  VvaluesNew[,i] <- dat[,3]
  print(vfiles[i])
}

#-------------------------------#
Uvalues    <- matrix(data = NA, nrow = dim(mat)[1], ncol = length(ufiles))
UvaluesNew <- matrix(data = NA, nrow = dim(mat)[1], ncol = length(ufiles))

for(i in 1:length(ufiles)){
  dat <- read.table(paste0(mainPath, ufiles[i]), header = F, sep = '')
  write.table(x = dat, file = paste0(mainPath, 'currents_original/', ufiles[i]), row.names = F, col.names = F,eol = '\r')
  Uvalues[,i] <- dat[,3]
  dat[,3] <- dat[,3]/ndiv
  write.table(x = dat, file = paste0(mainPath, inputNew, ufiles[i]), row.names = F, col.names = F,eol = '\r')
  UvaluesNew[,i] <- dat[,3]
  print(ufiles[i])
}

#---------------------#
ylim <- c(0,5e6)

png(filename = paste0(mainPath, inputNew, 'currentsComparison.png'), width = 1050, height = 850, res = 120)
par(mfrow = c(2,2), mar = c(3,3,3,1))
hist(x = Vvalues, xlim = c(-.5,.5), ylim = ylim)
hist(x = Uvalues, xlim = c(-.5,.5), ylim = ylim)
hist(x = VvaluesNew, xlim = c(-.5,.5), ylim = ylim)
hist(x = UvaluesNew, xlim = c(-.5,.5), ylim = ylim)
dev.off()
#=============================================================================#
# END OF PROGRAM
#=============================================================================#