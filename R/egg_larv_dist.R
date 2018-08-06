#===============================================================================
# Rutina para lectura de datos y ploteo de mapas
#===============================================================================
library(akima)
library(fields)
library(mapdata)

dirpath <- 'C:/Users/ASUS/Desktop/' # Ruta donde estan almacenados los datos
filename <- 'PRUEBA_JTM.csv' # Nombre del archivo

dat <- read.csv(paste0(dirpath, filename), sep = ';')
dat <- dat[complete.cases(dat), ] # Filtro para eliminar NA

x <- dat$Long # Vector de longitudes
y <- dat$Lat  # Vector de latitudes
z <- dat$Anc_lar_dst # Vector de valores de densidad de huevos o larvas

xlimmap <- c(-100, -70)    # X limite de longitud
ylimmap <- c(-20, -0)      # Y limite de latitud
zlimmap <- c(0,2000)       # Representa la densidad de huevos/larvas

ini_year <- 1962
end_year <- 1965

#---------------No cambiar nada a partir de aqui--------------------#
mask <- as.matrix(read.csv(paste0(dirpath, 'mask_grid.csv'), sep = '', header = F))
mask[mask == 0] <- NA

dat <- cbind(dat[,1:3], x, y, z)
dat <- subset(dat, dat$Year %in% c(ini_year : end_year))

# Define new lon-lat values for new grid (by = indicates spatial resolution in degrees)
x0 <- seq(from = -100, to = -70, by = 1/6)
y0 <- seq(from = -40 , to = 15 , by = 1/6) 

# Get climatological maps
# x11()
# par(mfrow = c(3, 4),        # 2x2 layout
#     oma = c(2, 2, 1, 0.5),  # two rows of text at the outer left and bottom margin
#     mar = c(1, 1, .5, 3.7), # space for one row of text at ticks and to separate plots
#     mgp = c(2, .5, 0),      # axis label at 2 rows distance, tick labels at 1 row
#     xpd = F,                # allow content to protrude into outer margin (and beyond)
#     font = 2)            

for(i in 1:12){
  dat2 <- subset(dat, dat$Month == i)
  
  x <- dat2$x
  y <- dat2$y
  z <- dat2$z
  
  new_dat <- interp(x,y,z, xo = x0, yo = y0, duplicate = 'mean')
  newz <- new_dat[[3]]
  
  x11(); par(mfrow = c(1,2))
  image.plot(x0, y0, newz,
             xlim = xlimmap, ylim = ylimmap, zlim = zlimmap,
             axes = F)#, xlab = 'Lon', ylab = 'Lat')
  map('worldHires', add=T, fill=T, col='gray') #, ylim = c(-20,0), xlim = c(-100,70))
  box(lwd = 2)
  if(i == 1 | i == 5 | i == 9) axis(2, las = 2, lwd = 2, font = 2)
  if(i == 9 | i == 10 | i== 11 | i == 12) axis(1, lwd = 2, font = 2)
  legend('bottomleft', legend = paste('Month',i), adj = .1, bty = 'n')
  
  # Buscar los valores mas altos
  newz <- newz * mask
  newz[newz < mean(newz, na.rm = T)] = NA
  posi <- which(newz >= mean(newz, na.rm = T), arr.ind = T)
  lons <- x0[posi[,1]]
  lats <- y0[posi[,2]]
  
  map('worldHires', add=F, fill=T, col='gray', ylim = ylimmap, xlim = xlimmap)
  box(lwd = 2)
  axis(side = 1, at = seq(xlimmap[1], xlimmap[2], 5), labels = seq(xlimmap[1],xlimmap[2], 5),
       lwd = 2, lwd.ticks = 2, font.axis=4)
  axis(side = 2, at = seq(ylimmap[1]+2, ylimmap[2]-2, 5), labels = seq(ylimmap[1]+2, ylimmap[2]-2, 5),
       lwd = 2, lwd.ticks = 2, font.axis=4, las = 2)
  points(lons, lats, pch = 19, cex = .1)
}

