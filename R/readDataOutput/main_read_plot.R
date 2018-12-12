#=============================================================================#
# Name   : main_read_plot
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

dirpath <- '/home/jtam/Documents/case4/escenario/outM8/'
nfiles  <- length(list.files(path = dirpath, pattern = paste0('output','.*\\.txt'), full.names = T, recursive = T))
max_paticles <- 19080
final_age <- 330
final_day <- 330
ylimknob   <- c(0,16)
ylimweight <- c(0,16)

#=============================================================================#
# DO NOT CHANGE ANYTHING AFTER HERE 
#=============================================================================#
source('R/readDataOutput/readDataOutput.R')
source('R/readDataOutput/VB_curve.R')

source('R/readDataOutput/MapParticlesByDay.R')
source('R/readDataOutput/density_map_byday.R')
source('R/readDataOutput/knob_weight_byday.R')
source('R/readDataOutput/hist_knob_weight_byday.R')
source('R/readDataOutput/knob_map_byday.R')
source('R/readDataOutput/weight_map_byday.R')

source('R/readDataOutput/MapParticlesByAge.R')
source('R/readDataOutput/density_map_byage.R')
source('R/readDataOutput/knob_weight_byage.R')
source('R/readDataOutput/hist_knob_weight_byage.R')
source('R/readDataOutput/knob_map_byage.R')
source('R/readDataOutput/weight_map_byage.R')

dir.create(path = paste0(dirpath, 'particlesByDay/'), showWarnings = F)
# dir.create(path = paste0(dirpath, 'particlesByAge/'), showWarnings = F)
dir.create(path = paste0(dirpath, 'figures/'), showWarnings = F)

VB_curve(day = final_age)

if(file.exists(x = paste0(dirpath, 'df.RData'))){
  print('Reading RData ...')
  load(paste0(dirpath, 'df.RData'))
}else{
  print('Writing RData ...')
  readDataOutput(dirpath = dirpath, max_paticles = max_paticles, nfiles = nfiles); dim(df)
  print('Reading RData ...')
  load(paste0(dirpath, 'df.RData'))
}

knob_weight_byday(df = df, Day = final_day)
knob_weight_byage(df = df, Age = final_age)

#=============================================================================#
# Plot Mean Growth (alive_byday) with Wweight
#=============================================================================#
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
mtext(side = 4, line = 3, font = 2, cex = 1.5, text = 'Wet Weight (g)', col = 'red')
dev.off()

#=============================================================================#
# Plot Mean Growth (alive_byage) with Wweight
#=============================================================================#
# png(file = paste0(dirpath, 'figures/meanKnobWeightByage.png'), width = 650, height = 650)
# par(lwd = 2, mar = c(4.5,4.5,1,4.5))
# plot(1:final_day, mean_knob_byday[1:final_day],type = 'l', xlab = '', ylab = '', lwd = 2, axes = F, ylim = ylimknob)
# par(new = T, lwd = 2)
# plot(1:final_day, mean_weight_byday[1:final_day],type = 'l', col = 'red', axes = F, xlab = '', ylab = '', ylim = ylimweight)
# box(lwd = 2)
# axis(side = 1, lwd = 2, lwd.ticks = 2, font.axis = 4, cex.axis = 1.5)
# axis(side = 2, lwd = 2, lwd.ticks = 2, font.axis = 4, cex.axis = 1.5, las = 2)
# axis(side = 4, lwd = 2, lwd.ticks = 2, font.axis = 4, cex.axis = 1.5, las = 2, col='red',  col.axis = 'red')
# mtext(side = 1, line = 3, font = 2, cex = 1.5, text = 'Age in Days')
# mtext(side = 2, line = 3, font = 2, cex = 1.5, text = 'knob (cm)')
# mtext(side = 4, line = 3, font = 2, cex = 1.5, text = 'Wet Weight (g)', col = 'red')
# dev.off()

#=============================================================================#
# Hist Mean Growth (alive_byday) with Wweight
#=============================================================================#
hist_knob_weight_byday(df = df, Day = final_day, VB = VB40)

png(file = paste0(dirpath, 'figures/histKnobWeightByday.png'), width = 950, height = 550)
par(lwd = 2, mfrow = c(1,2), mar = c(4.5,4.5,1,4.5))

hist(hist_knob_byday  , freq = F, ylim = c(0,.6), axes = F, xlab = '', ylab = '', main = '')
axis(side = 1, lwd = 2, lwd.ticks = 2, font.axis = 4, cex.axis = 1.5)
axis(side = 2, lwd = 2, lwd.ticks = 2, font.axis = 4, cex.axis = 1.5, las = 2)
mtext(side = 1, line = 3, font = 2, cex = 1.5, text = 'knob (cm)')
mtext(side = 2, line = 3, font = 2, cex = 1.5, text = 'Relative Frequecy (%)')
mtext(side = 3, line =-2, font = 2, cex = 1.5, text = paste('Day:', final_age), adj = 0.1)
box(lwd = 2)

