#=============================================================================#
# Name   : get_coastline_index
# Author : Jorge Flores
# Date   : 
# Version:
# Aim    : Obtiene un indice de costa segun dimensiones deseadas
# URL    : 
#=============================================================================#
library(fields)

dirpath  <- '/home/jtam/Documentos/kinesis/input/'
fileMask <- paste0(dirpath, 'mask_grid.csv')
fileLon  <- paste0(dirpath, 'lon_grid.csv')
fileLat  <- paste0(dirpath, 'lat_grid.csv')

lon  <- as.matrix(read.table(file = fileLon, header = F, sep = ''))
lat  <- as.matrix(read.table(file = fileLat, header = F, sep = ''))
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

mask[,c(1:132, 206:331)] = 0
image.plot(lon, lat, mask)
abline(h = c(-6,-18))

# Para obtener una mascara y multiplicar luego
maskCoastIndex <- paste0(dirpath, 'CoastLine.csv')
write.table(x = mask, file = maskCoastIndex, col.names = F, row.names = F)

# Para obtener los X&Y de la mascara anterior
index = which(mask == 1, arr.ind = T)
fileIndex <- paste0(dirpath, 'CoastLineIndex.csv')
write.table(x = index, file = fileIndex, col.names = F, row.names = F)
#=============================================================================#
# END OF PROGRAM
#=============================================================================#