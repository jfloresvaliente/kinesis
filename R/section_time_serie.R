#=============================================================================#
# Name   : section_time_serie
# Author : Jorge Flores
# Date   : 
# Version:
# Aim    : 
# URL    : 
#=============================================================================#
source('R/getline_rowcol_index.R')
dirpath <- 'G:/ROMS_SIMULATIONS/ROMS6B_VINCENT_SIMULATION/'
nc_grid <- paste0(dirpath, 'roms_grd.nc')
# getline_rowcol_index(nc_grid = nc_grid)
getline_rowcol_index(nc_grid = nc_grid, lon1 = -80.2, lat1 = -7, lon2 = -77, lat2 = -13)

for(i in 1:dim(LineRowColIndex)[1]){
  mask[LineRowColIndex[i,1] , LineRowColIndex[i,2]] <- 2
}
mask[mask != 2] <- NA
mask[mask == 2] <- 1

varnames <- c('temp', 'DCHL', 'ZOO', 'MESO')
VAR1 <- NULL; VAR2 <- NULL; VAR3 <- NULL; VAR4 <- NULL
for(year in 1958:2008){
  for(month in 1:12){
    nc_file <- paste0(dirpath, 'roms6b_avg.Y', year, '.M',month, '.rl1b.nc')
    nc <- nc_open(nc_file)
    
    var1 <- ncvar_get(nc, varnames[1])[,,32,]; var1 <- apply(var1, c(1,2), mean); var1 <- mean(var1 * mask, na.rm = T)
    var2 <- ncvar_get(nc, varnames[2])[,,32,]; var2 <- apply(var2, c(1,2), mean); var2 <- mean(var2 * mask, na.rm = T)
    var3 <- ncvar_get(nc, varnames[3])[,,32,]; var3 <- apply(var3, c(1,2), mean); var3 <- mean(var3 * mask, na.rm = T)
    var4 <- ncvar_get(nc, varnames[4])[,,32,]; var4 <- apply(var4, c(1,2), mean); var4 <- mean(var4 * mask, na.rm = T)
    
    VAR1 <- c(VAR1, var1)
    VAR2 <- c(VAR2, var2)
    VAR3 <- c(VAR3, var3)
    VAR4 <- c(VAR4, var4)
    
    print(nc_file)
  }
}

fech <- seq(as.Date('1958-01-01'), as.Date('2008-12-01'), by = 'month')
tiff(filename = paste0(dirpath, 'ROMS_timeseries.tiff'), width = 1250, height = 850, res = 120)
par(mfrow = c(4,1), mar = c(2,5,1,1))
plot(fech, VAR1, type = 'l', ylab = varnames[1], xlab = '')
plot(fech, VAR2, type = 'l', ylab = varnames[2], xlab = '')
plot(fech, VAR3, type = 'l', ylab = varnames[3], xlab = '')
plot(fech, VAR4, type = 'l', ylab = varnames[4], xlab = '')
dev.off()

dat <- cbind(as.character(fech), VAR1, VAR2, VAR3, VAR4)
colnames(dat) <- c('fechas', varnames)
write.table(x = dat, file = paste0(dirpath, 'ROMS_timeseries.csv'), sep = ';', col.names = T, row.names = F)
#=============================================================================#
# END OF PROGRAM
#=============================================================================#