hist(hist_weight_byday, freq = F, ylim = c(0,.6), axes = F, xlab = '', ylab = '', main = '')
axis(side = 1, lwd = 2, lwd.ticks = 2, font.axis = 4, cex.axis = 1.5)
axis(side = 2, lwd = 2, lwd.ticks = 2, font.axis = 4, cex.axis = 1.5, las = 2)
mtext(side = 1, line = 3, font = 2, cex = 1.5, text = 'Wet Weight (g)')
mtext(side = 2, line = 3, font = 2, cex = 1.5, text = 'Relative Frequecy (%)')
mtext(side = 3, line =-2, font = 2, cex = 1.5, text = paste('Day:', final_age), adj = 0.1)
box(lwd = 2)
dev.off()

#=============================================================================#
# Hist Mean Growth (alive_byage) with Wweight
#=============================================================================#
# hist_knob_weight_byage(df = df, Age = final_age, VB = VB40)
# 
# png(file = paste0(dirpath, 'figures/histKnobWeightByage.png'), width = 950, height = 550)
# par(lwd = 2, mfrow = c(1,2), mar = c(4.5,4.5,1,4.5))
# 
# hist(hist_knob_byage  , freq = F, ylim = c(0,.6), axes = F, xlab = '', ylab = '', main = '')
# axis(side = 1, lwd = 2, lwd.ticks = 2, font.axis = 4, cex.axis = 1.5)
# axis(side = 2, lwd = 2, lwd.ticks = 2, font.axis = 4, cex.axis = 1.5, las = 2)
# mtext(side = 1, line = 3, font = 2, cex = 1.5, text = 'knob (cm)')
# mtext(side = 2, line = 3, font = 2, cex = 1.5, text = 'Relative Frequecy (%)')
# mtext(side = 3, line =-2, font = 2, cex = 1.5, text = paste('Age:', final_age, 'days'), adj = 0.1)
# box(lwd = 2)
# 
# hist(hist_weight_byage, freq = F, ylim = c(0,.6), axes = F, xlab = '', ylab = '', main = '')
# axis(side = 1, lwd = 2, lwd.ticks = 2, font.axis = 4, cex.axis = 1.5)
# axis(side = 2, lwd = 2, lwd.ticks = 2, font.axis = 4, cex.axis = 1.5, las = 2)
# mtext(side = 1, line = 3, font = 2, cex = 1.5, text = 'Wet Weight (g)')
# mtext(side = 2, line = 3, font = 2, cex = 1.5, text = 'Relative Frequecy (%)')
# mtext(side = 3, line =-2, font = 2, cex = 1.5, text = paste('Age:', final_age, 'days'), adj = 0.1)
# box(lwd = 2)
# dev.off()

#=============================================================================#
# PLOT MAPS
#=============================================================================#

outpathByDay <- paste0(dirpath, 'particlesByDay/')
# outpathByAge <- paste0(dirpath, 'particlesByAge/')
outpathFigures <- paste0(dirpath, 'figures/')

if(length(list.files(outpathByDay)) == 0) MapParticlesByDay(df = df, outpath = outpathByDay)

# MapParticlesByAge(df = df, outpath = outpathByAge)
density_map_byday(df = df, outpath = outpathFigures, days = c(1,50,100,200,300), range = c(0,.075))
# density_map_byage(df = df, outpath = outpathFigures, ages = c(1,50,100,200,300,360), range = c(0,.075))

knob_map_byday(df = df, outpath = outpathFigures, days = c(1,330))
# knob_map_byage(df = df, outpath = outpathFigures, ages = c(1,360))
weight_map_byday(df = df, outpath = outpathFigures, days = c(1,330), zlimmap = c(0,20))
# weight_map_byage(df = df, outpath = outpathFigures, ages = c(1,360), zlimmap = c(0,20))
#=============================================================================#
# END OF PROGRAM
#=============================================================================#

# Calcular Pocentaje de Sobrevivientes
percent <- subset(df, df$TGL == 1 & df$day == final_day)
percent <- subset(percent, percent$knob >= VB40)$drifter
percent <- (length(percent) * 100)/max_paticles
write.table(x = percent, file = paste0(dirpath, 'survivePercent.txt'), col.names = F, row.names = F)
# 318 puntos -6,-15 S; 80 km (6 pixeles ROMS)
# 12 horas = 39.0356 %
# 06 horas = 39.1142 %
# FinCalcular Pocentaje de Sobrevivientes
