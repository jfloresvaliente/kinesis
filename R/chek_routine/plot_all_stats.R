#=============================================================================#
# Name   : plot_all_stats
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

# setwd("~/Documents/case4")
dirpath <- '/home/jtam/Documents/case4/escenario/out/'
# input_path <- 'F:/'
xlimmap <- c(-100, -70)    # X limits of plot
ylimmap <- c(-30, -0)      # Y limits of plot

# xlimmap <- c(-85, -70)    # X limits of plot
# ylimmap <- c(-19, -4.95)      # Y limits of plot

nfiles  <- 360
max_paticles <- 11760

readDataOutput <- function(dirpath){
  dir.create(paste0(dirpath, 'trajectories/'), showWarnings = F)
  dir.create(paste0(dirpath, 'figures/'), showWarnings = F)
  trajFiles <- list.files(path = dirpath, pattern = paste0('output','.*\\.txt'), full.names = T, recursive = T)
  # sstFiles <- list.files(path = dirpath, pattern = paste0('SST','.*\\.txt'), full.names = T, recursive = T)
  # removefiles <- list.files(path = dirpath, pattern = paste0('output','.*\\.dat'), full.names = T, recursive = T)
  # file.remove(removefiles)
  
  df <- array(dim = c(max_paticles * nfiles, 13)); df <- as.data.frame(df)
  df_up <- seq(from = 1, by = max_paticles, length.out = nfiles)
  df_do <- seq(from = max_paticles, by = max_paticles, length.out = nfiles)
  
  # surviv <- NULL
  for(i in 1:nfiles){
    
    xscan <- scan(trajFiles[i], quiet = T)
    
    if(length(xscan) == 0) next()
    
    dat <- read.table(file = trajFiles[i], header = F, sep = '')
    dat$V1 <- dat$V1-360
    dat$day <- rep(i, times = dim(dat)[1])
    
    if(i == 1){
      edad <- numeric(length = max_paticles)
      dat$edad <- edad
    }else{
      edad <- edad + 1
      edad[dat$V10 == 0.5] <- 0
      dat$edad <- edad
    }
    
    # sstdat <- read.table(file = sstFiles[i], header = F, sep = '')
    # Define new lon-lat values for new grid (by = indicates spatial resolution in degrees)
    x0 <- seq(from = -100, to = -70, by = 1/6)
    y0 <- seq(from = -40 , to = 15 , by = 1/6) 
    
    i_name <- i - 1
    if(i_name < 10) number <- paste0('00',i_name)
    if(i_name >= 10 & i_name <=100) number <- paste0('0',i_name)
    if(i_name > 100) number <- i_name
    
    dat2 <- dat
    df[df_up[i]:df_do[i], ] <- dat2[,1:13]
    print(trajFiles[i])
    
    dat <- subset(dat, dat$V10 == 1)
    
    PNG1 <- paste0(dirpath,'trajectories/', '/Particles',number ,'.png')
    # #---------- PLOT WITH GGPLOT2 ----------#
    # graph <- ggplot(data = dat) +
    #   geom_point(data = dat, aes(x = V1, y = V2), color = 'black',size = .2) +
    #   borders(fill='grey',colour='grey') +
    #   labs(x = 'Longitude (W)', y = 'Latitude (S)') +
    #   coord_fixed(xlim = xlimmap, ylim = ylimmap, ratio = 2/2) +
    #   geom_text(x = -98, y = -29, label = paste('Day', (i-1)), size=10, hjust=0, vjust=0) +
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
    # if(!is.null(PNG1)) ggsave(filename = PNG1, width = 9, height = 9) else map
    
    #---------- PLOT WITH R BASE ----------#
    png(file = PNG1, height = 650, width = 650)
    par(mar = c(1,2,1,2), oma = c(2,1,.5,.5))
    map('worldHires', add=F, fill=T, col='gray', ylim = ylimmap, xlim = xlimmap)
    box(lwd = 2)
    axis(side = 1, at = seq(xlimmap[1], xlimmap[2], 5), labels = seq(xlimmap[1],xlimmap[2], 5),
         lwd = 2, lwd.ticks = 2, font.axis=4)
    axis(side = 2, at = seq(ylimmap[1], ylimmap[2], 5), labels = seq(ylimmap[1], ylimmap[2], 5),
         lwd = 2, lwd.ticks = 2, font.axis=4, las = 2)
    points(x = dat[,1], y = dat[,2], pch = 19, cex = .2, col = 'red')
    mtext(text = paste('Day', (i-1)), side = 3, adj = 0.05, line = -1, font = 2)
    mtext(text = paste('# Drifter:', dim(dat)[1]), side = 3, adj = 0.05, line = -3, font = 2)
    grid()
    dev.off()
    
    # #---------- PLOT WITH R BASE + SST MAP----------#
    # PNGsst <- paste0(dirpath,'trajectories/', '/ParticlesSST',number ,'.png')
    # png(file = PNGsst, height = 650, width = 650)
    # par(mar = c(1,2,1,2), oma = c(2,1,.5,.5))
    # image.plot(x0, y0, sstdat, ylim = ylimmap, xlim = xlimmap, zlim = c(10,30), axes = F, xlab ='', ylab = '')
    # map('worldHires', add=T, fill=T, col='gray', ylim = ylimmap, xlim = xlimmap)
    # box(lwd = 2)
    # axis(side = 1, at = seq(xlimmap[1], xlimmap[2], 5), labels = seq(xlimmap[1],xlimmap[2], 5),
    #      lwd = 2, lwd.ticks = 2, font.axis=4)
    # axis(side = 2, at = seq(ylimmap[1], ylimmap[2], 5), labels = seq(ylimmap[1], ylimmap[2], 5),
    #      lwd = 2, lwd.ticks = 2, font.axis=4, las = 2)
    # points(x = dat[,1], y = dat[,2], pch = 19, cex = .2, col = 'black')
    # mtext(text = paste('Day', (i-1)), side = 3, adj = 0.05, line = -1, font = 2)
    # mtext(text = paste('# Drifter:', dim(dat)[1]), side = 3, adj = 0.05, line = -3, font = 2)
    # grid()
    # dev.off()
    
    # ini_particles <- 5880
    # survivor <- sum(dat$knob >= error_bar(x = dat$knob)[1]) * 100 / ini_particles
    # surviv <- c(surviv, survivor)
    
    
  }
  #--------- Calculo retenidos en la costa ---------#
  # lon <- as.matrix(read.table(paste0(input_path, 'lon_grid.csv'), header = F))
  # lat <- as.matrix(read.table(paste0(input_path, 'lat_grid.csv'), header = F))
  # coast <- as.matrix(read.table(paste0(input_path, 'CoastLineIndex.csv'), header = F))
  # 
  # xyz <- cbind(as.vector(lon), as.vector(lat), as.vector(coast))
  # r <- rasterFromXYZ(xyz = xyz)
  # SP <- rasterToPolygons(clump(r==1), dissolve=TRUE)
  # k <- SP@polygons[[1]]@Polygons[[1]]@coords
  # 
  # lonlat <- as.matrix(dat[,1:2])
  # coastalReteinedIndex <- which(in.out(bnd = k, x = lonlat) == T)
  # coastalReteinedIndex <- subset(dat, dat$drifter %in% coastalReteinedIndex)
  # coastalReteinedIndex <- coastalReteinedIndex$drifter
  # 
  # assign('coastalReteinedIndex',coastalReteinedIndex,.GlobalEnv)
  #--------- Fin de calculo retenidos en la costa ---------#
  
  # png(filename = paste0(dirpath, 'L-Lc.png'), height = 850, width = 850)
  # plot(surviv, type = 'l', xlab = 'Days of simulation', ylab = '%(L > Lc)', ylim = c(0,100))
  # dev.off()
  colnames(df) <- c('lon','lat','exSST','exPY','exSZ','exMZ','knob','Wweight','PA','TGL','drifter','day','edad')
  return(df)
}
df <- readDataOutput(dirpath = dirpath)
df <- subset(df, df$TGL == 1)

