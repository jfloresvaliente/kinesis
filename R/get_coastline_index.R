#=============================================================================#
# Name   : get_coastline_index
# Author : Jorge Flores
# Date   : 
# Version:
# Aim    : Obtiene un indice de costa segun dimensiones deseadas
# URL    : 
#=============================================================================#
library(fields)

dirpath  <- 'F:/GitHub/kinesis/data/'
fileMask <- paste0(dirpath, 'mask_grid.csv')
fileLon  <- paste0(dirpath, 'lon_grid.csv')
fileLat  <- paste0(dirpath, 'lat_grid.csv')

lon  <- as.matrix(read.table(file = fileLon, header = F, sep = ''))[,1]
lat  <- as.matrix(read.table(file = fileLat, header = F, sep = ''))[1,]
mask <- as.matrix(read.table(file = fileMask, header = F, sep = ''))

# image.plot(lon, lat, mask)

#mask[mask==0] = NA
a <- mask[-c(1:6), ] # quito 6 filas de la parte superior
b <- matrix (0 , 6 , ncol(a)) # crea una matriz de ceros para suplir las faltantes
c <- rbind(a,b) # suma a (con filas faltantes) y b (con las filas llenas de ceros)
mask <- mask - c # resto para tener la mascara deseada
# mask[mask!=1] = NA # transformo todos los calores no desados en NA

# image.plot(lon, lat, c)
# image.plot(lon, lat, mask)

lat_1 <- -6
lat_2 <- -15

ind1 <- which.min(abs(lat - lat_1))
ind2 <- which.min(abs(lat - lat_2))

mask[,c(1:ind2, ind1:dim(mask)[2])] = 0
image.plot(lon, lat, mask)
abline(h = c(lat_1, lat_2))

# Para obtener una mascara y multiplicar luego
maskCoastIndex <- paste0(dirpath, 'CoastLine.csv')
write.table(x = mask, file = maskCoastIndex, col.names = F, row.names = F)

# Para obtener los X&Y de la mascara anterior
index <- which(mask == 1, arr.ind = T)
fileIndex <- paste0(dirpath, 'CoastLineIndex.csv')
write.table(x = index, file = fileIndex, col.names = F, row.names = F)

# Para obtener lon-lat de la mascara anterior
lon_vals <- lon[index[,1]]
lat_vals <- lat[index[,2]]
lonlat <- cbind(lon_vals, lat_vals)
write.table(x = lonlat, file = paste0(dirpath, 'lon_lat_CoastIndex.csv'), col.names = F, row.names = F, sep = ';')
#=============================================================================#
# END OF PROGRAM
#=============================================================================#