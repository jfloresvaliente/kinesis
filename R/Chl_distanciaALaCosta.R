library(fields)
library(sp)
dirpath <- 'G:/ROMS_SIMULATIONS/ROMS6B_VINCENT_SIMULATION/japonForcing/zlev1/'
gridpath <- 'G:/ROMS_SIMULATIONS/ROMS6B_VINCENT_SIMULATION/japonForcing/zlev1/'

lon <- as.matrix(read.table(paste0(gridpath, 'lon_grid.csv')));   lon <- lon[,1]
lat <- as.matrix(read.table(paste0(gridpath, 'lat_grid.csv')));   lat <- lat[1,]
mask <- as.matrix(read.table(paste0(gridpath, 'mask_grid.csv'))); mask[mask == 0] <- NA

year <- 1998
vari <- 'z'
files <- list.files(path = dirpath, pattern = paste0(vari, year,'.*\\.txt'), full.names = T)

chl <- NULL
for(i in files){
  dat <- read.table(i)
  chl <- cbind(chl, dat[,3])
}
chl <- apply(chl, c(1), mean)
chl <- matrix(data = chl, nrow = dim(mask)[1], ncol = dim(mask)[2])
# image.plot(lon, lat, chl*mask)

latitudes <- c(-5,-10,-15,-20)

x11()
# png(filename = paste0(dirpath, vari, year, '.png'), height = 850, width = 850, res = 120)
par(mfrow = c(2,2))
for(i in latitudes){
  nlat <- i
  latrow <- which(x = lat == nlat, arr.ind = T)
  
  row_serie <- chl[,latrow]
  row_serie[1] <- row_serie[1] + 0.0000001
  # plot(lon, row_serie, type = 'l', ylab = 'Chl mg/m^3', main = paste('LAT', nlat))
  
  coast_init <- which.max(row_serie == 0) - 1
  coast_serie <- row_serie[1:coast_init]
  coast_lon <- lon[1:coast_init]
  # plot(coast_lon, coast_serie, type = 'l', ylab = 'Chl mg/m^3', main = paste('LAT', nlat))
  
  disMat <- matrix(c(coast_lon, rep(nlat, length(coast_lon))), nrow = length(coast_lon), ncol = 2)
  coast_distance <- spDistsN1(pts = disMat, pt= disMat[1,], longlat = T)
  
  plot(rev(coast_distance),coast_serie, type = 'l',
       xlab = 'Distancia a la Costa', ylab = 'Chl mg/m^3',
       xlim = c(0,400), ylim = c(0,4), main = paste('LAT', nlat))
}
# dev.off()
