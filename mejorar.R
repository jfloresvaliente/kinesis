#=============================================================================#
# Name   : PlotsStats
# Author : Jorge Flores
# Date   : 
# Version:
# Aim    : 
# URL    : 
#=============================================================================#
library(ggplot2)
library(fields)
library(mapdata)
library(raster)
library(mgcv)

dirpath <- 'C:/Users/jflores/Documents/JORGE/colaboradores/Takeshi/'
# xlimmap <- c(-100, -70)    # X limits of plot
# ylimmap <- c(-30, -0)      # Y limits of plot
age     <- 360
# nfiles <- 350
ylim <- c(0,18)
Wweight_lim <- c(0,25)
temp_lim <- c(10,30)
#=============================================================================#
# DO NOT CHANGE ANYTHING FROM HERE, UNLESS YOU KNOW WHAT YOU ARE DOING
#=============================================================================#

#========== REQUIRED FUNCTIONS ==========#
error_bar <- function(x, a = 0.05){
  # x = vector o matrix with data to evaluate, if x is a matrix, each column will be evaluate
  # a = intervalo de confianza a evaluar

  if(!is.null(dim(x))){
    stat <- NULL
    for(i in 1:dim(x)[2]){
      n  <- length(x[,i])
      m  <- mean(x[,i], na.rm = T)
      s  <- sd(x[,i], na.rm = T)
      tt <- -qt(a/2,n-1)
      ee <- sd(x[,i])/sqrt(n)  # standard error. It is different from the standard deviation
      e  <- tt*ee          # error range
      d  <- e/m            # relative error, says that the confidence interval is a percentage of the value
      li <- m-e            # lower limit
      ls <- m+e            # upper limit
      vec <- c(m, li, ls)
      stat <- rbind(stat, vec)
    }
  }else{
    n  <- length(x)
    m  <- mean(x, na.rm = T)
    s  <- sd(x)
    tt <- -qt(a/2,n-1)
    ee <- sd(x)/sqrt(n)  # standard error. It is different from the standard deviation
    e  <- tt*ee          # error range
    d  <- e/m            # relative error, says that the confidence interval is a percentage of the value
    li <- m-e            # lower limit
    ls <- m+e            # upper limit
    stat <- c(m, li, ls)
  }
  stat <- as.data.frame(stat, row.names = c('mean', 'lowerlim', 'upperlim'))
  return(stat)
}
# 
# ReadKinesisOutput <- function(dirpath, nfiles = 350){
#   
#   trajFiles <- list.files(path = dirpath, pattern = 'output', full.names = T, recursive = T)[1:nfiles]
#   
#   df <- NULL
#   for(i in 1:length(trajFiles)){
#     dat <- read.table(file = trajFiles[i], header = F, sep = '')
#     dat$V1 <- dat$V1-360
#     dat$V7 <- rep(i, times = dim(dat)[1])
#     df <- rbind(df, dat)
#     # print(trajFiles[i])
#   }
#   colnames(df) <- c('lon','lat','temp','knob','Wweight','drifter','day')
#   return(df)
# }

#============================== STEP 1 ==============================#
# Create a directory to storage the particle plot and read the outputs
#============================== STEP 1 ==============================#
dir.create(paste0(dirpath, 'snapshots/'), showWarnings = F) 
# df <- ReadKinesisOutput(dirpath = dirpath, nfiles = nfiles) # Read data from output folder
load(paste0(dirpath, 'df.RData'))

#============================== STEP 2 ==============================#
# Discriminate live particles according to a criterion of confidence limit
#============================== STEP 2 ==============================#
FinalDayAll <- subset(x = df, df$age == 360)
Lc_criterion <- error_bar(FinalDayAll$knob)

aliveIndex <- subset(x = FinalDayAll, FinalDayAll$knob > Lc_criterion[2,1])
aliveIndex <- levels(factor(aliveIndex$drifter))

df2 <- subset(df, df$drifter %in% aliveIndex)
FinalDayAlive <- subset(x = df2, df2$day == length(levels(factor(df2$day))))

#============================== STEP 3 ==============================#
# Make snapshots of tracking particles
#============================== STEP 3 ==============================#

