#=============================================================================#
# Name   : getline_rowcol_index
# Author : Jorge Flores
# Date   : 
# Version:
# Aim    : 
# URL    : 
#=============================================================================#
getline_rowcol_index <- function(
  nc_grid,
  
  lon1 = NULL,
  lat1 = NULL,
  
  lon2 = NULL,
  lat2 = NULL){
  
  library(ncdf4)
  library(fields)
  
  nc <- nc_open(nc_grid)
  
  x <- ncvar_get(nc, 'lon_rho')
  y <- ncvar_get(nc, 'lat_rho')
  z <- ncvar_get(nc, 'mask_rho')
  
  assign(x = 'lon', value = x[,1], envir = .GlobalEnv)
  assign(x = 'lat', value = y[1,], envir = .GlobalEnv)
  assign(x = 'mask', value = z, envir = .GlobalEnv)
  
  if(is.null(lon1) | is.null(lat1) | is.null(lon2) | is.null(lat2)){
    print('You need 2 latitudes and 2 longitudes, choose two points on the map.')
    x11()
    image.plot(x,y,z, xlab = 'Longitude', ylab = 'Latitude')
    pts <- locator(n = 2, type = 'p')
    pts <- cbind(pts$x, pts$y)
    pts <- pts[rev(order(pts[,1])),]
  }else{
    x11()
    image.plot(x,y,z, xlab = 'Longitude', ylab = 'Latitude')
    
    pts <- matrix(data = c(lon1, lat1, lon2, lat2), nrow = 2, ncol = 2, byrow = T)
    pts <- pts[rev(order(pts[,1])),]
  }
  colnames(pts) <- c('lon', 'lat')
  assign(x = 'pts', value = pts, envir = .GlobalEnv)
  
  mod <- lm(pts[,2] ~ pts[,1])
  coefi  <- coef(mod)
  
  newX <- seq(pts[1,1], pts[2,1], by = -1/100)
  newY <- coefi[1] + (coefi[2] * newX)
  
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
  
  colnames(rowcol) <- c('row_index', 'col_index')
  assign(x = 'LineRowColIndex', value = rowcol, envir = .GlobalEnv)
}
#=============================================================================#
# END OF PROGRAM
#=============================================================================#