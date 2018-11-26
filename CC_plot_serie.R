library(ncdf4)
library(fields)
library(maps)
library(mapdata)

dirpath <- '/run/media/jtam/Seagate Expansion Drive/Manon/RCP8.5_2011_2100/Avg/'
nc_files <- list.files(path = dirpath, pattern = '.*\\.nc', recursive = T, full.names = T)

nc <- nc_open(nc_files[1])
lon <- ncvar_get(nc, 'lon_rho')[,1]
lat <- ncvar_get(nc, 'lat_rho')[1,]
# vari <- ncvar_get(nc, 'temp'); dim(vari)
nc_close(nc)

fechas <- seq(from = as.Date('2011-01-01'), length.out = length(nc_files), by = 'days')
# x11()
# image.plot(lon, lat, vari[,,32,1], zlim = c(15,30))
# map('worldHires', add=T, fill=T, col='gray')


# PLOT TIME-SERIES

variables <- c('temp')
ylabs <- c('Temperature C°')
ylim <- c(15,27)

variables <- c('O2')
ylabs <- c('Oxygen')
ylim <- c(85,260)

variables <- c('salt')
ylabs <- c('Salinity')
ylim <- c(34.4,35.5)

variables <- c('ZOO')
ylabs <- c('Micro Zooplancton')
ylim <- c(0,7)

variables <- c('NANO')
ylabs <- c('NANO Zooplancton')
ylim <- c(0,53)

# variables <- c('CACO3')
# ylabs <- c('Cabonate')
# ylim <- c(0,0.05)
#----------------------------#

# Huacho lon = -77.6349; lat = -11.1102
# Mancora lon = -81.0733; lat = -4.0912
names_zones <- c('Mancora','Huacho')
lon_in <- c(-81.0733, -77.6349)
lat_in <- c(-04.0912, -11.1102)

for(j in 1:length(variables)){
  var_name <- variables[j]
  load(file = paste0(dirpath, var_name, '.RData'))
  
  png(filename = paste0(dirpath, var_name,'HuachoMancora.png'), width = 1050, height = 650, res = 120)
  par(mfrow = c(2,1), mar =c(2,3.5,1,1))
  for(i in 1:length(lon_in)){
    a <- which.min(abs(lon - lon_in[i])); lon[a]
    b <- which.min(abs(lat - lat_in[i])); lat[b]
    
    get_serie <- vari_serie[a,b,]
    plot(fechas, get_serie, type = 'l', ylab = '', xlab = '', ylim = ylim, lwd = 2, yaxt = 'n', font = 2)
    # axis(1, font = 2, at = fechas[seq(from = 1, by = 12, to = length(fechas))], labels = fechas[seq(from = 1, by = 12, to = length(fechas))])
    axis(2, font = 2)
    legend('topleft', legend = names_zones[i], bty = 'n', text.font = 2)
    box(lwd = 2)
    mtext(text = ylabs, side = 2, line = 2, font = 2)
    write.table(x = cbind(fechas, get_serie), file = paste0(dirpath, var_name, names_zones[i], '.csv'), sep = ';', row.names = F, col.names = F)
  }
  dev.off()
}



