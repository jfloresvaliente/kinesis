library(fields)
source('/run/media/marissela/JORGE_F/kinesis_peru/scripts/kinesis_get_av_SL.R')
source('/run/media/marissela/JORGE_F/kinesis_peru/scripts/kinesis_get_maximal_growth.R')

dirpath <- '/home/marissela/Documents/KINESIS/MODELS/out7/'

## PLOT MEAN GROWTH CURVE
mean_growth <- kinesis_get_av_SL(dirpath,years = c(2001:2002), days = 365)
mean_growth <- mean_growth[[1]]

png(paste0(dirpath,'mean_growth.png'), width = 850, height = 850, res = 120)
plot(mean_growth[,3], type = 'l', xlab = 'Days', ylab = 'Mean growth (cm)')
dev.off()

## PLOT MAXIMAL GROWTH CURVE
max_growth <- kinesis_get_maximal_growth(dirpath)

png(paste0(dirpath,'maximal_growth.png'), width = 850, height = 850, res = 120)
plot(max_growth[,4], type = 'l', xlab = 'Days', ylab = 'Maximal growth (cm)')
dev.off()

## PLOT PARTICLES TRAJECTORIES
## Set coastline
mapa <- map(database = 'world', type = 'n')
files <- list.files(dirpath, pattern = 'output', full.names = T, recursive = T)

for(i in 1:length(files)){
  dat <- read.table(files[i])
  png(paste0(dirpath, 'step_',i,'.png'), width = 850, height = 850, res = 120)
  plot(dat[,1]-360, dat[,2], pch = 19, col='blue', cex = 0.2,
       xlim = c(-100,-70), ylim = c(-40,15), xlab = 'LON', ylab = 'LAT')
  lines(mapa$x,mapa$y)
  print(files[i])
  dev.off()
}


