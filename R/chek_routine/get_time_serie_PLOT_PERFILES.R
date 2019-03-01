#=============================================================================#
# Name   : 
# Author : Jorge Flores
# Date   : 
# Version:
# Aim    : 
# URL    : 
#=============================================================================#
# library(ncdf4)
library(fields)
library(sp)

nc <- nc_open('G:/ROMS_SIMULATIONS/ROMS6B_VINCENT_SIMULATION/roms6b_avg.Y1958.M1.rl1b.nc')
dirpath <- 'G:/ROMS_SIMULATIONS/ROMS6B_VINCENT_SIMULATION/'

lon <- ncvar_get(nc, 'lon_rho'); lon <- lon[,1]
lat <- ncvar_get(nc, 'lat_rho'); lat <- lat[1,]
mask <- ncvar_get(nc, 'mask_rho')

var_name <- 'DCHL'
load(paste0(dirpath, var_name, ".RData"))
VARI <- DCHL
# rm(eval(var_name))

latitudes <- c(-5,-10,-15,-20)
latInd <- NULL
for(i in 1:length(latitudes)){
  Ind <- which.min(abs(lat - latitudes[i]))
  latInd <- c(latInd, Ind)
  print(lat[Ind])
}

coast_init <- numeric(length = length(latitudes))
for(i in 1:length(latInd)){
  nlat <- latInd[i]

  row_serie <- VARI[,nlat,1]
  row_serie[1] <- row_serie[1] + 0.0000001
  
  coast_init[i] <- which.max(row_serie == 0) - 1
}

allLATS <- NULL
for(i in 1:length(latitudes)){
  lat1 <- VARI[(coast_init[i]-3):(coast_init[i]),latInd[i],]
  # lat2 <- VARI[(coast_init[i]-3):(coast_init[i]),latInd[i],]
  # lat3 <- VARI[(coast_init[i]-3):(coast_init[i]),latInd[i],]
  # lat4 <- VARI[(coast_init[i]-3):(coast_init[i]),latInd[i],]
  lat1 <- apply(lat1, c(2), mean)
  allLATS <- cbind(allLATS, lat1)
}

initial_date  <- as.Date(paste0(1958,'-01-03'))
date          <- as.Date(seq(from = initial_date, by = 'month', length.out = 612))
allLATS <- cbind(as.character(date),allLATS)
colnames(allLATS) <- c('Date', 'lat5', 'lat10','lat15','lat20')
write.csv(x = allLATS, file = paste0(dirpath, 'DCHL.csv'), row.names = F)

# La distancia a la costa es de 55 km
# coast_lon <- lon[1:4]
# disMat <- matrix(c(coast_lon, rep(latitudes[1], length(coast_lon))), nrow = length(coast_lon), ncol = 2)
# coast_distance <- spDistsN1(pts = disMat, pt= disMat[1,], longlat = T)
#=============================================================================#
# END OF PROGRAM
#=============================================================================#