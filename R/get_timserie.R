#=============================================================================#
# Name   : get_timserie
# Author : Jorge Flores
# Date   : 
# Version:
# Aim    :
# URL    : 
#=============================================================================#
dirpath  <- 'G:/hacer_hoy/anchovy/input/interanual/'
fileMask <- paste0(dirpath, 'CoastLine_toTimeSerie.csv')
mask <- as.matrix(read.table(file = fileMask, header = F, sep = ''))
mask[mask == 0] <- NA

dirpath <- 'G:/zlev20/'
vari      <- c('c')

varfiles <- list.files(path = dirpath, pattern = paste0(vari,'.*\\.txt'), full.names = F)
dates <- varfiles
dates <- gsub(pattern = '.txt', replacement = '', x = dates)
dates <- gsub(pattern = vari, replacement = '', x = dates)

days_all <- NULL
for(i in 1:length(dates)){
  m <- substr(x = dates[i], start = 1, stop = 4)
  n <- substr(x = dates[i], start = 5, stop = 6)
  if(as.numeric(n) < 10){
    n2 <- as.numeric(gsub(x = n,pattern = '0', replacement = ''))
  }else{
    n2 <- as.numeric(n)
  }
  p <- substr(x = dates[i], start = 7, stop = 8)
  days <- c(paste0(m,'-',n,'-',p), m, n2)
  days_all <- rbind(days_all, days)
}
# days_all <- as.Date(days_all[,1])

var_serie <- numeric(length = length(varfiles))
for(i in 1:length(varfiles)){
  # if (vari == 'u' | vari == 'v') {
  #   ufiles <- list.files(path = dirpath, pattern = paste0('u','.*\\.txt'), full.names = F)
  #   vfiles <- list.files(path = dirpath, pattern = paste0('v','.*\\.txt'), full.names = F)
  #   
  #   uvar <- read.table(file = paste0(dirpath, ufiles[i]), header = F, sep = '')
  #   uvar <- matrix(data = uvar[,3], nrow = 181, ncol = 331, byrow = F) # 331,181
  #   
  #   vvar <- read.table(file = paste0(dirpath, vfiles[i]), header = F, sep = '')
  #   vvar <- matrix(data = vvar[,3], nrow = 181, ncol = 331, byrow = F) # 331,181
  #   
  #   var_serie[i] <- mean(sqrt((uvar * mask)^2 + (vvar * mask)^2), na.rm = T)
  #   print(paste(vfiles[i], ufiles[i]))
  # }else{
    dat <- read.table(file = paste0(dirpath, varfiles[i]), header = F, sep = '')
    VAR <- matrix(data = dat[,3], nrow = 181, ncol = 331, byrow = F) # 331,181 
    var_serie[i] <- mean(VAR * mask, na.rm = T)
    print(varfiles[i])
  # }
}

years <- seq(from = as.Date("1960-01-01"), by = '5 years', length.out = 10)
# if (vari == 'u' | vari == 'v'){
#   vari <- 'uv'
# }
png(filename = paste0('C:/Users/ASUS/Desktop/', vari, '_serie.png'), width = 1250, height = 650, res = 120)
plot(as.Date(days_all[,1]), var_serie, type = 'l', ylab = vari, axes = T, col = 'red', xlab = '')
abline(v = years, lty = 2, lwd = .2)
if (vari == 'u' | vari == 'v'){
abline(h = 0)
}
dev.off()

timeserie <- cbind(as.character(days_all[,1]), var_serie, days_all[,2:3])
write.table(x = timeserie, file =  paste0('C:/Users/ASUS/Desktop/', vari, '_serie.csv'), row.names = F, col.names = F)

x11()
#=============================================================================#
# END OF PROGRAM
#=============================================================================#