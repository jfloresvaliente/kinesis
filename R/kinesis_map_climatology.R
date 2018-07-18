#===============================================================================
# Name   : kinesis_map_climatology
# Author : Jorge Flores
# Date   : 
# Version:
# Aim 1  : make climatology maps for Kinesis model input
# Aim 2  : save image plot in a specific directory
# URL    : 
#===============================================================================
kinesis_map_climatology <- function(dirpath,
                                    var  = 't',
                                    xlim = c(-85,-70),
                                    ylim = c(-20,2),
                                    zlim = c(13,28),
                                    year_in = 1995,
                                    year_on = 1995){
  library(fields)
  library(maps)
  library(mapdata)
  
  mon <- c('01','02','03','04','05','06','07','08','09','10','11','12')
  
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
      val <- dat[,3]
      array_month <- cbind(array_month,val)
    }
    
    mean_month <- apply(array_month, c(1), mean, na.rm = T)
    array_mean_month <- cbind(array_mean_month,mean_month)
  }

  mask <- as.matrix(read.table(paste0(dirpath,'mask_grid.csv'), header = F))
  lon  <- as.matrix(read.table(paste0(dirpath,'lon_grid.csv'), header = F))
  lat  <- as.matrix(read.table(paste0(dirpath,'lat_grid.csv'), header = F))
  mask[mask==0] <- NA
  
  ## PLOT MAP AND SET COASTLINE
  fig_name <- paste0(dirpath,'climatology_',year_in,'_',year_on,'_',var,'.png')
  png(fig_name, width = 1350,height = 950, res = 120)
  
  par(mfrow = c(3, 4),        # 2x2 layout
      oma = c(2, 2, 1, 0.5),  # two rows of text at the outer left and bottom margin
      mar = c(1, 1, .5, 3.7), # space for one row of text at ticks and to separate plots
      mgp = c(2, .5, 0),      # axis label at 2 rows distance, tick labels at 1 row
      xpd = F,                # allow content to protrude into outer margin (and beyond)
      font = 2)            
  
  for(j in 1:12){
    valgrid <- matrix(array_mean_month[,j], nrow = dim(mask)[1], ncol = dim(mask)[2], byrow = F)
    
    valgrid[valgrid == zlim[2]] = zlim[2] - 0.001
    valgrid[valgrid >  zlim[2]] = zlim[2]
    valgrid[valgrid == zlim[1]] = zlim[1] + 0.001
    valgrid[valgrid <  zlim[1]] = zlim[1]
    
    image.plot(lon,lat,valgrid*mask, zlim = zlim, ylim = ylim, xlim = xlim,
               xlab='',ylab='', axes = F)
    map('worldHires',add=T,fill=T,col='gray')
    legend('bottomleft', legend = paste('Month',j), adj = .2)
    box(lwd = 2)
    if(j == 1 | j == 5 | j == 9) axis(2, las = 2, lwd = 2, font = 2)
    if(j == 9 | j == 10 | j== 11 | j == 12) axis(1, lwd = 2, font = 2)
  }
  dev.off()
  print(paste('Climatological image save in ...', dirpath))
}
#===============================================================================
# END OF PROGRAM
#===============================================================================

dirpath <- 'G:/hacer_hoy/KINESIS_ORIGINAL_SOURCE/anchovy/input/interanual/zlev10/'
vars <- c('t','c','u','v')
for(i in 1:length(vars)){
  years <- 1995:1999
  for(j in years){
    zlim <- c(13,28,0,15,-0.25,0.25,-0.25,0.25)
    zlim <- matrix(data = zlim, nrow = 4, ncol = 2, byrow = T)
    kinesis_map_climatology(dirpath, var = vars[i], zlim = zlim[i,], year_in = j, year_on = j) 
  }
}
