#=============================================================================#
# Name   : 
# Author : Jorge Flores
# Date   : 
# Version:
# Aim    : 
# URL    : 
#=============================================================================#
library(ncdf4)
library(fields)
library(sp)

nc <- nc_open('G:/ROMS_SIMULATIONS/ROMS6B_VINCENT_SIMULATION/roms6b_avg.Y1958.M1.rl1b.nc')
dirpath <- 'G:/ROMS_SIMULATIONS/ROMS6B_VINCENT_SIMULATION/'

mask <- ncvar_get(nc, 'mask_rho')

ZOO  <- array(data = NA, dim = c(dim(mask), 612))
MESO <- array(data = NA, dim = c(dim(mask), 612))
DCHL  <- array(data = NA, dim = c(dim(mask), 612))

iter <- 1
for(i in 1958:2008){
  for(j in 1:12){
    nc_file <- paste0(paste0(dirpath,'roms6b_avg.Y', i, '.M', j, '.rl1b.nc'))
    nc <- nc_open(nc_file)
    
    vari1 <- ncvar_get(nc, 'ZOO') [,,32,]
    vari2 <- ncvar_get(nc, 'MESO')[,,32,]
    vari3 <- ncvar_get(nc, 'DCHL')[,,32,]
    
    ZOO[,,iter]  <- apply(vari1, c(1,2), mean)
    MESO[,,iter] <- apply(vari2, c(1,2), mean)
    DCHL[,,iter]  <- apply(vari3, c(1,2), mean)
    
    iter <- iter + 1
    print(nc_file)
  }
}

# Saving on object in RData format
save(ZOO,  file = paste0(dirpath,"ZOO.RData"))
save(MESO, file = paste0(dirpath,"MESO.RData"))
save(DCHL, file = paste0(dirpath,"DCHL.RData"))

rm(list = c('ZOO', 'MESO', 'DCHL', 'vari1', 'vari2', 'vari3'))
#=============================================================================#
# END OF PROGRAM
#=============================================================================#