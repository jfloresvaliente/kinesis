# library(ncdf4)
# library(fields)
# library(R.matlab)

# source('R/getline_rowcol_index.R')
dirpath <- 'G:/Ascat_clim/frc/'
# nc <- 'G:/Ascat_daily/newperush_grd.nc'
# lon1 = -80.2+360; lat1 = -7; lon2 = -77+360; lat2 = -13
# getline_rowcol_index(nc_grid = nc, lon1, lat1, lon2, lat2)
# write.table(x = LineIndex, file = 'C:/Users/ASUS/Desktop/LineIndex.txt', col.names = F, row.names = F)



ufiles <- list.files(path = dirpath, pattern = paste0('sustr.*\\.txt'), full.names = T)
vfiles <- list.files(path = dirpath, pattern = paste0('svstr.*\\.txt'), full.names = T)

u <- read.table(ufiles, header = F)
v <- read.table(vfiles, header = F)

stress <- sqrt(u^2 * v^2)

serieTime <- NULL
for(i in 1:12){
  step1 <- stress[,i]
  # step1 <- matrix(step1, nrow = 402, ncol = 752, byrow = T)
  # step1 <- step1 * mask
  step1mean <- mean(step1, na.rm = T)
  serieTime <- c(serieTime, step1mean)
}
serie_mensual <- rep(serieTime, times = 5)
# plot(serie_mensual, type = 'l')

# Serie diaria
dirpath <- 'G:/Ascat_daily/frc/'
ufiles <- list.files(path = dirpath, pattern = paste0('sustr.*\\.txt'), full.names = T)
vfiles <- list.files(path = dirpath, pattern = paste0('svstr.*\\.txt'), full.names = T)

serieTime <- NULL
for(i in 1:length(ufiles)){
  u <- read.table(ufiles[i], header = F)
  v <- read.table(vfiles[i], header = F)
  stress <- sqrt(u^2 * v^2)

  print(c(ufiles[i], vfiles[i]))

  for(j in 1:dim(u)[2]){
    step1 <- stress[,j]
    # step1 <- matrix(step1, nrow = 402, ncol = 752, byrow = T)
    # step1 <- step1 * mask
    step1mean <- mean(step1, na.rm = T)
    serieTime <- c(serieTime, step1mean)
  }
}
serie_diaria <- serieTime
serie_diaria[serie_diaria > 0.0015] <- 0.0015
serie_diaria <- serie_diaria[1:1800]
# plot(serie_diaria, type = 'l')


png('F:/ichthyop_output_analysis/CONCIMAR2018/vientos.png', width = 950, height = 550, res = 120)

fechas <- seq(as.Date("2008/1/1"), by = "day", length.out = 1800)
plot(fechas, serie_diaria, type = 'l', col = 'red', ylab = '', xlab = '', yaxt='n')
box(lwd = 2)
mtext(text = 'Viento', side = 2, font = 2)

par(new = T)

plot(serie_mensual, type = 'l', ylab = '', yaxt='n', xlab = '', lwd = 2, axes = F)


# axis(1, at = fechas, labels = fechas)

# fechas <- seq(as.Date("2008/1/1"), by = "day", length.out = length(serie_diaria))


legend('topright', legend = c('Mensual', 'Diario'),
       bty = 'n', lty = c(1,1), col = c('black', 'red'),
       lwd = c(2,2))
dev.off()


#### Serie diaria en promedio mensual
month_index <- seq(1,1800,30)

mont_serie <- NULL
for(i in 1:length(month_index)){
  # print(i)
  a <- mean(serie_diaria[month_index[i] : (month_index[i]+29)])
  mont_serie <- c(mont_serie, a)
}

# Plot 2
png('F:/ichthyop_output_analysis/CONCIMAR2018/vientos2.png', width = 950, height = 550, res = 120)

fechas <- seq(as.Date("2008/1/1"), by = "month", length.out = 60)
plot(fechas, mont_serie, type = 'l', col = 'red', ylab = '', xlab = '', yaxt='n')
box(lwd = 2)
mtext(text = 'Viento', side = 2, font = 2)

par(new = T)

plot(serie_mensual, type = 'l', ylab = '', yaxt='n', xlab = '', lwd = 2, axes = F)

legend('topright', legend = c('Mensual', 'Diario'),
       bty = 'n', lty = c(1,1), col = c('black', 'red'),
       lwd = c(2,2))
dev.off()