# VB - (Marzloff et all 2009)
Linf <- 20.5
k    <- 0.86
t0   <- -0.14

t_serie <- 1:(365*10)/365
L0   <- Linf * (1 - exp(-k*(t_serie-t0)))

# x11();plot(t_serie, L0, type = 'l', yaxs = 'i', xaxs = 'i')
# abline(v = 1)

per40 <- L0[365]
per40 <- per40 - (per40 * 40)/100 # Regla del 40%

# # ANALISIS SEGUN EDAD #
# edad_final <- nfiles - 30
# lastEdad <- subset(x = df, df$edad == edad_final)
# histEdadAlive <- subset(x = lastEdad, lastEdad$knob > per40)
# aliveIndexEdad <- levels(factor(histEdadAlive$drifter))
# aliveEdad <- subset(df, df$drifter %in% aliveIndexEdad)
# # edad_knob <- tapply(, index, function)



#-------- TALLAS FINALES ----------#
lastDay <- subset(x = df, df$day == max(as.numeric(levels(factor(df$day)))))
# lastDay <- subset(x = df, df$edad == 310)
histAlive <- subset(x = lastDay, lastDay$knob > per40)

aliveIndex <- levels(factor(histAlive$drifter))
alive <- subset(df, df$drifter %in% aliveIndex)