# # For all particles
# for(i in 1:nfiles){
#   
#   # Number of figure
#   if(i < 10) number <- paste0('00',i)
#   if(i >= 10 & i <=100) number <- paste0('0',i)
#   if(i > 100) number <- i
#   
#   # Name of figure
#   PNG1 <- paste0(dirpath, 'snapshots/', 'AllParticles', number, '.png')
#   
#   # Subset and plot by day of simulation
#   snapshot <- subset(df, df$day == i)
#   
#   png(file = PNG1, height = 650, width = 650)
#   par(mar = c(1,2,1,2), oma = c(2,1,.5,.5))
#   map('worldHires', add=F, fill=T, col='gray', ylim = ylimmap, xlim = xlimmap)
#   box(lwd = 2)
#   axis(side = 1, at = seq(xlimmap[1], xlimmap[2], 5), labels = seq(xlimmap[1],xlimmap[2], 5),
#        lwd = 2, lwd.ticks = 2, font.axis = 4)
#   axis(side = 2, at = seq(ylimmap[1]+2, ylimmap[2]-2, 5), labels = seq(ylimmap[1]+2, ylimmap[2]-2, 5),
#        lwd = 2, lwd.ticks = 2, font.axis = 4, las = 2)
#   points(x = snapshot[,1], y = snapshot[,2], pch = 19, cex = .1)
#   mtext(text = paste('Day', i), side = 3, adj = 0.05, line = -1, font = 2)
#   grid()
#   dev.off()
#   print(PNG1)
# }
# 
# # For alive particles
# for(i in 1:nfiles){
#   
#   # Number of figure
#   if(i < 10) number <- paste0('00',i)
#   if(i >= 10 & i <=100) number <- paste0('0',i)
#   if(i > 100) number <- i
#   
#   # Name of figure
#   PNG1 <- paste0(dirpath, 'snapshots/', 'AliveParticles', number, '.png')
#   
#   # Subset and plot by day of simulation
#   snapshot <- subset(df2, df2$day == i)
#   
#   png(file = PNG1, height = 650, width = 650)
#   par(mar = c(1,2,1,2), oma = c(2,1,.5,.5))
#   map('worldHires', add=F, fill=T, col='gray', ylim = ylimmap, xlim = xlimmap)
#   box(lwd = 2)
#   axis(side = 1, at = seq(xlimmap[1], xlimmap[2], 5), labels = seq(xlimmap[1],xlimmap[2], 5),
#        lwd = 2, lwd.ticks = 2, font.axis = 4)
#   axis(side = 2, at = seq(ylimmap[1]+2, ylimmap[2]-2, 5), labels = seq(ylimmap[1]+2, ylimmap[2]-2, 5),
#        lwd = 2, lwd.ticks = 2, font.axis = 4, las = 2)
#   points(x = snapshot[,1], y = snapshot[,2], pch = 19, cex = .1)
#   mtext(text = paste('Day', i), side = 3, adj = 0.05, line = -1, font = 2)
#   grid()
#   dev.off()
#   print(PNG1)
# }

#============================== STEP 4 ==============================#
# Make stats
#============================== STEP 4 ==============================#
histxlim <- seq(0,25,.5)
histylim <- c(0,1000)
histlabels <- seq(histxlim[1], histxlim[length(histxlim)],2)

# Histogram of all particles
png(paste0(dirpath, 'histAllParticles.png'), width = 650, height = 650)
par(lwd = 2, mar = c(3.5,4,2,1))
hist(x = FinalDayAll$knob, breaks = histxlim, axes = F, xlab = '', main = '', ylab = '', ylim = histylim)
mtext(side = 1, line = 2, font = 2, text = 'knob')
mtext(side = 2, line = 3, font = 2, text = 'Frequency')
mtext(side = 3, line = 0, font = 2, text = 'All Particles')
axis(2, lwd = 2, lwd.ticks = 2, font.axis=4, las = 2)
axis(1, lwd = 2, lwd.ticks = 2, font.axis=4, histlabels, histlabels)
box(lwd = 2)
dev.off()

# Histogram of alive particles
png(paste0(dirpath, 'histAliveParticles.png'), width = 650, height = 650)
par(lwd = 2, mar = c(3.5,4,2,1))
hist(x = FinalDayAlive$knob, breaks = histxlim, axes = F, xlab = '', main = '', ylab = '', ylim = histylim)
mtext(side = 1, line = 2, font = 2, text = 'knob')
mtext(side = 2, line = 3, font = 2, text = 'Frequency')
mtext(side = 3, line = 0, font = 2, text = 'Alive Particles')
axis(2, lwd = 2, lwd.ticks = 2, font.axis=4, las = 2)
axis(1, lwd = 2, lwd.ticks = 2, font.axis=4, histlabels, histlabels)
box(lwd = 2)
dev.off()

