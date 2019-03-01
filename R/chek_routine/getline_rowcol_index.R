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
  lat2 = NULL)
  {
  
  library(ncdf4)
  library(fields)
  
  nc <- nc_open(nc_grid)
  
  x <- ncvar_get(nc, 'lon_rho')
  y <- ncvar_get(nc, 'lat_rho')
  z <- ncvar_get(nc, 'mask_rho')
  
  assign(x = 'lon' , value = x, envir = .GlobalEnv)
  assign(x = 'lat' , value = y, envir = .GlobalEnv)
  assign(x = 'mask', value = z, envir = .GlobalEnv)
  
  if(is.null(lon1) | is.null(lat1) | is.null(lon2) | is.null(lat2)){
    print('You need 2 latitudes and 2 longitudes, choose two points on the map:')
    x11()
    image.plot(x,y,z, xlab = 'Longitude', ylab = 'Latitude')
    pts <- locator(n = 2, type = 'p')
    pts <- cbind(pts$x, pts$y)
    pts <- pts[rev(order(pts[,1])),]
    
    colnames(pts) <- c('lon', 'lat')
    assign(x = 'pts', value = pts, envir = .GlobalEnv)
    
    mod <- lm(pts[,2] ~ pts[,1])
    coefi  <- coef(mod)
    
    newX <- seq(pts[1,1], pts[2,1], by = -1/3000)
    newY <- coefi[1] + (coefi[2] * newX)
    
    lines(newX, newY)
  }else{
    x11()
    image.plot(x,y,z, xlab = 'Longitude', ylab = 'Latitude')
    pts <- matrix(data = c(lon1, lat1, lon2, lat2), nrow = 2, ncol = 2, byrow = T)
    pts <- pts[rev(order(pts[,1])),]
    colnames(pts) <- c('lon', 'lat')
    assign(x = 'pts', value = pts, envir = .GlobalEnv)
    mod <- lm(pts[,2] ~ pts[,1])
    coefi  <- coef(mod)
    newX <- seq(pts[1,1], pts[2,1], by = -1/3000)
    newY <- coefi[1] + (coefi[2] * newX)
    
    lines(newX, newY)
  }
  
  rowcol <- NULL
  for(i in 1:length(newX)){
    
    x1 <- abs(x - newX[i])
    y1 <- abs(y - newY[i])
    
    xy1 <- x1 + y1
    n <- which(xy1 == min(xy1), arr.ind = T)
    rowcol <- rbind(rowcol, n[1,])
  }
  
  
  rowcol <- rowcol[!duplicated(rowcol), ]
  colnames(rowcol) <- c('row_index', 'col_index')
  assign(x = 'LineIndex', value = rowcol, envir = .GlobalEnv)
  
  for(i in 1:dim(rowcol)[1]){
    a <- rowcol[i,1]
    b <- rowcol[i,2]
    z[a,b] <- NA
  }
  x11()
  image.plot(x,y,z, xlab = 'Longitude', ylab = 'Latitude')
  # lines(newX, newY)
}
#=============================================================================#
# END OF PROGRAM
#=============================================================================#