#---------Max Growth -----------#
maxGrowth <- subset(lastDay, lastDay$knob == max(lastDay$knob))
maxGrowth <- maxGrowth$drifter
maxGrowth <- subset(df, df$drifter == maxGrowth)

#-----Wweight serie----------#
Wweight_all <- tapply(df$Wweight, list(df$day), mean, na.rm = TRUE)
Wweight_alive <- tapply(alive$Wweight, list(alive$day), mean, na.rm = TRUE)
Wweight_max <- tapply(maxGrowth$Wweight, list(maxGrowth$day), mean, na.rm = TRUE)

ylim = c(0,30)
Wweight_lim <- c(0,60)

#----------Plot Max Growth (all particles)---------#
png(file = paste0(dirpath, '/figures/MaxGrowth.png'), width = 650, height = 650)
par(lwd = 2, mar = c(3.5,3.5,2,3.5))
plot(maxGrowth$knob,type = 'l', xlab = '', ylab = '', lwd = 2, axes = F, ylim = ylim)
mtext(side = 1, line = 2, font = 2, text = 'Days after spawning')
mtext(side = 2, line = 2, font = 2, text = 'knob (cm)')
axis(side = 1, lwd = 2, lwd.ticks = 2, font.axis=4)
axis(side = 2, lwd = 2, lwd.ticks = 2, font.axis=4, las = 2)
box(lwd = 2)
dev.off()

#----------Plot Max Growth (all particles) with Wweight---------#
png(file = paste0(dirpath, '/figures/MaxGrowth_withWweight.png'), width = 650, height = 650)
par(lwd = 2, mar = c(3.5,3.5,2,3.5))
graf1 <- plot(maxGrowth$knob,type = 'l', xlab = '', ylab = '', lwd = 2, axes = F, ylim = ylim)
mtext(side = 1, line = 2, font = 2, text = 'Days after spawning')
mtext(side = 2, line = 2, font = 2, text = 'knob (cm)')
axis(side = 1, lwd = 2, lwd.ticks = 2, font.axis=4)
axis(side = 2, lwd = 2, lwd.ticks = 2, font.axis=4, las = 2)
box(lwd = 2)
par(new = T, lwd = 2)
plot(Wweight_max, type = 'l', col = 'red', axes = F, xlab = '', ylab = '', ylim = Wweight_lim)
axis(4, lwd=2,line=0, col='red',  col.axis = 'red', las = 2)
mtext(side = 4, line = 2, font = 2, text = 'Wweight', col = 'red')
dev.off()

