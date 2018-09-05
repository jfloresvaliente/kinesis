library(fields)
dirpath <- dirpath <- 'F:/COLLABORATORS/KINESIS/egg_larvae/output/' # Ruta donde estan almacenados los datos

lat <- rev(seq(-20, 0, 1))

monthRow <- NULL
for (i in 1:12) {
  csv_file <- paste0('F:/COLLABORATORS/KINESIS/egg_larvae/output/', 'Climatology_larvae', i, '.csv')
    dat <- read.table(file = csv_file, sep = ';', header = F)
    dat$V1 <- dat$V1 -360
    
    rowDat <- NULL
    for (j in 1:(length(lat)-1)) {
      # print(j)
      sublat <- subset(dat, dat$V2 <= lat[j] & dat$V2 > lat[j+1])
      if(dim(sublat)[1] == 0) vari <- NA else vari <- mean(sublat$V3)
      
      varirow <- c(mean(c(lat[j], lat[j+1])), vari)
      rowDat <- rbind(rowDat, varirow)
    }
    monthRow <- cbind(monthRow, rowDat[,2])
}

newlats <- rowDat[,1]

months <- matrix(data = 1:12, nrow = dim(monthRow)[1], ncol = 12, byrow = T)
latis  <- matrix(data = newlats, nrow = dim(monthRow)[1], ncol = 12, byrow = F)

x11()
par(mfrow = c(2,1))
image.plot(months, latis, log(monthRow), xlab = 'Months', ylab = 'Latitude', main = 'Climatological Density of Larvae')

timeRow <- colMeans(x = (monthRow), na.rm = T)
plot(1:12, timeRow, type = 'l', ylab = '# larvae')
# rm(list = ls())


#-------------------------- Interdecadal ---------------------------#

decadas <- seq(1960, 1970, 10)

decaRow <- NULL
for (i in decadas) {
  monthRow <- NULL
  for (j in 1:12) {
    csv_file <- paste0(dirpath, 'DecadalClimatology_larvae', i, '_', i+9, '_M',j, '.csv')
    
    if (!file.exists(csv_file)) {
      rowDat <- matrix(data = NA, ncol = 2, nrow = length(newlats))
    }else{
      dat <- read.table(file = csv_file, sep = ';', header = F)
      dat$V1 <- dat$V1 -360
      
      rowDat <- NULL
      for (k in 1:(length(lat)-1)) {
        # print(j)
        sublat <- subset(dat, dat$V2 <= lat[k] & dat$V2 > lat[k+1])
        if(dim(sublat)[1] == 0) vari <- NA else vari <- mean(sublat$V3)
        
        varirow <- c(mean(c(lat[k], lat[k+1])), vari)
        rowDat <- rbind(rowDat, varirow)
      }
    }
    
    monthRow <- cbind(monthRow, rowDat[,2])
  }
  decaRow <- cbind(decaRow, monthRow)
}


months <- matrix(data = 1:dim(decaRow)[2], nrow = dim(decaRow)[1], ncol = dim(decaRow)[2], byrow = T)
latis  <- matrix(data = newlats, nrow = dim(decaRow)[1], ncol = dim(decaRow)[2], byrow = F)

x11()
par(mfrow = c(2,1))
image.plot(months, latis, log(decaRow), xlab = 'Months', ylab = 'Latitude', main = 'Density of Larvae')

timeRow <- colMeans(x = (decaRow), na.rm = T)
plot(1:dim(decaRow)[2], timeRow, type = 'l', ylab = '# larvae')

# rm(list = ls())