#=============================================================================#
# Rutina para obtener promedios decadales de huevos y larvas
#=============================================================================#
library(mapdata)
library(raster)
library(mgcv)

dirpath <- 'C:/Users/ASUS/Desktop/egg_larvae/' # Ruta donde estan almacenados los datos
filename <- 'PRUEBA_JTM.csv' # Nombre del archivo

dat <- read.csv(paste0(dirpath, filename), sep = ';')
x <- dat$Long # Vector de longitudes
y <- dat$Lat  # Vector de latitudes
z <- dat$Anc_egg_dst # Vector de valores de densidad de huevos o larvas (cambiar de acuerdo al caso)

ini_year <- 1960
end_year <- 1980

vari_dens <- 'eggs'
#---------------No cambiar nada a partir de aqui--------------------#
mask <- as.matrix(read.csv(paste0(dirpath, 'input/mask_grid.csv'), header = F, sep = ''))
mask[mask ==0] <- NA
lon <- as.matrix(read.table(paste0(dirpath, 'input/lon_grid.csv'), header = F))
lat <- as.matrix(read.table(paste0(dirpath, 'input/lat_grid.csv'), header = F))
grilla <- matrix(data = 0, nrow = dim(lon)[1], ncol = dim(lon)[2])

dir.create(paste0(dirpath, 'output/'), showWarnings = F)
dat <- cbind(dat[,1:2], x, y, z)
dat$z[dat$z == 0] <- NA
# dat$z[dat$z >= 1] <- 1
dat <- dat[complete.cases(dat), ] # Filtro para eliminar NA

years <- seq(ini_year, end_year, by = 10)

# Define new lon-lat values for new grid (by = indicates spatial resolution in degrees)
x0 <- seq(from = -100, to = -70, by = 1/6)
y0 <- seq(from = -40 , to = 15 , by = 1/6)

# for(i in 1:length(years)){
#   dat2 <- subset(dat, dat$Year %in% c(years[i] : (years[i]+9)))
#   for(j in 1:12){
#     dat3 <- subset(dat2, dat2$Month == j)
#     if(dim(dat3)[1] == 0){
#       next()
#     }else{
#       x <- dat3$x
#       y <- dat3$y
#       z <- dat3$z
#       
#       new_dat <- interp(x,y,z, xo = x0, yo = y0, duplicate = 'mean')
#       newz <- new_dat[[3]]
#       
#       csv_name <- paste0(dirpath, vari_dens , years[i], '_', (years[i]+9), '_' ,j, '.csv')
#       write.table(x = newz, file = csv_name, row.names = F, col.names = F, sep = ';')
#     }
#   }
# }

x11()
par(mfrow = c(3, 4),        # 2x2 layout
    oma = c(2, 2, 1, 0.5),  # two rows of text at the outer left and bottom margin
    mar = c(1, 1, .5, 3.7), # space for one row of text at ticks and to separate plots
    mgp = c(2, .5, 0),      # axis label at 2 rows distance, tick labels at 1 row
    xpd = F,                # allow content to protrude into outer margin (and beyond)
    font = 2) 
# Climatologia
for(i in 1:12){
  clim_dat <- subset(dat, dat$Month == i)
  if(dim(clim_dat)[1] == 0){
    next()
  }else{
 
    # find rows
    rowIND <- NULL
    for(ro in 1:dim(grilla)[1]){
      test_grid <- grilla
      test_grid[ro,] <- 1
      
      xyz <- cbind(as.vector(lon), as.vector(lat), as.vector(test_grid))
      r <- rasterFromXYZ(xyz = xyz)
      SP <- rasterToPolygons(clump(r==1), dissolve=TRUE)
      k <- SP@polygons[[1]]@Polygons[[1]]@coords
      
      lonlat <- as.matrix(clim_dat[,3:4])
      vector_index <- which(in.out(bnd = k, x = lonlat) == T)
      
      if (length(vector_index > 0)) {
        rowIND <- c(rowIND, ro)
      }
      # print(ro)
    }
    
    #find cols
    colIND <- NULL
    for(co in 1:dim(grilla)[2]){
      test_grid <- grilla
      test_grid[,co] <- 1
      
      xyz <- cbind(as.vector(lon), as.vector(lat), as.vector(test_grid))
      r <- rasterFromXYZ(xyz = xyz)
      SP <- rasterToPolygons(clump(r==1), dissolve=TRUE)
      k <- SP@polygons[[1]]@Polygons[[1]]@coords
      
      lonlat <- as.matrix(clim_dat[,3:4])
      vector_index <- which(in.out(bnd = k, x = lonlat) == T)
      
      if (length(vector_index > 0)) {
        colIND <- c(colIND, co)
      }
      # print(co)
    }
    
    # Find new grid
    new_grilla <- matrix(data = NA, nrow = dim(lon)[1], ncol = dim(lon)[2])
    for(m in rowIND){
      for(n in colIND){
        test_grid <- grilla
        test_grid[m,n] <- 1
        
        xyz <- cbind(as.vector(lon), as.vector(lat), as.vector(test_grid))
        r <- rasterFromXYZ(xyz = xyz)
        SP <- rasterToPolygons(clump(r==1), dissolve=TRUE)
        k <- SP@polygons[[1]]@Polygons[[1]]@coords
        
        lonlat <- as.matrix(clim_dat[,3:4])
        vector_index <- which(in.out(bnd = k, x = lonlat) == T)
        
        if (length(vector_index > 0)) {
          new_grilla[m,n] <- 1
        }
        print(c(m,n))
      }
    }
    new_grilla <- new_grilla * mask
    posIND <- which(new_grilla == 1, arr.ind = T)
    posLON <- x0[posIND[,1]] + 360
    posLAT <- y0[posIND[,2]]
    posIND <- cbind(posLON, posLAT)
    
    csv_name <- paste0(dirpath, 'output/' ,vari_dens, i, '.csv')
    # write.table(x = newz, file = csv_name, row.names = F, col.names = F, sep = ';')
    write.table(x = posIND, file = csv_name, row.names = F, col.names = F, sep = ';')
    graphics::image(x0, y0, new_grilla, xlim = c(-85,-70), ylim = c(-20,0), xlab='', ylab='')
    map('worldHires',add=T,fill=T,col='gray')
    print(csv_name)
  }
}

