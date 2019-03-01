#=============================================================================#
# Name   : 
# Author : Jorge Flores
# Date   : 
# Version:
# Aim    : 
# URL    : 
#=============================================================================#
library(fields)
library(raster)
library(stplanr)
library(mgcv)
library(ggmap)

#--------- Calculo del contorno de la zona de residencia ---------#
path_add <- 'G:/hacer_hoy/anchovy/input/interanual/'
lon <- as.matrix(read.table(paste0(path_add, 'lon_grid.csv'), header = F))
lat <- as.matrix(read.table(paste0(path_add, 'lat_grid.csv'), header = F))
coast <- as.matrix(read.table(paste0(path_add, 'CoastLineIndex.csv'), header = F))


xyz <- cbind(as.vector(lon), as.vector(lat), as.vector(coast))
r <- rasterFromXYZ(xyz = xyz)
SP <- rasterToPolygons(clump(r==1), dissolve=TRUE)
k <- SP@polygons[[1]]@Polygons[[1]]@coords

# png(filename = 'C:/Users/ASUS/Desktop/ZonaResidencia.png', width = 1050, height = 850, res = 120)
# par(mfrow = c(1,2))
# image.plot(lon,lat,coast, main = 'Mascara zona de Residencia')
# 
# plot(r, main = 'Contorno zona de residencia')
# lines(k)
# dev.off()

#-------- Conteo de Particulas dentro de Zona de REsidencia -----------#
dirpath <- 'G:/hacer_hoy/anchovy/SensitivityTests12/1995simu1/'
files <- list.files(path = dirpath, pattern = 'output', full.names = T, recursive = T)

PercentParti <- NULL
pathTraj <- NULL
for(i in 1:length(files)){
  dat <- read.table(files[i])
  dat[,1] <- dat[,1]-360
  dat[,7] <- rep(i, dim(dat)[1])
  pathTraj <- rbind(pathTraj, dat)
  
  if(i == 1) totalParticles <- dim(dat)[1]
  
  lonlat <- as.matrix(dat[,1:2])
  inside <- sum(in.out(bnd = k, x = lonlat))
  Percent <- (inside * 100)/totalParticles
  PercentParti <- c(PercentParti, Percent)
  print(files[i])
  
  if(i == length(files)){
    lonlat <- as.matrix(dat[,1:2])
    reteinedIndex <- as.numeric(in.out(bnd = k, x = lonlat))
    dat[,8] <- reteinedIndex
    reteinedIndex <- subset(dat, dat[,8] == 1)
    reteinedIndex <- levels(as.factor(reteinedIndex$V6))
  }
}

png(filename = paste0(dirpath,'PorcentajeResidencia.png'), width = 850, height = 850, res = 120)
plot(1:length(PercentParti), PercentParti, type = 'l', xlab = 'Days', ylab = '%')
# abline(h = c(0,50), col = 'grey60')#, v = which.min(abs(PercentParti - 50)))
dev.off()

write.table(x = PercentParti, file = paste0(dirpath, 'PorcentajeResidencia.csv'), col.names = F, row.names = F)

endDay <- subset(pathTraj, pathTraj$V6 %in% reteinedIndex)
colnames(endDay) <- c('lon','lat','temp','knob','Wweight','drifter','day')
xlimmap <- c(-100, -70)    # X limits of plot
ylimmap <- c(-30, -0)      # Y limits of plot
#----PLOT ONLY RETEINED TRAJECTORIES in coastal zone----#
PNG4 <- paste0(dirpath, 'reteinedTrajectoriesCoastalZone.png')
# mymap <- get_map(location = c(lon = (lonmin + lonmax) / 2, lat = (latmin + latmax) / 2),
#                  zoom = 4, maptype = 'satellite', color='bw')
map   <- ggplot(data = endDay)
map <- map +
  geom_path(data = endDay, aes(group = drifter, x = lon, y = lat, colour = knob), size = .1) +
  scale_colour_gradientn(colours = tim.colors(n = 64, alpha = 1), expression(knob)) +
  labs(x = 'Longitude (W)', y = 'Latitude (S)') +
  borders(fill='grey',colour='grey') +
  coord_fixed(xlim = xlimmap, ylim = ylimmap, ratio = 2/2) +
  theme(axis.text.x  = element_text(face='bold', color='black',
                                    size=15, angle=0),
        axis.text.y  = element_text(face='bold', color='black',
                                    size=15, angle=0),
        axis.title.x = element_text(face='bold', color='black',
                                    size=15, angle=0),
        axis.title.y = element_text(face='bold', color='black',
                                    size=15, angle=90),
        legend.text  = element_text(size=15),
        legend.title = element_text(size=15))
if(!is.null(PNG4)) ggsave(filename = PNG4, width = 9, height = 9) else map
print(PNG4); flush.console()
#=============================================================================#
# END OF PROGRAM
#=============================================================================#