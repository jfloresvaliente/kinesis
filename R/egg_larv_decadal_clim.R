#=============================================================================#
# Rutina para obtener promedios decadales de huevos y larvas
#=============================================================================#
library(akima)

dirpath <- 'C:/Users/ASUS/Desktop/egg_larvae/' # Ruta donde estan almacenados los datos
filename <- 'PRUEBA_JTM.csv' # Nombre del archivo

dat <- read.csv(paste0(dirpath, filename), sep = ';')
x <- dat$Long # Vector de longitudes
y <- dat$Lat  # Vector de latitudes
z <- dat$Anc_lar_dst # Vector de valores de densidad de huevos o larvas (cambiar de acuerdo al caso)

ini_year <- 1960
end_year <- 1980

vari_dens <- 'larvae'
#---------------No cambiar nada a partir de aqui--------------------#
dat <- cbind(dat[,1:2], x, y, z)
dat <- dat[complete.cases(dat), ] # Filtro para eliminar NA

years <- seq(ini_year, end_year, by = 10)

# Define new lon-lat values for new grid (by = indicates spatial resolution in degrees)
x0 <- seq(from = -100, to = -70, by = 1/6)
y0 <- seq(from = -40 , to = 15 , by = 1/6) 

for(i in 1:length(years)){
  dat2 <- subset(dat, dat$Year %in% c(years[i] : (years[i]+9)))
  for(j in 1:12){
    dat3 <- subset(dat2, dat2$Month == j)
    if(dim(dat3)[1] == 0){
      next()
    }else{
      x <- dat3$x
      y <- dat3$y
      z <- dat3$z
      
      new_dat <- interp(x,y,z, xo = x0, yo = y0, duplicate = 'mean')
      newz <- new_dat[[3]]
      
      csv_name <- paste0(dirpath, vari_dens , years[i], '_', (years[i]+9), '_' ,j, '.csv')
      write.table(x = newz, file = csv_name, row.names = F, col.names = F, sep = ';')
    }
  }
}

# Climatologia
for(i in 1:12){
  dat3 <- subset(dat, dat$Month == i)
  if(dim(dat3)[1] == 0){
    next()
  }else{
    x <- dat3$x
    y <- dat3$y
    z <- dat3$z
    
    new_dat <- interp(x,y,z, xo = x0, yo = y0, duplicate = 'mean')
    newz <- new_dat[[3]]
    
    csv_name <- paste0(dirpath, vari_dens, i, '.csv')
    write.table(x = newz, file = csv_name, row.names = F, col.names = F, sep = ';')
  }
}
