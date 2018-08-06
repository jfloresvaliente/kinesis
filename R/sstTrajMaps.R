#=============================================================================#
# Name   : sstTrajMaps
# Author : Jorge Flores
# Date   : 
# Version:
# Aim    : 
# URL    : 
#=============================================================================#
library(ggplot2)
library(fields)
library(mapdata)
library(raster)
library(mgcv)
library(akima)

dirpath <- '/home/jtam/Documentos/KINESIS/ANCHOVY/NinaAgosto/'
xlimmap <- c(-100, -70)    # X limits of plot
ylimmap <- c(-30, -0)      # Y limits of plot
zlimmap <- c(10,30)
nfiles <- 350

dir.create(paste0(dirpath, 'sstTrajMaps/'), showWarnings = F)

sstFiles <- list.files(path = dirpath, pattern = 'SST', full.names = T, recursive = T)
trajFiles <- list.files(path = dirpath, pattern = 'output', full.names = T, recursive = T)

for(i in 1:nfiles){
  dat <- read.table(file = trajFiles[i], header = F, sep = '')
  dat$V1 <- dat$V1 -360
  
  dat2 <- as.matrix(read.table(file = sstFiles[i], header = F, sep = ''))
  # dat2$V1 <- dat2$V1 - 360
  
  if(i == 1){
    sstfile <- gsub(pattern = 'SST', replacement = 'sst', x = sstFiles[i])
    lonlat <- read.table(file = sstfile, header = F, sep = '')
    lonlat$V1 <- lonlat$V1 - 360
    # Define new lon-lat values for new grid (by = indicates spatial resolution in degrees)
    # x0 <- seq(from = -100, to = -70, by = 1/6)
    # y0 <- seq(from = -40 , to = 15 , by = 1/6)
    # dat2 <- interp(x = dat2$V1, y = dat2$V2, z = dat2$V3, xo = x0, yo = y0)
    lonlat <- interp(x = lonlat$V1, y = lonlat$V2, z = lonlat$V3)
    lon <- lonlat[[1]]
    lat <- lonlat[[2]]
  }
    
  png(filename = paste0(dirpath, 'sstTrajMaps/', 'sst', i, '.png'), width = 650, height = 650, res = 120)
  par(mar = c(1,2,1,2), oma = c(2,1,.5,.5))
  image.plot(lon, lat, dat2, xlim = xlimmap, ylim = ylimmap, zlim = zlimmap, axes = F)
  map('worldHires', add=T, fill=T, col='gray', ylim = ylimmap, xlim = xlimmap)
  box(lwd = 2)
  axis(side = 1, at = seq(xlimmap[1], xlimmap[2], 5), labels = seq(xlimmap[1],xlimmap[2], 5),
       lwd = 2, lwd.ticks = 2, font.axis=4)
  axis(side = 2, at = seq(ylimmap[1]+2, ylimmap[2]-2, 5), labels = seq(ylimmap[1]+2, ylimmap[2]-2, 5),
       lwd = 2, lwd.ticks = 2, font.axis=4, las = 2)
  points(x = dat[,1], y = dat[,2], pch = 19, cex = .1)
  mtext(text = paste('Day', i), side = 3, adj = 0.05, line = -1, font = 2)
  grid()
  dev.off()
  print(sstFiles[i])
}
#=============================================================================#
# END OF PROGRAM
#=============================================================================#