#--------- Max Growth -----------#
maxGrowth <- subset(FinalDayAll, FinalDayAll$knob == max(FinalDayAll$knob))$drifter
maxGrowth <- subset(df, df$drifter == maxGrowth)

#----------Plot Max Growth (all particles)---------#
png(file = paste0(dirpath, 'MaxGrowth.png'), width = 650, height = 650)
par(lwd = 2, mar = c(3.5,3.5,2,3.5))
plot(maxGrowth$knob,type = 'l', xlab = '', ylab = '', lwd = 2, axes = F, ylim = ylim)
mtext(side = 1, line = 2, font = 2, text = 'Days after spawning')
mtext(side = 2, line = 2, font = 2, text = 'knob (cm)')
axis(side = 1, lwd = 2, lwd.ticks = 2, font.axis=4)
axis(side = 2, lwd = 2, lwd.ticks = 2, font.axis=4, las = 2)
box(lwd = 2)
dev.off()

#----------Plot Max Growth (all particles) with Wweight---------#
png(file = paste0(dirpath, 'MaxGrowth_withWweight.png'), width = 650, height = 650)
par(lwd = 2, mar = c(3.5,3.5,2,3.5))
graf1 <- plot(maxGrowth$knob,type = 'l', xlab = '', ylab = '', lwd = 2, axes = F, ylim = ylim)
mtext(side = 1, line = 2, font = 2, text = 'Days after spawning')
mtext(side = 2, line = 2, font = 2, text = 'knob (cm)')
axis(side = 1, lwd = 2, lwd.ticks = 2, font.axis=4)
axis(side = 2, lwd = 2, lwd.ticks = 2, font.axis=4, las = 2)
box(lwd = 2)
par(new = T, lwd = 2)
plot(maxGrowth$Wweight, type = 'l', col = 'red', axes = F, xlab = '', ylab = '', ylim = Wweight_lim)
axis(4, lwd=2,line=0, col='red',  col.axis = 'red', las = 2)
mtext(side = 4, line = 2, font = 2, text = 'Wweight', col = 'red')
dev.off()

#----------Plot Max Growth (all particles) with Temp ---------#
png(file = paste0(dirpath, 'MaxGrowth_withTemp.png'), width = 650, height = 650)
par(lwd = 2, mar = c(3.5,3.5,2,3.5))
graf1 <- plot(maxGrowth$knob,type = 'l', xlab = '', ylab = '', lwd = 2, axes = F, ylim = ylim)
mtext(side = 1, line = 2, font = 2, text = 'Days after spawning')
mtext(side = 2, line = 2, font = 2, text = 'knob (cm)')
axis(side = 1, lwd = 2, lwd.ticks = 2, font.axis=4)
axis(side = 2, lwd = 2, lwd.ticks = 2, font.axis=4, las = 2)
box(lwd = 2)
par(new = T, lwd = 2)
plot(maxGrowth$temp, type = 'l', col = 'red', axes = F, xlab = '', ylab = '', ylim = temp_lim)
axis(4, lwd=2,line=0, col='red',  col.axis = 'red', las = 2)
mtext(side = 4, line = 2, font = 2, text = 'Temperature', col = 'red')
dev.off()

















