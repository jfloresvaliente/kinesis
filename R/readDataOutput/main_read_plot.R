library(ggplot2)
library(fields)
library(mapdata)
library(raster)
library(mgcv)

source('R/readDataOutput/readDataOutput.R')
source('R/readDataOutput/MapParticlesByDay.R')
source('R/readDataOutput/MapParticlesByAge.R')
source('R/readDataOutput/density_map_byday.R')
source('R/readDataOutput/density_map_byage.R')
source('R/readDataOutput/VB_curve.R')
source('R/readDataOutput/knob_weight_byage.R')
source('R/readDataOutput/knob_weight_byday.R')

dirpath <- 'C:/Users/ASUS/Desktop/out/'
nfiles  <- 360 +30
max_paticles <- 5880
final_age <- 360
final_day <- 360
ylimknob   <- c(0,16)
ylimweight <- c(0,16)

# No cambiar nada desde aqui #

dir.create(path = paste0(dirpath, 'particlesByDay/'), showWarnings = F)
dir.create(path = paste0(dirpath, 'particlesByAge/'), showWarnings = F)
dir.create(path = paste0(dirpath, 'figures/'), showWarnings = F)


VB_curve(day = final_age)

readDataOutput(dirpath = dirpath, max_paticles = max_paticles, nfiles = nfiles); dim(df)

knob_weight_byday(df = df, Day = final_day)
knob_weight_byage(df = df, Age = final_age)

#----------Plot Max Growth (alive_byday) with Wweight---------#
png(file = paste0(dirpath, 'figures/meanKnobWeightByday.png'), width = 650, height = 650)
par(lwd = 2, mar = c(4.5,4.5,1,4.5))
plot(1:final_day, mean_knob_byday[1:final_day],type = 'l', xlab = '', ylab = '', lwd = 2, axes = F, ylim = ylimknob)
par(new = T, lwd = 2)
plot(1:final_day, mean_weight_byday[1:final_day],type = 'l', col = 'red', axes = F, xlab = '', ylab = '', ylim = ylimweight)
box(lwd = 2)
axis(side = 1, lwd = 2, lwd.ticks = 2, font.axis = 4, cex.axis = 1.5)
axis(side = 2, lwd = 2, lwd.ticks = 2, font.axis = 4, cex.axis = 1.5, las = 2)
axis(side = 4, lwd = 2, lwd.ticks = 2, font.axis = 4, cex.axis = 1.5, las = 2, col='red',  col.axis = 'red')
mtext(side = 1, line = 3, font = 2, cex = 1.5, text = 'Days after spawning')
mtext(side = 2, line = 3, font = 2, cex = 1.5, text = 'knob (cm)')
mtext(side = 4, line = 3, font = 2, cex = 1.5, text = 'Wet Weight', col = 'red')
dev.off()

#----------Plot Max Growth (alive_byage) with Wweight---------#
png(file = paste0(dirpath, 'figures/meanKnobWeightByage.png'), width = 650, height = 650)
par(lwd = 2, mar = c(4.5,4.5,1,4.5))
plot(1:final_day, mean_knob_byday[1:final_day],type = 'l', xlab = '', ylab = '', lwd = 2, axes = F, ylim = ylimknob)
par(new = T, lwd = 2)
plot(1:final_day, mean_weight_byday[1:final_day],type = 'l', col = 'red', axes = F, xlab = '', ylab = '', ylim = ylimweight)
box(lwd = 2)
axis(side = 1, lwd = 2, lwd.ticks = 2, font.axis = 4, cex.axis = 1.5)
axis(side = 2, lwd = 2, lwd.ticks = 2, font.axis = 4, cex.axis = 1.5, las = 2)
axis(side = 4, lwd = 2, lwd.ticks = 2, font.axis = 4, cex.axis = 1.5, las = 2, col='red',  col.axis = 'red')
mtext(side = 1, line = 3, font = 2, cex = 1.5, text = 'Age')
mtext(side = 2, line = 3, font = 2, cex = 1.5, text = 'knob (cm)')
mtext(side = 4, line = 3, font = 2, cex = 1.5, text = 'Wet Weight', col = 'red')
dev.off()



# # Select only TGL = 1
# df <- subset(df, df$TGL == 1)
# 
# # Subset de individuos > 40 % VonBertalanffy
# df_final_day <- subset(df, df$day == final_day)
# df_final_day <- subset(df, df_final_day$drifter %in% which(df_final_day$knob >= VB40))
# 
# df_final_age <- subset(df, df$age == final_age)
# df_final_age <- subset(df, df_final_age$drifter %in% which(df_final_age$knob >= VB40))
# 
# 
# x11()
# par(mfrow = c(1,2))
# hist(df_final_day$day == final_day)
# hist(df_final_age$day == final_age)
# 
# 
# 
# 
# 
# df360 <- subset(df, df$age == 360 & df$knob >= VB40)
# df40 <- levels(factor(df360$drifter))
# df40 <- subset(df, df$drifter %in% df40)
# 

# 
# outpathByDay <- paste0(dirpath, 'particlesByDay/')
# outpathByAge <- paste0(dirpath, 'particlesByAge/')
# outpathFigures <- paste0(dirpath, 'figures/')
# 
# MapParticlesByDay(df = df, outpath = outpathByDay)
# MapParticlesByAge(df = df, outpath = outpathByAge)
# density_map_byday(df = df40, outpath = outpathFigures, days = c(1,50,100,200,300,360))
# density_map_byage(df = df40, outpath = outpathFigures, ages = c(1,50,100,200,300,360))
# 
# 
# 
# 
# 
# 
# 
# 
# 
# # setwd("~/Documents/case4")
# 
# # input_path <- 'F:/'
# # xlimmap <- c(-100, -70)    # X limits of plot
# # ylimmap <- c(-30, -0)      # Y limits of plot
# 
# # xlimmap <- c(-85, -70)    # X limits of plot
# # ylimmap <- c(-19, -4.95)      # Y limits of plot
# 