#----------Plot Mean Growth (all particles)---------#
meanGrowth <- tapply(df$knob, list(df$day), mean, na.rm = TRUE)
png(file = paste0(dirpath, '/figures/meanGrowth.png'), width = 650, height = 650)
par(lwd = 2, mar = c(3.5,3.5,2,3.5))
graf1 = plot(meanGrowth, type = 'l', xlab = '', ylab = '', axes = F, lwd = 2, ylim = ylim)
mtext(side = 1, line = 2, font = 2, text = 'Days after spawning')
mtext(side = 2, line = 2, font = 2, text = 'knob (cm)')
axis(side = 1, lwd = 2, lwd.ticks = 2, font.axis=4)
axis(side = 2, lwd = 2, lwd.ticks = 2, font.axis=4, las = 2)
box(lwd = 2)
dev.off()

#----------Plot Mean Growth (all particles) with Wweight---------#
png(file = paste0(dirpath, '/figures/meanGrowth_withWweight.png'), width = 650, height = 650)
par(lwd = 2, mar = c(3.5,3.5,2,3.5))
graf2 = plot(meanGrowth, type = 'l', xlab = '', ylab = '', axes = F, lwd = 2, ylim = ylim)
mtext(side = 1, line = 2, font = 2, text = 'Days after spawning')
mtext(side = 2, line = 2, font = 2, text = 'knob (cm)')
axis(side = 1, lwd = 2, lwd.ticks = 2, font.axis=4)
axis(side = 2, lwd = 2, lwd.ticks = 2, font.axis=4, las = 2)
box(lwd = 2)
par(new = T, lwd = 2)
plot(Wweight_all, type = 'l', col = 'red', axes = F, xlab = '', ylab = '', ylim = Wweight_lim)
axis(4, lwd=2,line=0, col='red',  col.axis = 'red', las = 2)
mtext(side = 4, line = 2, font = 2, text = 'Wweight', col = 'red')
dev.off()

#----------Plot Mean Growth (alive particles)---------#
meanGrowthAlive <- tapply(alive$knob, list(alive$day), mean, na.rm = TRUE)
png(file = paste0(dirpath, '/figures/meanGrowthAlive.png'), width = 650, height = 650)
par(lwd = 2, mar = c(3.5,3.5,2,3.5))
plot(meanGrowthAlive, type = 'l', xlab = '', ylab = '', lwd = 2, axes = F, ylim = ylim)
mtext(side = 1, line = 2, font = 2, text = 'Days after spawning')
mtext(side = 2, line = 2, font = 2, text = 'knob (cm)')
axis(side = 1, lwd = 2, lwd.ticks = 2, font.axis=4)
axis(side = 2, lwd = 2, lwd.ticks = 2, font.axis=4, las = 2)
box(lwd = 2)
dev.off()

#----------Plot Mean Growth (alive particles) with Wweight---------#
png(file = paste0(dirpath, '/figures/meanGrowthAlive_withWweight.png'), width = 650, height = 650)
par(lwd = 2, mar = c(3.5,3.5,2,3.5))
graf3 <- plot(meanGrowthAlive, type = 'l', xlab = '', ylab = '', lwd = 2, axes = F, ylim = ylim)
mtext(side = 1, line = 2, font = 2, text = 'Days after spawning')
mtext(side = 2, line = 2, font = 2, text = 'knob (cm)')
axis(side = 1, lwd = 2, lwd.ticks = 2, font.axis=4)
axis(side = 2, lwd = 2, lwd.ticks = 2, font.axis=4, las = 2)
box(lwd = 2)
par(new = T, lwd = 2)
plot(Wweight_alive, type = 'l', col = 'red', axes = F, xlab = '', ylab = '', ylim = Wweight_lim)
axis(4, lwd=2,line=0, col='red',  col.axis = 'red', las = 2)
mtext(side = 4, line = 2, font = 2, text = 'Wweight', col = 'red')
dev.off()