# survivor <- sum(dat$V4 >= error_bar(x = dat$V4)[1]) * 100 / ini_particles
# surviv <- c(surviv, survivor)
# df <- rbind(df, dat)
# print(trajFiles[i])
# 
# 
# #=========== ASAS =========#
# readDataOutput <- function(dirpath){
#   dir.create(paste0(dirpath, 'trajectories/'), showWarnings = F)
#   trajFiles <- list.files(path = dirpath, pattern = 'output', full.names = T, recursive = T)
#   
#   df <- NULL
#   surviv <- NULL
#   for(i in 1:length(trajFiles)){
#     
#     dat <- read.table(file = trajFiles[i], header = F, sep = '')
#     dat$V1 <- dat$V1-360
#     if (i == 1) ini_particles <- length(dat$V1)
#     dat$day <- rep(i, times = dim(dat)[1])
#     
#     if(i < 10) number <- paste0('00',i)
#     if(i >= 10 & i <=100) number <- paste0('0',i)
#     if(i > 100) number <- i
#     
#     PNG1 <- paste0(dirpath,'trajectories/', '/AllTrajectories',number ,'.png')
#     # #---------- PLOT WITH GGPLOT2 ----------#
#     # graph <- ggplot(data = dat) +
#     #   geom_point(data = dat, aes(x = V1, y = V2), color = 'black',size = .2) +
#     #   borders(fill='grey',colour='grey') +
#     #   labs(x = 'Longitude (W)', y = 'Latitude (S)') +
#     #   coord_fixed(xlim = xlimmap, ylim = ylimmap, ratio = 2/2) +
#     #   geom_text(x = -98, y = -29, label = paste('Day', i), size=10, hjust=0, vjust=0) +
#     #   theme(axis.text.x  = element_text(face='bold', color='black',
#     #                                     size=15, angle=0),
#     #         axis.text.y  = element_text(face='bold', color='black',
#     #                                     size=15, angle=0),
#     #         axis.title.x = element_text(face='bold', color='black',
#     #                                     size=15, angle=0),
#     #         axis.title.y = element_text(face='bold', color='black',
#     #                                     size=15, angle=90),
#     #         legend.text  = element_text(size=15),
#     #         legend.title = element_text(size=15))
#     # if(!is.null(PNG1)) ggsave(filename = PNG1, width = 9, height = 9) else map
#     
#     #---------- PLOT WITH R BASE ----------#
#     png(file = PNG1, height = 650, width = 650)
#     par(mar = c(1,2,1,2), oma = c(2,1,.5,.5))
#     map('worldHires', add=F, fill=T, col='gray', ylim = ylimmap, xlim = xlimmap)
#     box(lwd = 2)
#     axis(side = 1, at = seq(xlimmap[1], xlimmap[2], 5), labels = seq(xlimmap[1],xlimmap[2], 5),
#          lwd = 2, lwd.ticks = 2, font.axis=4)
#     axis(side = 2, at = seq(ylimmap[1]+2, ylimmap[2]-2, 5), labels = seq(ylimmap[1]+2, ylimmap[2]-2, 5),
#          lwd = 2, lwd.ticks = 2, font.axis=4, las = 2)
#     points(x = dat[,1], y = dat[,2], pch = 19, cex = .1)
#     mtext(text = paste('Day', i), side = 3, adj = 0.05, line = -1, font = 2)
#     grid()
#     dev.off()
#     
#     survivor <- sum(dat$V4 >= error_bar(x = dat$V4)[1]) * 100 / ini_particles
#     surviv <- c(surviv, survivor)
#     df <- rbind(df, dat)
#     print(trajFiles[i])
#   }
#   
#   #--------- Calculo retenidos en la costa ---------#
#   path_add <- 'G:/hacer_hoy/ANCHOVY/input/'
#   lon <- as.matrix(read.table(paste0(path_add, 'lon_grid.csv'), header = F))
#   lat <- as.matrix(read.table(paste0(path_add, 'lat_grid.csv'), header = F))
#   coast <- as.matrix(read.table(paste0(path_add, 'CoastLineIndex.csv'), header = F))
#   
#   xyz <- cbind(as.vector(lon), as.vector(lat), as.vector(coast))
#   r <- rasterFromXYZ(xyz = xyz)
#   SP <- rasterToPolygons(clump(r==1), dissolve=TRUE)
#   k <- SP@polygons[[1]]@Polygons[[1]]@coords
#   
#   dat[,8] <- 1:dim(dat)[1]
#   lonlat <- as.matrix(dat[,1:2])
#   colnames(dat) <- c('lon','lat','temp','knob','Wweight','drifter','day','coastalIndex')
#   coastalReteinedIndex <- which(in.out(bnd = k, x = lonlat) == T)
#   coastalReteinedIndex <- subset(dat, dat[,8] %in% coastalReteinedIndex)
#   coastalReteinedIndex <- coastalReteinedIndex$drifter
#   
#   assign('coastalReteinedIndex',coastalReteinedIndex,.GlobalEnv)
#   #--------- Fin de calculo retenidos en la costa ---------#
#   
#   png(filename = paste0(dirpath, 'L-Lc.png'), height = 850, width = 850)
#   plot(surviv, type = 'l', xlab = 'Days of simulation', ylab = '%(L > Lc)', ylim = c(0,100))
#   dev.off()
#   
#   colnames(df) <- c('lon','lat','temp','knob','Wweight','drifter','day')
#   return(df)
# }
# df <- readDataOutput(dirpath = dirpath)
# 
# #-------- TALLAS FINALES ----------#
# FinaleState <- subset(x = df, df$day == length(levels(factor(df$day))))
# Lc_criterion <- error_bar(FinaleState$knob)
# histAlive <- subset(x = FinaleState, FinaleState$knob > Lc_criterion[1])
# 
# aliveIndex <- levels(factor(histAlive$drifter))
# alive <- subset(df, df$drifter %in% aliveIndex)
# 
# # #---------Max Growth -----------#
# # maxGrowth <- subset(FinaleState, FinaleState$knob == max(FinaleState$knob))
# # maxGrowth <- maxGrowth$drifter
# # maxGrowth <- subset(df, df$drifter == maxGrowth)
# 
# #-----Wweight serie----------#
# Wweight_all <- tapply(df$Wweight, list(df$day), mean, na.rm = TRUE)
# Wweight_alive <- tapply(alive$Wweight, list(alive$day), mean, na.rm = TRUE)
# Wweight_max <- tapply(maxGrowth$Wweight, list(maxGrowth$day), mean, na.rm = TRUE)
# 
# ylim = c(0,30)
# Wweight_lim <- c(0,60)
# 
# # #----------Plot Max Growth (all particles)---------#
# # png(file = paste0(dirpath, 'MaxGrowth.png'), width = 650, height = 650)
# # par(lwd = 2, mar = c(3.5,3.5,2,3.5))
# # plot(maxGrowth$knob,type = 'l', xlab = '', ylab = '', lwd = 2, axes = F, ylim = ylim)
# # mtext(side = 1, line = 2, font = 2, text = 'Days after spawning')
# # mtext(side = 2, line = 2, font = 2, text = 'knob (cm)')
# # axis(side = 1, lwd = 2, lwd.ticks = 2, font.axis=4)
# # axis(side = 2, lwd = 2, lwd.ticks = 2, font.axis=4, las = 2)
# # box(lwd = 2)
# # dev.off()
# # 
# # #----------Plot Max Growth (all particles) with Wweight---------#
# # png(file = paste0(dirpath, 'MaxGrowth_withWweight.png'), width = 650, height = 650)
# # par(lwd = 2, mar = c(3.5,3.5,2,3.5))
# # graf1 <- plot(maxGrowth$knob,type = 'l', xlab = '', ylab = '', lwd = 2, axes = F, ylim = ylim)
# # mtext(side = 1, line = 2, font = 2, text = 'Days after spawning')
# # mtext(side = 2, line = 2, font = 2, text = 'knob (cm)')
# # axis(side = 1, lwd = 2, lwd.ticks = 2, font.axis=4)
# # axis(side = 2, lwd = 2, lwd.ticks = 2, font.axis=4, las = 2)
# # box(lwd = 2)
# # par(new = T, lwd = 2)
# # plot(Wweight_max, type = 'l', col = 'red', axes = F, xlab = '', ylab = '', ylim = Wweight_lim)
# # axis(4, lwd=2,line=0, col='red',  col.axis = 'red', las = 2)
# # mtext(side = 4, line = 2, font = 2, text = 'Wweight', col = 'red')
# # dev.off()
# 
# #----------Plot Mean Growth (all particles)---------#
# meanGrowth <- tapply(df$knob, list(df$day), mean, na.rm = TRUE)
# png(file = paste0(dirpath, 'meanGrowth.png'), width = 650, height = 650)
# par(lwd = 2, mar = c(3.5,3.5,2,3.5))
# graf1 = plot(meanGrowth, type = 'l', xlab = '', ylab = '', axes = F, lwd = 2, ylim = ylim)
# mtext(side = 1, line = 2, font = 2, text = 'Days after spawning')
# mtext(side = 2, line = 2, font = 2, text = 'knob (cm)')
# axis(side = 1, lwd = 2, lwd.ticks = 2, font.axis=4)
# axis(side = 2, lwd = 2, lwd.ticks = 2, font.axis=4, las = 2)
# box(lwd = 2)
# dev.off()
# 
# #----------Plot Mean Growth (all particles) with Wweight---------#
# png(file = paste0(dirpath, 'meanGrowth_withWweight.png'), width = 650, height = 650)
# par(lwd = 2, mar = c(3.5,3.5,2,3.5))
# graf2 = plot(meanGrowth, type = 'l', xlab = '', ylab = '', axes = F, lwd = 2, ylim = ylim)
# mtext(side = 1, line = 2, font = 2, text = 'Days after spawning')
# mtext(side = 2, line = 2, font = 2, text = 'knob (cm)')
# axis(side = 1, lwd = 2, lwd.ticks = 2, font.axis=4)
# axis(side = 2, lwd = 2, lwd.ticks = 2, font.axis=4, las = 2)
# box(lwd = 2)
# par(new = T, lwd = 2)
# plot(Wweight_all, type = 'l', col = 'red', axes = F, xlab = '', ylab = '', ylim = Wweight_lim)
# axis(4, lwd=2,line=0, col='red',  col.axis = 'red', las = 2)
# mtext(side = 4, line = 2, font = 2, text = 'Wweight', col = 'red')
# dev.off()
# 
# #----------Plot Mean Growth (alive particles)---------#
# meanGrowthAlive <- tapply(alive$knob, list(alive$day), mean, na.rm = TRUE)
# png(file = paste0(dirpath, 'meanGrowthAlive.png'), width = 650, height = 650)
# par(lwd = 2, mar = c(3.5,3.5,2,3.5))
# plot(meanGrowthAlive, type = 'l', xlab = '', ylab = '', lwd = 2, axes = F, ylim = ylim)
# mtext(side = 1, line = 2, font = 2, text = 'Days after spawning')
# mtext(side = 2, line = 2, font = 2, text = 'knob (cm)')
# axis(side = 1, lwd = 2, lwd.ticks = 2, font.axis=4)
# axis(side = 2, lwd = 2, lwd.ticks = 2, font.axis=4, las = 2)
# box(lwd = 2)
# dev.off()
# 
# #----------Plot Mean Growth (alive particles) with Wweight---------#
# png(file = paste0(dirpath, 'meanGrowthAlive_withWweight.png'), width = 650, height = 650)
# par(lwd = 2, mar = c(3.5,3.5,2,3.5))
# graf3 <- plot(meanGrowthAlive, type = 'l', xlab = '', ylab = '', lwd = 2, axes = F, ylim = ylim)
# mtext(side = 1, line = 2, font = 2, text = 'Days after spawning')
# mtext(side = 2, line = 2, font = 2, text = 'knob (cm)')
# axis(side = 1, lwd = 2, lwd.ticks = 2, font.axis=4)
# axis(side = 2, lwd = 2, lwd.ticks = 2, font.axis=4, las = 2)
# box(lwd = 2)
# par(new = T, lwd = 2)
# plot(Wweight_alive, type = 'l', col = 'red', axes = F, xlab = '', ylab = '', ylim = Wweight_lim)
# axis(4, lwd=2,line=0, col='red',  col.axis = 'red', las = 2)
# mtext(side = 4, line = 2, font = 2, text = 'Wweight', col = 'red')
# dev.off()
# 
# #----- PLOT MAP DE ALIVE PARTICLES -----#
# for(i in 1:length(levels(factor(alive$day)))){
#   
#   df2 <- subset(alive, alive$day == i)
#   
#   if(i < 10) number <- paste0('00',i)
#   if(i >= 10 & i <=100) number <- paste0('0',i)
#   if(i > 100) number <- i
#   
#   PNG2 <- paste0(dirpath,'trajectories/', '/AliveTrajectories', number,'.png')
#   # #---------- PLOT WITH GGPLOT2 ----------#
#   # graph <- ggplot(data = df2) +
#   #   geom_point(data = df2, aes(x = lon, y = lat), color = 'black',size = .2) +
#   #   borders(fill='grey',colour='grey') +
#   #   labs(x = 'Longitude (W)', y = 'Latitude (S)') +
#   #   coord_fixed(xlim = xlimmap, ylim = ylimmap, ratio = 2/2) +
#   #   geom_text(x = -98, y = -29, label = paste('Day', i), size=10, hjust=0, vjust=0) +
#   #   theme(axis.text.x  = element_text(face='bold', color='black',
#   #                                     size=15, angle=0),
#   #         axis.text.y  = element_text(face='bold', color='black',
#   #                                     size=15, angle=0),
#   #         axis.title.x = element_text(face='bold', color='black',
#   #                                     size=15, angle=0),
#   #         axis.title.y = element_text(face='bold', color='black',
#   #                                     size=15, angle=90),
#   #         legend.text  = element_text(size=15),
#   #         legend.title = element_text(size=15))
#   # if(!is.null(PNG2)) ggsave(filename = PNG2, width = 9, height = 9) else map
#   
#   #---------- PLOT WITH R BASE ----------#
#   png(file = PNG2, height = 650, width = 650)
#   par(mar = c(1,2,1,2), oma = c(2,1,.5,.5))
#   map('worldHires', add=F, fill=T, col='gray', ylim = ylimmap, xlim = xlimmap)
#   box(lwd = 2)
#   axis(side = 1, at = seq(xlimmap[1], xlimmap[2], 5), labels = seq(xlimmap[1], xlimmap[2], 5), lwd = 2, lwd.ticks = 2, font.axis=4)
#   axis(side = 2, at = seq(ylimmap[1]+2, ylimmap[2]-2, 5), labels = seq(ylimmap[1]+2, ylimmap[2]-2, 5),
#        lwd = 2, lwd.ticks = 2, font.axis=4, las = 2)
#   points(x = df2[,1], y = df2[,2], pch = 19, cex = .1)
#   mtext(text = paste('Day', i), side = 3, adj = 0.05, line = -1, font = 2)
#   grid()
#   dev.off()
#   print(PNG2)
# }
# 
# #--------- Plot histogram for final length -----------#
# histxlim <- seq(0,25,.5)
# histylim <- c(0,700)
# histlabels <- seq(histxlim[1], histxlim[length(histxlim)],2)
# 
# png(paste0(dirpath, 'histAll.png'), width = 650, height = 650)
# par(lwd = 2, mar = c(3.5,4,2,1))
# hist(x = FinaleState$knob, breaks = histxlim, axes = F, xlab = '', main = '', ylab = '', ylim = histylim)
# mtext(side = 1, line = 2, font = 2, text = 'knob')
# mtext(side = 2, line = 3, font = 2, text = 'Frequency')
# mtext(side = 3, line = 0, font = 2, text = 'All Particles')
# axis(2, lwd = 2, lwd.ticks = 2, font.axis=4, las = 2)
# axis(1, lwd = 2, lwd.ticks = 2, font.axis=4, histlabels, histlabels)
# box(lwd = 2)
# dev.off()
# 
# png(paste0(dirpath, 'histAlive.png'), width = 650, height = 650)
# par(lwd = 2, mar = c(3.5,4,2,1))
# b = hist(x = histAlive$knob, breaks = histxlim, axes = F, xlab = '', main = '', ylab = '', lwd = 2, ylim = histylim)
# b = (100 * sum(b$counts)/4000)
# mtext(side = 1, line = 2, font = 2, text = 'knob')
# mtext(side = 2, line = 3, font = 2, text = 'Frequency')
# mtext(side = 3, line = 0, font = 2, text = 'Alive Particles')
# mtext(side = 3, line = -3, font = 2, text = paste('% Survival Particles', round(b, digits = 2)), adj = 0.95)
# axis(2, lwd = 2, lwd.ticks = 2, font.axis=4, las = 2)
# axis(1, lwd = 2, lwd.ticks = 2, font.axis=4, histlabels, histlabels)
# box(lwd = 2)
# dev.off()
# 
# #--------  PLOT TRAJECTORIES --------#
# # Domain (by default) for plots, you can change this geographical domain
# lonmin  <- -100
# lonmax  <- -70
# latmin  <- -0
# latmax  <- -20
# xlimmap <- c(-100, -70)    # X limits of plot
# ylimmap <- c(-30, -0)      # Y limits of plot
# zlimmap <- c(0,18)
# color.limits <- c(0,10)
# 
# #----PLOT ALL TRAJECTORIES----#
# PNG3 <- paste0(dirpath, 'allTrajectories.png')
# # mymap <- get_map(location = c(lon = (lonmin + lonmax) / 2, lat = (latmin + latmax) / 2),
# #                  zoom = 4, maptype = 'satellite', color='bw')
# # map   <- ggmap(mymap)
# map <- ggplot(data = df)
# map <- map +
#   geom_path(data = df, aes(group = drifter, x = lon, y = lat, colour = knob), size = .1) +
#   scale_colour_gradientn(colours = tim.colors(n = 64, alpha = 1), expression(knob), limits = zlimmap) +
#   labs(x = 'Longitude (W)', y = 'Latitude (S)') +
#   borders(fill='grey',colour='grey') +
#   coord_fixed(xlim = xlimmap, ylim = ylimmap, ratio = 2/2) +
#   theme(axis.text.x  = element_text(face='bold', color='black',
#                                     size=15, angle=0),
#         axis.text.y  = element_text(face='bold', color='black',
#                                     size=15, angle=0),
#         axis.title.x = element_text(face='bold', color='black',
#                                     size=15, angle=0),
#         axis.title.y = element_text(face='bold', color='black',
#                                     size=15, angle=90),
#         legend.text  = element_text(size=15),
#         legend.title = element_text(size=15))
# if(!is.null(PNG3)) ggsave(filename = PNG3, width = 9, height = 9) else map
# print(PNG3); flush.console()
# 
# #----PLOT ONLY RETEINED TRAJECTORIES----#
# PNG4 <- paste0(dirpath, 'reteinedTrajectories.png')
# # mymap <- get_map(location = c(lon = (lonmin + lonmax) / 2, lat = (latmin + latmax) / 2),
# #                  zoom = 4, maptype = 'satellite', color='bw')
# map   <- ggplot(data = alive)
# map <- map +
#   geom_path(data = alive, aes(group = drifter, x = lon, y = lat, colour = knob), size = .1) +
#   scale_colour_gradientn(colours = tim.colors(n = 64, alpha = 1), expression(knob), limits = zlimmap) +
#   labs(x = 'Longitude (W)', y = 'Latitude (S)') +
#   borders(fill='grey',colour='grey') +
#   coord_fixed(xlim = xlimmap, ylim = ylimmap, ratio = 2/2) +
#   theme(axis.text.x  = element_text(face='bold', color='black',
#                                     size=15, angle=0),
#         axis.text.y  = element_text(face='bold', color='black',
#                                     size=15, angle=0),
#         axis.title.x = element_text(face='bold', color='black',
#                                     size=15, angle=0),
#         axis.title.y = element_text(face='bold', color='black',
#                                     size=15, angle=90),
#         legend.text  = element_text(size=15),
#         legend.title = element_text(size=15))
# if(!is.null(PNG4)) ggsave(filename = PNG4, width = 9, height = 9) else map
# print(PNG4); flush.console()
# 
# #----PLOT ONLY COASTAL RETEINED TRAJECTORIES----#
# coastalReteined <- subset(df, df$drifter %in% coastalReteinedIndex)
# PNG5 <- paste0(dirpath, 'coastalReteinedTrajectories.png')
# # mymap <- get_map(location = c(lon = (lonmin + lonmax) / 2, lat = (latmin + latmax) / 2),
# #                  zoom = 4, maptype = 'satellite', color='bw')
# map   <- ggplot(data = coastalReteined)
# map <- map +
#   geom_path(data = coastalReteined, aes(group = drifter, x = lon, y = lat, colour = knob), size = .1) +
#   scale_colour_gradientn(colours = tim.colors(n = 64, alpha = 1), expression(knob), limits = zlimmap) +
#   labs(x = 'Longitude (W)', y = 'Latitude (S)') +
#   borders(fill='grey',colour='grey') +
#   annotate('text', x = -75, y = -5, label = paste(length(coastalReteinedIndex), 'retenidas en la costa'))+
#   coord_fixed(xlim = xlimmap, ylim = ylimmap, ratio = 2/2) +
#   theme(axis.text.x  = element_text(face='bold', color='black',
#                                     size=15, angle=0),
#         axis.text.y  = element_text(face='bold', color='black',
#                                     size=15, angle=0),
#         axis.title.x = element_text(face='bold', color='black',
#                                     size=15, angle=0),
#         axis.title.y = element_text(face='bold', color='black',
#                                     size=15, angle=90),
#         legend.text  = element_text(size=15),
#         legend.title = element_text(size=15))
# if(!is.null(PNG5)) ggsave(filename = PNG5, width = 9, height = 9) else map
# print(PNG5); flush.console()
# #---- FIN PLOT ONLY COASTAL RETEINED TRAJECTORIES----#
# #=============================================================================#
# # END OF PROGRAM
# #=============================================================================#
