#=============================================================================#
# Rutina para obtener promedios decadales y climatologia de huevos y larvas
#=============================================================================#
library(raster)
library(maps)
library(mapdata)

dirpath <- 'F:/COLLABORATORS/KINESIS/egg_larvae/' # Ruta donde estan almacenados los datos
filename <- 'PRUEBA_JTM.csv' # Nombre del archivo
ONI_file1 <- 'ENSO_periods.csv'
ONI_file2 <- 'ONI_sort.csv'

dat <- read.csv(paste0(dirpath, filename), sep = ';')
x <- dat$Long # Vector de longitudes
y <- dat$Lat  # Vector de latitudes
z <- dat$Anc_lar_dst # Vector de valores de densidad de huevos o larvas (cambiar de acuerdo al caso)

ini_year <- 1960
end_year <- 1980

vari_dens <- 'larvae'

#---------------No cambiar nada a partir de aqui--------------------#
dir.create(paste0(dirpath, 'output/'), showWarnings = F)
dat <- cbind(dat[,1:2], x, y, z)
dat$z[dat$z == 0] <- NA
dat <- dat[complete.cases(dat), ] # Filtro para eliminar NA

years <- seq(ini_year, end_year, by = 10)
res <- 1/12

for(i in 1:length(years)){
  
  # Sub-grupo decadal
  dat2 <- subset(dat, dat$Year %in% c(years[i] : (years[i]+9)))
  if(dim(dat2)[1] == 0){
    next()
  }else{
    x <- dat2$x
    y <- dat2$y
    z <- dat2$z
    
    xy <- matrix(c(x,y), ncol = 2)
    r <- raster(xmn=-100, xmx=-70, ymn=-40, ymx=15, res=res)
    r[] <- 0
    tab <- table(cellFromXY(r, xy))
    r[as.numeric(names(tab))] <- tab
    d <- data.frame(coordinates(r), count=r[])
    d <- subset(d, d$count != 0)
    
    ras <- rasterize(x = xy, y = r, field = z, fun = mean)
    ras <- ras@data@values
    ras <- ras[complete.cases(ras)]
    
    xyz <- cbind(d[,1:2], ras)
    xyz$x <- xyz$x +360
    
    csv_name <- paste0(dirpath,'output/', vari_dens , years[i], '_', (years[i]+9), '.csv')
    write.table(x = xyz, file = csv_name, row.names = F, col.names = F, sep = ';')
  }
  
  # Sub-grupo climatologico decadal
  for(j in 1:12){
    dat3 <- subset(dat2, dat2$Month == j)
    if(dim(dat3)[1] == 0){
      next()
    }else{
      x <- dat3$x
      y <- dat3$y
      z <- dat3$z
      
      xy <- matrix(c(x,y), ncol = 2)
      r <- raster(xmn=-100, xmx=-70, ymn=-40, ymx=15, res=res)
      r[] <- 0
      tab <- table(cellFromXY(r, xy))
      r[as.numeric(names(tab))] <- tab
      d <- data.frame(coordinates(r), count=r[])
      d <- subset(d, d$count != 0)
      
      ras <- rasterize(x = xy, y = r, field = z, fun = mean)
      ras <- ras@data@values
      ras <- ras[complete.cases(ras)]
      
      xyz <- cbind(d[,1:2], ras)
      xyz$x <- xyz$x +360
      
      csv_name <- paste0(dirpath,'output/', vari_dens , years[i], '_', (years[i]+9), '_M' ,j, '.csv')
      write.table(x = xyz, file = csv_name, row.names = F, col.names = F, sep = ';')
    }
  }
}

# Climatologia
# x11()
# par(mfrow = c(3, 4),        # 2x2 layout
#     oma = c(2, 2, 1, 0.5),  # two rows of text at the outer left and bottom margin
#     mar = c(1, 1, .5, 3.7), # space for one row of text at ticks and to separate plots
#     mgp = c(2, .5, 0),      # axis label at 2 rows distance, tick labels at 1 row
#     xpd = F,                # allow content to protrude into outer margin (and beyond)
#     font = 2)

for(i in 1:12){
  clim_dat <- subset(dat, dat$Month == i)
    if(dim(clim_dat)[1] == 0){
    next()
  }else{
    x <- clim_dat$x
    y <- clim_dat$y
    z <- clim_dat$z
        
    xy <- matrix(c(x,y), ncol = 2)
    r <- raster(xmn=-100, xmx=-70, ymn=-40, ymx=15, res=res)
    r[] <- 0
    tab <- table(cellFromXY(r, xy))
    r[as.numeric(names(tab))] <- tab
    d <- data.frame(coordinates(r), count=r[])
    d <- subset(d, d$count != 0)
    
    ras <- rasterize(x = xy, y = r, field = z, fun = mean)
    ras <- ras@data@values
    ras <- ras[complete.cases(ras)]
    
    xyz <- cbind(d[,1:2], ras)
    xyz$x <- xyz$x +360
    
    csv_name <- paste0(dirpath, 'output/' ,vari_dens, i, '.csv')
    write.table(x = xyz, file = csv_name, row.names = F, col.names = F, sep = ';')

    # plot(xyz$x-360, xyz$y, xlim = c(-85,-70), ylim = c(-20,0), xlab='', ylab='', pch = 20, axes = F)
    # axis(1)
    # axis(2, las = 2)
    # map('worldHires',add=T,fill=T,col='gray')
    # box()
  }
}


## ONI ##
oni1 <- read.table(paste0(dirpath, ONI_file1), sep = ';', header = T)
oni1$category <- as.character(oni1$category)
oni2 <- read.table(paste0(dirpath, ONI_file2), sep = ';', header = T)
oni2$category <- as.character(oni2$category)
 

for(i in 1:dim(oni1)[1]){
  enso_years  <- c(oni1$ini_year[i] , oni1$end_year[i])
  enso_months <- c(oni1$ini_month[i], oni1$end_month[i])
  
  row1 <- which(oni2$year == enso_years[1] & oni2$month == enso_months[1])
  row2 <- which(oni2$year == enso_years[2] & oni2$month == enso_months[2])
  
  period <- oni2[row1:row2,]
  
  peridoALL <- NULL
  for(j in 1:dim(period)[1]){
    sub_peri <- subset(dat, dat$Year == period$year[j] & dat$Month == period$month[j])
    peridoALL <- rbind(peridoALL, sub_peri)
  }
  
  if (dim(peridoALL)[1] != 0) {
    peri_name <- oni1$category[i]
    
    x <- peridoALL$x
    y <- peridoALL$y
    z <- peridoALL$z
    
    xy <- matrix(c(x,y), ncol = 2)
    r <- raster(xmn=-100, xmx=-70, ymn=-40, ymx=15, res=res)
    r[] <- 0
    tab <- table(cellFromXY(r, xy))
    r[as.numeric(names(tab))] <- tab
    d <- data.frame(coordinates(r), count=r[])
    d <- subset(d, d$count != 0)
    
    ras <- rasterize(x = xy, y = r, field = z, fun = mean)
    ras <- ras@data@values
    ras <- ras[complete.cases(ras)]
    
    xyz <- cbind(d[,1:2], ras)
    xyz$x <- xyz$x +360
    
    csv_name <- paste0(dirpath,'output/', peri_name, '_',enso_years[1],'M',enso_months[1],'_',enso_years[2],'M',enso_months[2],vari_dens , '.csv')
    write.table(x = xyz, file = csv_name, row.names = F, col.names = F, sep = ';')
  }
}

rm(list = ls())