#--------- Plot histogram for final length -----------#
histxlim <- seq(0,25,.5)
histylim <- c(0,700)
histlabels <- seq(histxlim[1], histxlim[length(histxlim)],2)

png(paste0(dirpath, '/figures/histAll.png'), width = 650, height = 650)
par(lwd = 2, mar = c(3.5,4,2,1))
hist(x = lastDay$knob, breaks = histxlim, axes = F, xlab = '', main = '', ylab = '', ylim = histylim)
mtext(side = 1, line = 2, font = 2, text = 'knob')
mtext(side = 2, line = 3, font = 2, text = 'Frequency')
mtext(side = 3, line = 0, font = 2, text = 'All Particles')
axis(2, lwd = 2, lwd.ticks = 2, font.axis=4, las = 2)
axis(1, lwd = 2, lwd.ticks = 2, font.axis=4, histlabels, histlabels)
box(lwd = 2)
dev.off()

png(paste0(dirpath, '/figures/histAlive.png'), width = 650, height = 650)
par(lwd = 2, mar = c(3.5,4,2,1))
b = hist(x = histAlive$knob, breaks = histxlim, axes = F, xlab = '', main = '', ylab = '', lwd = 2, ylim = histylim)
b = (100 * sum(b$counts)/max_paticles)
mtext(side = 1, line = 2, font = 2, text = 'knob')
mtext(side = 2, line = 3, font = 2, text = 'Frequency')
mtext(side = 3, line = 0, font = 2, text = 'Alive Particles')
mtext(side = 3, line = -3, font = 2, text = paste('% Survival Particles', round(b, digits = 2)), adj = 0.95)
axis(2, lwd = 2, lwd.ticks = 2, font.axis=4, las = 2)
axis(1, lwd = 2, lwd.ticks = 2, font.axis=4, histlabels, histlabels)
box(lwd = 2)
dev.off()

#----- PLOT MAP DE ALIVE PARTICLES -----#
for(i in 2:length(levels(factor(alive$day)))){
  
  df2 <- subset(alive, alive$day == i)
  
  if(i < 10) number <- paste0('00',i)
  if(i >= 10 & i <=100) number <- paste0('0',i)
  if(i > 100) number <- i
  
  PNG2 <- paste0(dirpath,'trajectories/', '/ParticlesAlive', number,'.png')
  # #---------- PLOT WITH GGPLOT2 ----------#
  # graph <- ggplot(data = df2) +
  #   geom_point(data = df2, aes(x = lon, y = lat), color = 'black',size = .2) +
  #   borders(fill='grey',colour='grey') +
  #   labs(x = 'Longitude (W)', y = 'Latitude (S)') +
  #   coord_fixed(xlim = xlimmap, ylim = ylimmap, ratio = 2/2) +
  #   geom_text(x = -98, y = -29, label = paste('Day', (i-1)), size=10, hjust=0, vjust=0) +
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
  # if(!is.null(PNG2)) ggsave(filename = PNG2, width = 9, height = 9) else map
  
  #---------- PLOT WITH R BASE ----------#
  png(file = PNG2, height = 650, width = 650)
  par(mar = c(1,2,1,2), oma = c(2,1,.5,.5))
  map('worldHires', add=F, fill=T, col='gray', ylim = ylimmap, xlim = xlimmap)
  box(lwd = 2)
  axis(side = 1, at = seq(xlimmap[1], xlimmap[2], 5), labels = seq(xlimmap[1], xlimmap[2], 5), lwd = 2, lwd.ticks = 2, font.axis=4)
  axis(side = 2, at = seq(ylimmap[1], ylimmap[2], 5), labels = seq(ylimmap[1], ylimmap[2], 5),
       lwd = 2, lwd.ticks = 2, font.axis=4, las = 2)
  points(x = df2[,1], y = df2[,2], pch = 19, cex = .2, col = 'red')
  mtext(text = paste('Day', (i-1)), side = 3, adj = 0.05, line = -1, font = 2)
  grid()
  dev.off()
  # print(PNG2)
}

