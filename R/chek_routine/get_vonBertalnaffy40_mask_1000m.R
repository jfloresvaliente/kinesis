Linf <- 20.5
k    <- 0.86
t0   <- -0.14

t_serie <- 1:(365*10)/365
L0   <- Linf * (1 - exp(-k*(t_serie-t0)))

x11();plot(t_serie, L0, type = 'l', yaxs = 'i', xaxs = 'i')
abline(v = 1)

per40 <- L0[365]
per40 - (per40 * 40)/100

## 
library(ncdf4)
library(fields)
library(maps)
library(mapdata)
nc <- nc_open('D:/ROMS_SIMULATIONS/ROMS6B_VINCENT_SIMULATION/roms_grd.nc')
nc
h <- ncvar_get(nc, 'h')
lon <- ncvar_get(nc, 'lon_rho')
lat <- ncvar_get(nc, 'lat_rho')
mask <- ncvar_get(nc, 'mask_rho')
mask[mask == 0] <- NA

x11();image.plot(lon, lat, h)
map('worldHires', add=T, fill=T, col='gray')

h200 <- h
h200[h200 > 200] <- NA
x11();image.plot(lon, lat, h200*mask)
map('worldHires', add=T, fill=T, col='gray')

h1000 <- h
h1000[h1000 > 1000] <- NA
x11();image.plot(lon, lat, h1000*mask)
map('worldHires', add=T, fill=T, col='gray')

