#=============================================================================#
# Rutina para obtener promedios ENSO YEARS
#=============================================================================#
dirpath <- 'F:/COLLABORATORS/KINESIS/' # Ruta donde estan almacenados los datos

# Get ENSO periods
ENSO <- read.csv(paste0(dirpath, 'ONI_sort.csv'), header = T, sep = ';')
ENSO$category <- as.character(ENSO$category)

ini_period <- matrix(data = NA, nrow = 1, ncol = 2)
end_period <- NULL
cates <- ENSO$category[1]

for(i in 2:dim(ENSO)[1]){
  
  if(i == 2) ini_period[1,] <- c(ENSO$year[1], ENSO$month[1])
  
  if(ENSO[i,5] != ENSO$category[i-1]){
    end <- c(ENSO$year[i-1], ENSO$month[i-1])
    end_period <- rbind(end_period, end)
    
    new_ini <- c(ENSO$year[i], ENSO$month[i])
    ini_period <- rbind(ini_period, new_ini)
    
    cates <- c(cates, ENSO[i,5])
  }
  if(i == dim(ENSO)[1]) end_period <- rbind(end_period, c(ENSO$year[i], ENSO$month[i]))
}

ENSO_periods <- cbind(ini_period, end_period, cates)
colnames(ENSO_periods) <- c('ini_year', 'ini_month', 'end_year', 'end_month', 'category')
write.table(x = ENSO_periods, file = paste0(dirpath, 'ENSO_periods.csv'), sep = ';', row.names = F)