#--------  PLOT TRAJECTORIES --------#
# Domain (by default) for plots, you can change this geographical domain
lonmin  <- -100
lonmax  <- -70
latmin  <- -0
latmax  <- -20
xlimmap <- c(-100, -70)    # X limits of plot
ylimmap <- c(-30, -0)      # Y limits of plot
zlimmap <- c(0,18)
color.limits <- c(0,10)

#----PLOT ALL TRAJECTORIES----#
PNG3 <- paste0(dirpath, '/figures/allTrajectories.png')
# mymap <- get_map(location = c(lon = (lonmin + lonmax) / 2, lat = (latmin + latmax) / 2),
#                  zoom = 4, maptype = 'satellite', color='bw')
# map   <- ggmap(mymap)
map <- ggplot(data = df)
map <- map +
  geom_path(data = df, aes(group = drifter, x = lon, y = lat, colour = knob), size = .1) +
  scale_colour_gradientn(colours = tim.colors(n = 64, alpha = 1), expression(knob), limits = zlimmap) +
  labs(x = 'Longitude (W)', y = 'Latitude (S)') +
  borders(fill='grey',colour='grey') +
  coord_fixed(xlim = xlimmap, ylim = ylimmap, ratio = 2/2) +
  theme(axis.text.x  = element_text(face='bold', color='black',
                                    size=15, angle=0),
        axis.text.y  = element_text(face='bold', color='black',
                                    size=15, angle=0),
        axis.title.x = element_text(face='bold', color='black',
                                    size=15, angle=0),
        axis.title.y = element_text(face='bold', color='black',
                                    size=15, angle=90),
        legend.text  = element_text(size=15),
        legend.title = element_text(size=15))
if(!is.null(PNG3)) ggsave(filename = PNG3, width = 9, height = 9) else map
print(PNG3); flush.console()

#----PLOT ONLY RETEINED TRAJECTORIES----#
PNG4 <- paste0(dirpath, '/figures/reteinedTrajectories.png')
# mymap <- get_map(location = c(lon = (lonmin + lonmax) / 2, lat = (latmin + latmax) / 2),
#                  zoom = 4, maptype = 'satellite', color='bw')
map   <- ggplot(data = alive)
map <- map +
  geom_path(data = alive, aes(group = drifter, x = lon, y = lat, colour = knob), size = .1) +
  scale_colour_gradientn(colours = tim.colors(n = 64, alpha = 1), expression(knob), limits = zlimmap) +
  labs(x = 'Longitude (W)', y = 'Latitude (S)') +
  borders(fill='grey',colour='grey') +
  coord_fixed(xlim = xlimmap, ylim = ylimmap, ratio = 2/2) +
  theme(axis.text.x  = element_text(face='bold', color='black',
                                    size=15, angle=0),
        axis.text.y  = element_text(face='bold', color='black',
                                    size=15, angle=0),
        axis.title.x = element_text(face='bold', color='black',
                                    size=15, angle=0),
        axis.title.y = element_text(face='bold', color='black',
                                    size=15, angle=90),
        legend.text  = element_text(size=15),
        legend.title = element_text(size=15))
if(!is.null(PNG4)) ggsave(filename = PNG4, width = 9, height = 9) else map
print(PNG4); flush.console()

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
#         legend.title = element_text(size=1        IF(TGL(C,M).eq.1)then !      only TGL=1.        IF(TGL(C,M).eq.1)then !      only TGL=1.5))
# if(!is.null(PNG5)) ggsave(filename = PNG5, width = 9, height = 9) else map
# print(PNG5); flush.console()
#---- FIN PLOT ONLY COASTAL RETEINED TRAJECTORIES----#

