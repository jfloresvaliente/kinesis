#=============================================================================#
# Name   : readDataOutput
# Author : Jorge Flores
# Date   : 
# Version:
# Aim    : 
# URL    : 
#=============================================================================#
readDataOutput <- function(dirpath, max_paticles = 5880, nfiles = 360){
  
  # dirpath      = Directorio donde estan almacenados los outputs de kinesis
  # max_paticles = Numero maximo de particulas liberadas en la simulacion
  # nfiles       = Numero de archivos para leer
  
  df <- array(dim = c(max_paticles * nfiles, 13))
  df <- as.data.frame(df)
  df_up <- seq(from = 1, by = max_paticles, length.out = nfiles)
  df_do <- seq(from = max_paticles, by = max_paticles, length.out = nfiles)
  
  txtfiles <- list.files(path = dirpath, pattern = paste0('output','.*\\.txt'), full.names = T, recursive = T)
  for(i in 1:nfiles){
    
    xscan <- scan(txtfiles[i], quiet = T)
    
    if(length(xscan) == 0) next()
    
    dat <- read.table(file = txtfiles[i], header = F, sep = '')
    dat$V1 <- dat$V1-360
    dat$day <- rep((i-1), times = dim(dat)[1])
    
    if(i == 1){
      edad <- numeric(length = max_paticles)
      dat$edad <- edad
    }else{
      edad <- edad + 1
      edad[dat$V10 == 0.5] <- 0
      dat$edad <- edad
    }
    
    df[df_up[i] : df_do[i], ] <- dat[,1:13]
    print(txtfiles[i])
  }
  colnames(df) <- c('lon','lat','exSST','exPY','exSZ','exMZ','knob','Wweight','PA','TGL','drifter','day','age')
  save(df, file = paste0(dirpath, 'df.RData'))
}
#=============================================================================#
# END OF PROGRAM
#=============================================================================#