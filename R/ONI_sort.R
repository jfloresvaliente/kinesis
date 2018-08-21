#=============================================================================#
# Name   : 
# Author : Jorge Flores
# Date   : 
# Version:
# Aim    : 
# URL    : 
#=============================================================================#
dirpath <- 'F:/COLLABORATORS/KINESIS/' # Ruta donde estan almacenados los datos

dat1 <- read.csv(paste0(dirpath, 'ONI.csv'), sep = ';'); dat1 <- as.matrix(dat1[,2:dim(dat1)[2]])
dat2 <- read.csv(paste0(dirpath, 'ONI_categories.csv'), sep = ';'); dat2 <- as.matrix(dat2[,2:dim(dat2)[2]])
year_ini <- 1950

ONI <- NULL
for(i in 1:dim(dat1)[1]){
  for(j in 1:dim(dat1)[2]){
    A <- dat1[i,j]
    B <- dat2[i,j]
    ONI <- rbind(ONI, c(year_ini, j, colnames(dat1)[j], A, B))
  }
  year_ini <- year_ini + 1
}
ONI <- ONI[complete.cases(ONI), ] # Filtro para eliminar NA
colnames(ONI) <- c('year', 'month', 'trim', 'ONI', 'category')

write.table(x = ONI, file = paste0(dirpath, 'ONI_sort.csv'), col.names = T, row.names = F, sep = ';')
#=============================================================================#
# END OF PROGRAM
#=============================================================================#