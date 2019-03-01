#=============================================================================#
# Name   : 
# Author : Jorge Flores
# Date   : 
# Version:
# Aim    : 
# URL    : 
#=============================================================================#
library(ncdf4)
library(fields)
library(sp)

varid <- 'v'
ylim <- c(-.2,.2)
nc <- nc_open(filename = 'G:/ROMS_SIMULATIONS/ROMS6B_VINCENT_SIMULATION/mean1995.nc')
lon <- ncvar_get(nc = nc, varid = 'lon_rho')[,1]
lat <- ncvar_get(nc = nc, varid = 'lat_rho')[1,]
mask <- ncvar_get(nc = nc, varid = 'mask_rho')
vari <- ncvar_get(nc = nc, varid = varid)[,,32,]
vari <- apply(vari, c(1,2), mean)

latitudes <- c(-5,-10,-15,-20)

# png(filename = 'F:/COLLABORATORS/kinesis/figures/MesoZoo1995MeanSurface.png', height = 850, width = 850, res = 120)
png(filename = 'C:/Users/ASUS/Desktop/vprofiles.png', height = 850, width = 850, res = 120)
par(mfrow = c(2,2))
for(i in latitudes){
  nlat <- i
  latrow <- which.min(abs(lat - nlat))
  row_serie <- vari[,latrow]
  row_serie[1] <- 0.000000000001
  
  coast_init <- which.max(row_serie == 0) - 1
  coast_serie <- row_serie[1:coast_init]
  coast_lon <- lon[1:coast_init]
  
  disMat <- matrix(c(coast_lon, rep(nlat, length(coast_lon))), nrow = length(coast_lon), ncol = 2)
  coast_distance <- spDistsN1(pts = disMat, pt= disMat[1,], longlat = T)
  
  plot(rev(coast_distance),coast_serie, type = 'l',
       xlab = 'Distancia a la Costa', ylab = 'Meso-Zoo umol C L^-1',
       xlim = c(0,400), ylim = ylim, main = paste('LAT', nlat))
}
dev.off()
#=============================================================================#
# END OF PROGRAM
#=============================================================================#