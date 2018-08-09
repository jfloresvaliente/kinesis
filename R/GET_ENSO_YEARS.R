#=============================================================================#
# Rutina para obtener promedios ENSO YEARS
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

# Get ENSO periods
ENSO <- read.csv(paste0(dirpath, 'ONI_sort.csv'), header = T, sep = ';')
ENSO <- subset(ENSO, ENSO$year %in% 1961:2018)


for(i in 1:dim(dat)[1]){
  row_dat <- dat[i,]
  if(dim(row_dat)[1] == 0){
    next()
  }else{
    A <- subset(ENSO, ENSO$year == row_dat$Year & ENSO$month == row_dat$Month)
    dat$category[i] <- as.character(A$category) 
  }
}

dat <- cbind(dat[,1:2], x, y, z, dat$category)
colnames(dat) <- c(colnames(dat)[1:dim(dat)[2]-1], 'category')
dat <- dat[complete.cases(dat), ] # Filtro para eliminar NA

# row_all <- NULL
# for(i in 1:dim(ENSO)[1]){
#   if (i == 1) {
#     ENSO_ini <- ENSO$category[1]
#     year_in <- ENSO$year[1]
#     month_in <- ENSO$month[1]
#   }else{
#     if (ENSO_ini != ENSO$category[i]) {
#       year_end <- ENSO$year[i-1]
#       month_end <- ENSO$month[i-1]
#       rowdat <- cbind(year_in, month_in, year_end, month_end, as.character(ENSO_ini))
#       row_all <- rbind(row_all, rowdat)
#       
#       ENSO_ini <- ENSO$category[i]
#       year_in <- ENSO$year[i]
#       month_in <- ENSO$month[i]
#     }
#   }
# }
# colnames(row_all) <- c('year_in', 'month_in', 'year_end', 'month_end', 'category')



