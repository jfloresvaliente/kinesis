#=============================================================================#
# Name   : egg_larv_decadal_clim_PLOTtimeSerie
# Author : Jorge Flores
# Date   : 
# Version:
# Aim    : 
# URL    : 
#=============================================================================#
library(fields)
library(maps)
library(mapdata)

dirpath <- dirpath <- 'F:/COLLABORATORS/KINESIS/egg_larvae/output/' # Ruta donde estan almacenados los datos

lat <- rev(seq(-20, 0, 1))

vari_name <- 'Anc_egg'
csv_file <- paste0(dirpath, 'Climatology_', vari_name, '.csv')
datos <- read.table(file = csv_file, sep = ';', header = T)
datos$lon <- datos$lon -360

# Do not change anything after here #
dir.create(paste0(dirpath, 'figures/'), showWarnings = F)

monthRow <- NULL
for (i in 1:12) {
  dat <- subset(datos, datos$mes == i)
  if(dim(dat)[1] == 0){
    monthRow <- cbind(monthRow, rep(NA, times = length(lat)-1))
  }else{
    rowDat <- NULL
    for (j in 1:(length(lat)-1)) {
      in_lat <- lat[j]
      on_lat <- lat[j+1]
      sublat <- subset(dat, dat$lat <= in_lat & dat$lat > on_lat)
      # sublat <- subset(dat, dat$lat <= -12    & dat$lat > -13)
      if(dim(sublat)[1] == 0) vari <- NA else vari <- mean(sublat[,3])
      varirow <- c(mean(c(lat[j], lat[j+1])), vari)
      rowDat <- rbind(rowDat, varirow)
    }
    monthRow <- cbind(monthRow, rowDat[,2])
  }
}
newlats <- rowDat[,1]

months <- matrix(data = 1:12, nrow = dim(monthRow)[1], ncol = 12, byrow = T)
latis  <- matrix(data = newlats, nrow = dim(monthRow)[1], ncol = 12, byrow = F)

png(filename = paste0(dirpath, 'figures/', 'Climatology_', vari_name, '.png'), width = 850, height = 850)
par(mfrow = c(2,1))
image.plot(months, latis, log(monthRow),
           xlab = 'Months', ylab = 'Latitude', main = paste('Climatological Density of', vari_name),
           legend.args=list( text="log", cex=1.5))
mtext(text = 'Log values', side = 4)

timeRow <- colMeans(x = (monthRow), na.rm = T)
plot(1:12, timeRow, type = 'b', ylab = '# larvae')
dev.off()

# #-------------------------- Interanual ---------------------------#
datos <- read.table(paste0(dirpath, 'interanual_', vari_name, '.csv'), header = T, sep = ';')
x <- as.Date(as.character(datos$fecha))
y <- as.numeric(datos[,2])
png(filename = paste0(dirpath, 'figures/', 'interanual_', vari_name, '.png'), width = 850, height = 850)
plot(x, y, type = 'b', xlab = '', ylab = paste('Number of', vari_name))
dev.off()

# ONI -----------------#
png(filename = paste0(dirpath, 'figures/', 'ONI_', vari_name, '.png'), width = 1250, height = 550)
par(mfrow = c(1,3))

cold <- read.table(paste0(dirpath, 'ONI_cold_', vari_name, '.csv'), header = T, sep = ';')
cold_clim <- tapply(cold[,5], list(cold$month), mean, na.rm = T)
x <- levels(factor(cold$month))
plot(x, cold_clim, type = 'l', main = 'Cold Phase', ylab = paste('Number of', vari_name), xlab = '')

neutro <- read.table(paste0(dirpath, 'ONI_neutro_', vari_name, '.csv'), header = T, sep = ';')
neutro_clim <- tapply(neutro[,5], list(neutro$month), mean, na.rm = T)
x <- levels(factor(neutro$month))
plot(x, neutro_clim, type = 'l', main = 'Neutral Phase', ylab = paste('Number of', vari_name), xlab = '')

warm <- read.table(paste0(dirpath, 'ONI_warm_', vari_name, '.csv'), header = T, sep = ';')
warm_clim <- tapply(warm[,5], list(warm$month), mean, na.rm = T)
x <- levels(factor(warm$month))
plot(x, warm_clim, type = 'l', main = 'Warm Phase', ylab = paste('Number of', vari_name), xlab = '')
dev.off()

png(filename = paste0(dirpath, 'figures/', 'ONI_maps', vari_name, '.png'), width = 1250, height = 550)
par(mfrow = c(1,3))
plot(cold$lon, cold$lat, main = 'Cold Phase',
     xlim = c(-85,-70), ylim = c(-20,0),
     xlab = 'Longitude', ylab = 'Latitude',
     pch = 19, cex = .5)
map('worldHires', add=T, fill=T, col='gray')

plot(neutro$lon, neutro$lat, main = 'Neutral Phase',
     xlim = c(-85,-70), ylim = c(-20,0),
     xlab = 'Longitude', ylab = 'Latitude',
     pch = 19, cex = .5)
map('worldHires', add=T, fill=T, col='gray')

plot(warm$lon, warm$lat, main = 'Warm Phase',
     xlim = c(-85,-70), ylim = c(-20,0),
     xlab = 'Longitude', ylab = 'Latitude',
     pch = 19, cex = .5)
map('worldHires', add=T, fill=T, col='gray')
dev.off()
#-------------------------- Interdecadal ---------------------------#

decadas <- seq(1960, 1970, 10)
csv_file <- paste0(dirpath, 'DecadalMean_', vari_name,'.csv')
datos <- read.table(csv_file, sep = ';', header = T)

decaRow <- NULL
for (i in decadas) {
  dat <- subset(datos, datos$decada == i)
  dat$lon <- dat$lon -360

  png(filename = paste0(dirpath, 'figures/', 'DecadalMean_',i, vari_name, '.png'), width = 850, height = 850)
  plot(dat$lon, dat$lat, main = paste('Decada', i),
       xlim = c(-85,-70), ylim = c(-20,0),
       xlab = 'Longitude', ylab = 'Latitude',
       pch = 19, cex = .5)
  map('worldHires', add=T, fill=T, col='gray')
  dev.off()
}
# graphics.off()
# rm(list = ls())