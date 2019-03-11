#=============================================================================#
# Rutina para obtener promedios decadales y climatologia de huevos y larvas
#=============================================================================#

# En caso no esten instaladas las siguientes librerias, descomentar y ejecutar la siguiente linea solo una vez
# install.packages('raster'); install.packages('maps'); install.packages('mapdata')

library(raster)
library(maps)
library(mapdata)

dirpath <- 'F:/COLLABORATORS/KINESIS/egg_larvae/' # Ruta donde estan almacenados los datos
filename <- 'PRUEBA_JTM.csv' # Nombre del archivo que contiene los datos de huevos y larvas
varis <- c('Anc_egg', 'Anc_lar', 'Sar_egg', 'Sar_lar')

#--------------- NO CAMBIAR NADA DESDE AQUI --------------------#
for(name_var in varis){
  dat <- read.csv(paste0(dirpath, filename), sep = ',')
  col_index <- which(names(dat) == name_var)
  x <- dat$Long # Vector de longitudes
  y <- dat$Lat  # Vector de latitudes
  z <- dat[ , col_index] # Vector de valores de densidad de huevos o larvas (cambiar de acuerdo al caso)
  vari_dens <- names(dat)[col_index] # Prefijo para nombrar los archivos de salida.
  
  ONI_file1 <- 'ENSO_periods.csv'
  ONI_file2 <- 'ONI_sort.csv'
  
  res <- 1/12 # Resolucion de salida
  starting <- 1960
  ending <- 2018
  
  xmn=-100; xmx=-70; ymn=-40; ymx=15
  
  dir.create(paste0(dirpath, 'output/'), showWarnings = F)
  dat <- cbind(dat[,1:2], x, y, z)
  dat$z[dat$z == 0] <- NA
  dat <- dat[complete.cases(dat), ] # Filtro para eliminar NA
  
  years <- seq(starting, ending, by = 10)
  
  # Get decadal mean
  DecadalMean <- NULL
  for(i in 1:length(years)){
    
    # Sub-grupo decadal
    range_years <- c(years[i] : (years[i]+9))
    dat2 <- subset(dat, dat$Year %in% range_years)
    if(dim(dat2)[1] == 0){
      next()
    }else{
      x <- dat2$x
      y <- dat2$y
      z <- dat2$z
      
      xy <- matrix(c(x,y), ncol = 2)
      r <- raster(xmn=xmn, xmx=xmx, ymn=ymn, ymx=ymx, res=res)
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
      
      decada <- range_years[1]
      
      xyz$decada <- rep(decada, times = dim(xyz)[1])
      DecadalMean <- rbind(DecadalMean, xyz)
      
    }
  }
  colnames(DecadalMean) <- c('lon', 'lat', vari_dens, 'decada')
  csv_name <- paste0(dirpath,'output/', 'DecadalMean_',vari_dens , '.csv')
  write.table(x = DecadalMean, file = csv_name, row.names = F, col.names = T, sep = ';')
  
  
  
  # x11()
  # par(mfrow = c(3, 4),        # 2x2 layout
  #     oma = c(2, 2, 1, 0.5),  # two rows of text at the outer left and bottom margin
  #     mar = c(1, 1, .5, 3.7), # space for one row of text at ticks and to separate plots
  #     mgp = c(2, .5, 0),      # axis label at 2 rows distance, tick labels at 1 row
  #     xpd = F,                # allow content to protrude into outer margin (and beyond)
  #     font = 2)
  
  # Climatologia
  Climatologia <- NULL
  for(i in 1:12){
    clim_dat <- subset(dat, dat$Month == i)
    if(dim(clim_dat)[1] == 0){
      next()
    }else{
      x <- clim_dat$x
      y <- clim_dat$y
      z <- clim_dat$z
      
      xy <- matrix(c(x,y), ncol = 2)
      r <- raster(xmn=xmn, xmx=xmx, ymn=ymn, ymx=ymx, res=res)
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
      
      
      
      # plot(xyz$x-360, xyz$y, xlim = c(-85,-70), ylim = c(-20,0), xlab='', ylab='', pch = 20, axes = F)
      # axis(1)
      # axis(2, las = 2)
      # map('worldHires',add=T,fill=T,col='gray')
      # box()
    }
    xyz$mes <- rep(i, times = dim(xyz)[1])
    Climatologia <- rbind(Climatologia, xyz)
  }
  colnames(Climatologia) <- c('lon', 'lat', vari_dens, 'mes')
  csv_name <- paste0(dirpath, 'output/', 'Climatology_' ,vari_dens, '.csv')
  write.table(x = Climatologia, file = csv_name, row.names = F, col.names = T, sep = ';')
  
  
  # ONI
  oni1 <- read.table(paste0(dirpath, ONI_file1), sep = ';', header = T)
  oni1$category <- as.character(oni1$category)
  oni2 <- read.table(paste0(dirpath, ONI_file2), sep = ';', header = T)
  oni2$category <- as.character(oni2$category)
  
  ENSO <- levels(as.factor(oni1$category))
  for(cat in ENSO){
    ENSO_cat <- subset(oni1, oni1$category == cat)
    
    categ <- NULL
    for(i in 1:dim(ENSO_cat)[1]){
      enso_years  <- c(ENSO_cat$ini_year[i] , ENSO_cat$end_year[i])
      enso_months <- c(ENSO_cat$ini_month[i], ENSO_cat$end_month[i])
      
      row1 <- which(oni2$year == enso_years[1] & oni2$month == enso_months[1])
      row2 <- which(oni2$year == enso_years[2] & oni2$month == enso_months[2])
      
      period <- oni2[row1:row2,]
      
      peridoALL <- NULL
      for(j in 1:dim(period)[1]){
        sub_peri <- subset(dat, dat$Year == period$year[j] & dat$Month == period$month[j])
        peridoALL <- rbind(peridoALL, sub_peri)
      }
      
      categ <- rbind(categ, peridoALL)
      
      
    }
    colnames(categ) <- c('year', 'month', 'lon', 'lat', vari_dens)
    csv_name <- paste0(dirpath,'output/', 'ONI','_',cat, '_',vari_dens , '.csv')
    write.table(x = categ, file = csv_name, row.names = F, col.names = T, sep = ';')
  }
  
  # Interanual
  interanual <- NULL
  for(year in starting:ending){
    for(month in 1:12){
      # print(c(year, month))
      
      inter <- subset(dat, dat$Year == year & dat$Month == month)
      
      if (dim(inter)[1] == 0) {
        next()
      }else{
        
      }
      
      x <- inter$x
      y <- inter$y
      z <- inter$z
      
      xy <- matrix(c(x,y), ncol = 2)
      r <- raster(xmn=xmn, xmx=xmx, ymn=ymn, ymx=ymx, res=res)
      r[] <- 0
      tab <- table(cellFromXY(r, xy))
      r[as.numeric(names(tab))] <- tab
      d <- data.frame(coordinates(r), count=r[])
      d <- subset(d, d$count != 0)
      
      ras <- rasterize(x = xy, y = r, field = z, fun = mean)
      ras <- ras@data@values
      ras <- ras[complete.cases(ras)]
      
      xyz <- cbind(d[,1:2], ras)
      # xyz$x <- xyz$x +360
      # xyz$Year <- year
      # xyz$Month <- month
      
      strDate <- paste0('01/',month,'/',year)
      fecha <- as.character(as.Date(strDate, "%d/%m/%Y"))
      
      mean_inter <- c(fecha, mean(xyz$ras))
      
      interanual <- rbind(interanual, mean_inter)
    }
  }
  colnames(interanual) <- c('fecha', vari_dens)
  csv_name <- paste0(dirpath,'output/', 'interanual', '_',vari_dens , '.csv')
  write.table(x = interanual, file = csv_name, row.names = F, col.names = T, sep = ';')
}
rm(list = ls())