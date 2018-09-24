# library(raster)
library(ncdf4)
library(fields)

nc <- nc_open('G:/ROMS_SIMULATIONS/ROMS6B_VINCENT_SIMULATION/roms6b_avg.Y1958.M1.rl1b.nc')

x <- ncvar_get(nc, 'lon_rho')
y <- ncvar_get(nc, 'lat_rho')
z <- ncvar_get(nc, 'mask_rho')

x11(); image.plot(x,y,z, xlab = 'Lon', ylab = 'Lat')
locat <- locator(n = 2, type = 'p')
locat <- cbind(locat$x, locat$y)
locat <- locat[rev(order(locat[,1])),]

mod1 <- lm(locat[,2] ~ locat[,1])
coe  <- coef(mod1)

newX <- seq(locat[1,1], locat[2,1], by = -1/100)
newY <- coe[1] + (coe[2] * newX)

lines(newX, newY)


rowind <- NULL
colind <- NULL
for(i in 1:length(x)){
  lonind <- which.min(abs(x[,1]-newX[i]))
  latind <- which.min(abs(y[1,]-newY[i]))
  z[lonind,latind] <- NA
  
  rowind <- c(rowind, lonind)
  colind <- c(colind, latind)
}
rowcol <- cbind(rowind, colind)
rowcol <- rowcol[!duplicated(rowcol), ]

x11(); image.plot(x,y,z, xlab = 'Lon', ylab = 'Lat')
lines(newX, newY)

for(i in 1:dim(rowcol)[1]){
  z[rowcol[i,1],rowcol[i,2]] <- NA
}
x11(); image.plot(x,y,z)
z[which(!is.na(z))] = 2
z[which(is.na(z))] = 1
z[which(z == 2)] = NA

temp <- ncvar_get(nc, 'temp')
temp <- temp[,,32,1]

temp2 <- temp * z
mean(temp, na.rm = T)



