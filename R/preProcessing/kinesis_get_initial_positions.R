#=============================================================================#
# Name   : kinesis_get_initial_positions
# Author : Jorge Flores
# Date   : 
# Version:
# Aim    : Obtiene un indice de costa segun dimensiones deseadas
# URL    : 
#=============================================================================#
library(fields)
library(maps)
library(mapdata)

kmdist <- 6 # Distancia en pixeles desde la costa
lat_1 <- -6 # Latmax
lat_2 <- -15 # Latmin

dirpath  <- 'F:/GitHub/kinesis/data/'
fileMask <- paste0(dirpath, 'mask_grid.csv')
fileLon  <- paste0(dirpath, 'lon_grid.csv')
fileLat  <- paste0(dirpath, 'lat_grid.csv')

lon  <- as.matrix(read.table(file = fileLon, header = F, sep = ''))[,1]
lat  <- as.matrix(read.table(file = fileLat, header = F, sep = ''))[1,]
mask <- as.matrix(read.table(file = fileMask, header = F, sep = ''))

a <- mask[-c(1:kmdist), ] # quito 6 filas de la parte superior
b <- matrix (0 , kmdist , ncol(a)) # crea una matriz de ceros para suplir las faltantes
c <- rbind(a,b) # suma a (con filas faltantes) y b (con las filas llenas de ceros)
mask <- mask - c # resto para tener la mascara deseada
mask[mask != 1] <- NA

ind1 <- which.min(abs(lat - lat_1))
ind2 <- which.min(abs(lat - lat_2))

mask[ , c(1:ind2, ind1:dim(mask)[2])] <- NA

# Para obtener una mascara y multiplicar luego
name1 <- paste0(dirpath, 'CoastMask.csv')
write.table(x = mask, file = name1, col.names = F, row.names = F)

# Para obtener los X&Y de la mascara anterior
index <- which(mask == 1, arr.ind = T)
name2 <- paste0(dirpath, 'CoastMaskIndex.csv')
write.table(x = index, file = name2, col.names = F, row.names = F)

# Para obtener lon-lat de la mascara anterior
lon_vals <- lon[index[,1]]
lat_vals <- lat[index[,2]]
lonlat <- cbind(lon_vals, lat_vals)
name3 <- paste0(dirpath, 'CoastMaskLonLat.csv')
write.table(x = lonlat, file = name3, col.names = F, row.names = F, sep = ';')

x11()
map('worldHires', add=F, fill=T, col='gray', ylim = c(-20,0), xlim = c(-90,-70))
axis(1); axis(2, las = 2)
points(lon_vals, lat_vals, pch = 1, cex = 0.1)
box()
#=============================================================================#
# END OF PROGRAM
#=============================================================================#