#=============================================================================#
# Name   : kinesis_map_climatology
# Author : Jorge Flores
# Date   : 
# Version:
# Aim 1  : make climatology maps for Kinesis model input
# Aim 2  : save image plot in a specific directory
# URL    : 
#=============================================================================#
kinesis_map_climatology <- function(dirpath,
                                    var  = 't',
                                    xlim = c(-85,-70),
                                    ylim = c(-20,2),
                                    zlim = c(13,28),
                                    year_in = 2001,
                                    year_on = 2001){
  library(fields)
  library(maps)
  library(mapdata)
  
  dir.create(path = paste0(dirpath, 'inputmaps/'), showWarnings = F)
  mon <- c('01','02','03','04','05','06','07','08','09','10','11','12')
  
  mask <- as.matrix(read.table(paste0(dirpath,'mask_grid.csv'), header = F, sep = ';'))
  lon  <- as.matrix(read.table(paste0(dirpath,'lon_grid.csv'), header = F, sep = ';'))[,1]
  lat  <- as.matrix(read.table(paste0(dirpath,'lat_grid.csv'), header = F, sep = ';'))[1,]
  mask[mask==0] <- NA 
  
  array_mean_month <- NULL
  for(month in 1:length(mon)){
    
    # GET INPUT FILENAMES FOR EACH MONTH
    month_files <- NULL
    for(year in year_in:year_on){
      pattern <- paste0(var,year,mon[month])
      filenames <- list.files(path = dirpath, pattern = pattern, full.names = T)
      month_files <- c(month_files,filenames)
    }
    
    array_month <- NULL
    for(i in 1:length(month_files)){
      print(month_files[i])
      dat <- read.table(month_files[i], header = F)
      val <- dat[,3]*as.vector(mask)
      array_month <- cbind(array_month,val)
    }
    
    mean_month <- apply(array_month, c(1), mean, na.rm = T)
    array_mean_month <- cbind(array_mean_month,mean_month)
  }

  ## PLOT MAP AND SET COASTLINE
  fig_name <- paste0(dirpath, 'inputmaps/','climatology_',year_in,'_',year_on,'_',var,'.png')
  png(fig_name, width = 1350,height = 950, res = 120)
  
  par(mfrow = c(3, 4),        # 2x2 layout
      oma = c(2, 2, 1, 0.5),  # two rows of text at the outer left and bottom margin
      mar = c(1, 1, .5, 3.7), # space for one row of text at ticks and to separate plots
      mgp = c(2, .5, 0),      # axis label at 2 rows distance, tick labels at 1 row
      xpd = F,                # allow content to protrude into outer margin (and beyond)
      font = 2)            
  
  for(j in 1:12){
    valgrid <- matrix(array_mean_month[,j], nrow = dim(mask)[1], ncol = dim(mask)[2], byrow = F)
    
    valgrid[valgrid == zlim[2]] <- zlim[2] - 0.001
    valgrid[valgrid >  zlim[2]] <- zlim[2]
    valgrid[valgrid == zlim[1]] <- zlim[1] + 0.001
    valgrid[valgrid <  zlim[1]] <- zlim[1]
    
    image.plot(lon,lat,valgrid, zlim = zlim, ylim = ylim, xlim = xlim,
               xlab='',ylab='', axes = F)
    map('worldHires',add=T,fill=T,col='gray')
    legend('bottomleft', legend = paste('Month',j), adj = .2, text.font = 2)
    box(lwd = 2)
    if(j == 1 | j == 5 | j == 9) axis(2, las = 2, lwd = 2, font = 2)
    if(j == 9 | j == 10 | j== 11 | j == 12) axis(1, lwd = 2, font = 2)
  }
  dev.off()
  print(paste0('Climatological image save in ...', dirpath, 'inputmaps/'))
}
#=============================================================================#
# END OF FUNCTION
#=============================================================================#
dirpath <- 'D:/kinesis_escenarios_outputs/escenario_t4c0.5m0.5/input/'
vars <- c('t','c','m','z')
for(i in 1:length(vars)){
  years <- 2001:2001
  for(j in years){
    zlim <- c(15,35, 0,11, 0,5, 0,3)
    zlim <- matrix(data = zlim, nrow = 4, ncol = 2, byrow = T)
    kinesis_map_climatology(dirpath, var = vars[i], zlim = zlim[i,], year_in = j, year_on = j) 
  }
}
rm(list = ls())
#=============================================================================#
# END OF PROGRAM
#=============================================================================#
