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
library(geosphere)

dirpath <- 'G:/ROMS_SIMULATIONS/ROMS6B_VINCENT_SIMULATION/'

nc <- nc_open(filename = 'G:/ROMS_SIMULATIONS/ROMS6B_VINCENT_SIMULATION/roms6b_avg.Y1958.M11.rl1b.nc')
lon <- ncvar_get(nc = nc, varid = 'lon_rho')[,1]
lat <- ncvar_get(nc = nc, varid = 'lat_rho')[1,]
mask <- ncvar_get(nc = nc, varid = 'mask_rho')

#mask[mask==0] = NA
a <- mask[-c(1:10), ] # quito 6 filas de la parte superior
b <- matrix (0 , 10 , ncol(a)) # crea una matriz de ceros para suplir las faltantes
c <- rbind(a,b) # suma a (con filas faltantes) y b (con las filas llenas de ceros)
mask <- mask - c # resto para tener la mascara deseada

mask[,c(1:140, 245:355)] = 0
# image.plot(lon, lat, mask)
abline(h = c(-3,-20))

mask[mask == 0] = NA
# image.plot(lon, lat, mask)

nc_close(nc)

time_serie <- NULL
for(year in 1958:2008){
  for(month in 1:12){
    nc_file <- paste0(dirpath, 'roms6b_avg.Y', year, '.M', month, '.rl1b.nc')
    print(nc_file)
    nc <- nc_open(filename = nc_file)
    vari <- ncvar_get(nc = nc, varid = 'ZOO')
    vari <- vari[,,32,]
    vari <- apply(vari, c(1,2), mean)
    vari <- vari * mask
    vari <- mean(vari, na.rm = T)
    time_serie <- c(time_serie, vari)
    nc_close(nc)
  }
}

dates <- seq(as.Date('1958-01-01'), as.Date('2008-12-31'), by = 'month')
# dates <- as.Date(dates, format = '%Y-%m') #format(x = dates, format = '%Y-%m')

png(filename = 'C:/Users/ASUS/Desktop/mesozoo.png', width = 1250, height = 850, res = 120)
plot(dates, time_serie, type = 'l', yla = 'Meso Zoo (umol C L-1)', xlab = '')
dev.off()

frame <- cbind(as.character(dates), time_serie)
write.table(x = frame, file = 'C:/Users/ASUS/Desktop/mesozoo.csv', row.names = F, col.names = F, sep = ';')


# float ZOO[xi_rho,eta_rho,s_rho,time]   
# long_name: averaged Microzooplankton
# units: umol C L-1
# field: Microzooplankton, scalar, series
#=============================================================================#
# END OF PROGRAM
#=============================================================================#