#----PLOT DENSITY MAP - FINAL DAY - ALL PARTICLES ----#
PNG6 <- paste0(dirpath, '/figures/densityMapAll.png')
map <- ggplot(data = lastDay, aes(x = lon, y = lat))
map <- map +
  # geom_point(data = lastDay, aes(x = lon, y = lat),colour ="black",size = .001)+
  geom_density2d(data = lastDay, aes(x = lon, y = lat), size = 0.05)+
  stat_density2d(data = lastDay, aes(x = lon, y = lat, fill = ..level.., alpha = ..level..), size = 0.01, geom = "polygon")+
  
  # scale_fill_gradient(low = "green", high = "red",expression(Density), limits = c(0,0.025))+
  scale_fill_gradient(expression(Density), limits = c(0,0.025))+
  # scale_colour_gradientn(colours = tim.colors(n = 64, alpha = 1), expression(Density), limits = c(0,1))+
  
  scale_alpha(range = c(0, 0.5), guide = FALSE)+
  labs(x = 'Longitude (W)', y = 'Latitude (S)') +
  borders(fill='grey',colour='grey') +
  coord_fixed(xlim = xlimmap, ylim = ylimmap, ratio = 2/2) +
  theme(axis.text.x  = element_text(face='bold', color='black',
                                    size=15, angle=0),
        axis.text.y  = element_text(face='bold', color='black',
                                    size=15, angle=0),
        axis.title.x = element_text(face='bold', color='black',
                                    size=15, angle=0),
        axis.title.y = element_text(face='bold', color='black',
                                    size=15, angle=90),
        legend.text  = element_text(size=15),
        legend.title = element_text(size=15))
if(!is.null(PNG6)) ggsave(filename = PNG6, width = 9, height = 9) else map
print(PNG6); flush.console()

#----PLOT DENSITY MAP - FINAL DAY - ALL PARTICLES ----#
alive_final_day <- subset(alive, alive$day == max(as.numeric(levels(factor(df$day)))))
PNG7 <- paste0(dirpath, '/figures/densityMapAlive.png')
map <- ggplot(data = alive_final_day, aes(x = lon, y = lat))
map <- map + geom_point(data = alive_final_day, aes(x = lon, y = lat),colour ="black",size = .001)+
  
  geom_density2d(data = alive_final_day, aes(x = lon, y = lat), size = 0.05)+
  stat_density2d(data = alive_final_day, aes(x = lon, y = lat, fill = ..level.., alpha = ..level..), size = 0.01, geom = "polygon")+
  
  scale_fill_gradient(low = "green", high = "red",expression(Density), limits = c(0,0.05))+
  # scale_colour_gradientn(colours = tim.colors(n = 64, alpha = 1), expression(Density), limits = c(0,1))+
  
  scale_alpha(range = c(0, 0.5), guide = FALSE)+
  labs(x = 'Longitude (W)', y = 'Latitude (S)') +
  borders(fill='grey',colour='grey') +
  coord_fixed(xlim = xlimmap, ylim = ylimmap, ratio = 2/2) +
  theme(axis.text.x  = element_text(face='bold', color='black',
                                    size=15, angle=0),
        axis.text.y  = element_text(face='bold', color='black',
                                    size=15, angle=0),
        axis.title.x = element_text(face='bold', color='black',
                                    size=15, angle=0),
        axis.title.y = element_text(face='bold', color='black',
                                    size=15, angle=90),
        legend.text  = element_text(size=15),
        legend.title = element_text(size=15))
if(!is.null(PNG7)) ggsave(filename = PNG7, width = 9, height = 9) else map
print(PNG7); flush.console()
# rm(list = ls())
#=============================================================================#
# END OF PROGRAM
#=============================================================================#