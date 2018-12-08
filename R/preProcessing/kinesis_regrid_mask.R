#=============================================================================#
# Name   : kinesis_regrid_mask
# Author : Jorge Flores - Jorge Tam
# Date   : 15/06/2017
# Version: V1
# Aim    : Transform irregular mask to regular mask for Kinesis model inputs
# URL    : 
#=============================================================================#
library(ncdf4)
library(fields)
library(akima)

# Step 1: Get irregular grid (for lon_rho, lat_rho, mask_rho) from any-ROMS file
dirpath <- 'D:/ROMS_SIMULATIONS/ROMS6B_VINCENT_SIMULATION/' # To store new mask
nc_file <- paste0(dirpath, 'roms6b_avg.Y2008.M1.rl1b.nc') # Name of any-ROMS file
outpath <- 'F:/GitHub/kinesis/data/'

# Do not change anything after here.
nc   <- nc_open(paste0(nc_file))
mask <- ncvar_get(nc, 'mask_rho')        # matrix
lon  <- ncvar_get(nc, 'lon_rho')         # matrix
lat  <- ncvar_get(nc, 'lat_rho')         # matrix

# Step 2: Define new lon-lat values for new grid (by = indicates spatial resolution in degrees)
x0 <- seq(from = -100, to = -70, by = 1/6) # lon limits and spatial resolution
y0 <- seq(from = -40 , to = 15, by = 1/6) # lat limits and spatial resolution

# Step 3: Convert matrix into vectors (prepare data to regrid)
x <- as.vector(lon)
y <- as.vector(lat)
z <- as.vector(mask)

# Create a new mask-grid
newmask <- interp(x,y,z, xo = x0, yo = y0)
z0 <- as.vector(newmask[[3]])

# Loop to change values between 0-1 to 0 (due to re-grid interpolation)
for(i in 1:length(z0)){
  if (z0[i]>0 & z0[i]<1) { z0[i] = 0 }
  # if (z0[i]>0 & z0[i]<1) { z0[i] = 1 }
}

# Transform into new-grid
newz0  <- matrix(z0, nrow = length(newmask$x), ncol = length(newmask$y))
newlon <- matrix(x0, nrow = length(newmask$x), ncol = length(newmask$y), byrow = F)
newlat <- matrix(y0, nrow = length(newmask$x), ncol = length(newmask$y), byrow = T)

image.plot(lon, lat, mask, main = 'original mask', xlab = '', ylab = '')
image.plot(newlon, newlat,newmask[[3]], main = 'pre-newmask', xlab = '', ylab = '')
image.plot(newlon, newlat, newz0, main = 'new mask', xlab = '', ylab = '')

write.table(newz0,  file = paste0(outpath, 'mask_grid.csv'), row.names = F, col.names = F, sep = ';')
write.table(newlon, file = paste0(outpath, 'lon_grid.csv'), row.names = F, col.names = F, sep = ';')
write.table(newlat, file = paste0(outpath, 'lat_grid.csv'), row.names = F, col.names = F, sep = ';')
#=============================================================================#
# END OF PROGRAM
#=============================================================================#