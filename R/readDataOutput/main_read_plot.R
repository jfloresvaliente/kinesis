#=============================================================================#
# Name   : main_read_plot
# Author : Jorge Flores
# Date   : 
# Version:
# Aim    : 
# URL    : 
#=============================================================================#
dirpath <- 'D:/kinesis_escenarios_outputs/escenario/outM2/'
nfiles  <- length(list.files(path = dirpath, pattern = paste0('output','.*\\.txt'), full.names = T, recursive = T))
max_paticles <- 9540
final_age <- 360
final_day <- 360
ylimknob   <- c(0,16)
ylimweight <- c(0,16)

#=============================================================================#
#===================== DO NOT CHANGE ANYTHING AFTER HERE =====================#
#=============================================================================#

#=== Crear 'PATHS' y directorios para guardar figuras ===#
outpathByDayAll    <- paste0(dirpath, 'particlesByDay/all/')
dir.create(outpathByDayAll, showWarnings = F, recursive = T)

outpathByDayAlive  <- paste0(dirpath, 'particlesByDay/alive/')
dir.create(outpathByDayAlive, showWarnings = F, recursive = T)

outpathByAgeAll    <- paste0(dirpath, 'particlesByAge/all/')
dir.create(outpathByAgeAll, showWarnings = F, recursive = T)

outpathByAgeAlive  <- paste0(dirpath, 'particlesByAge/alive/')
dir.create(outpathByAgeAlive, showWarnings = F, recursive = T)

outpathFigures <- paste0(dirpath, 'figures/')
dir.create(outpathFigures, showWarnings = F, recursive = T)

# Load functions and packages
source('R/readDataOutput/load_packages_functions.R')

#=== GET VON_BERTALANFFY CURVE ===#
VB_curve(day = final_age)

#=== READING DATA ===#
if(file.exists(x = paste0(dirpath, 'df.RData'))){
  print('Reading RData ...')
  load(paste0(dirpath, 'df.RData'))
}else{
  print('Reading .txt data ...')
  readDataOutput(dirpath = dirpath, max_paticles = max_paticles, nfiles = nfiles); dim(df)
  print('Saving RData ...')
  load(paste0(dirpath, 'df.RData'))
}

#=============================================================================#
# PLOT MAPS
#=============================================================================#
#--- Plot Density Map ---#
dens2D_map_byage(df = df, outpath = outpathFigures, ages = c(360))
dens2D_map_byage(df = df, outpath = outpathFigures, ages = c(360), xlimmap = c(-85,-70), ylimmap = c(-20,0), alive = T)

dens2D_map_byday(df = df, outpath = outpathFigures, days = c(360))
dens2D_map_byday(df = df, outpath = outpathFigures, days = c(360), xlimmap = c(-85,-70), ylimmap = c(-20,0), alive = T)

#--- Plot Knob Map ---#
knob_map_byage(df = df, outpath = outpathFigures, ages = c(final_age))
knob_map_byage(df = df, outpath = outpathFigures, ages = c(final_age), xlimmap = c(-85,-70), ylimmap = c(-20,0), alive = T)

knob_map_byday(df = df, outpath = outpathFigures, days = c(final_age))
knob_map_byday(df = df, outpath = outpathFigures, days = c(final_age), xlimmap = c(-85,-70), ylimmap = c(-20,0), alive = T)

# Plot Weight Map ---#
weight_map_byage(df = df, outpath = outpathFigures, ages = c(final_age), zlimmap = c(0,23))
weight_map_byage(df = df, outpath = outpathFigures, ages = c(final_age), xlimmap = c(-85,-70), ylimmap = c(-20,0), alive = T, zlimmap = c(0,23))

weight_map_byday(df = df, outpath = outpathFigures, days = c(final_age), zlimmap = c(0,23))
weight_map_byday(df = df, outpath = outpathFigures, days = c(final_age), xlimmap = c(-85,-70), ylimmap = c(-20,0), alive = T, zlimmap = c(0,23))

#--- Plot Particle Maps ---#
if(length(list.files(outpathByDayAll)) != nfiles)   MapParticlesByDay(df = df, outpath = outpathByDayAll)
if(length(list.files(outpathByDayAlive)) != nfiles) MapParticlesByDay(df = df, outpath = outpathByDayAlive, alive = T)

if(length(list.files(outpathByAgeAll)) != nfiles)   MapParticlesByAge(df = df, outpath = outpathByAgeAll)
if(length(list.files(outpathByAgeAlive)) != nfiles) MapParticlesByAge(df = df, outpath = outpathByAgeAlive, alive = T)

#=============================================================================#
# Plot Mean Growth (byday) with Wweight
#=============================================================================#
knob_weight_byday(df = df, day = final_age, VB = VB40, alive = F)
knob_weight_byday(df = df, day = final_age, VB = VB40, alive = T)

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

png(file = paste0(dirpath, 'figures/meanKnobWeightBydayAlive.png'), width = 650, height = 650)
par(lwd = 2, mar = c(4.5,4.5,1,4.5))
plot(1:final_day, mean_knob_byday_alive[1:final_day],type = 'l', xlab = '', ylab = '', lwd = 2, axes = F, ylim = ylimknob)
par(new = T, lwd = 2)
plot(1:final_day, mean_weight_byday_alive[1:final_day],type = 'l', col = 'red', axes = F, xlab = '', ylab = '', ylim = ylimweight)
box(lwd = 2)
axis(side = 1, lwd = 2, lwd.ticks = 2, font.axis = 4, cex.axis = 1.5)
axis(side = 2, lwd = 2, lwd.ticks = 2, font.axis = 4, cex.axis = 1.5, las = 2)
axis(side = 4, lwd = 2, lwd.ticks = 2, font.axis = 4, cex.axis = 1.5, las = 2, col='red',  col.axis = 'red')
mtext(side = 1, line = 3, font = 2, cex = 1.5, text = 'Days after spawning')
mtext(side = 2, line = 3, font = 2, cex = 1.5, text = 'knob (cm)')
mtext(side = 4, line = 3, font = 2, cex = 1.5, text = 'Wet Weight (g)', col = 'red')
dev.off()

#=============================================================================#
# Plot Mean Growth (byage) with Wweight
#=============================================================================#
knob_weight_byage(df = df, age = final_age, VB = VB40, alive = F)
knob_weight_byage(df = df, age = final_age, VB = VB40, alive = T)

png(file = paste0(dirpath, 'figures/meanKnobWeightByage.png'), width = 650, height = 650)
par(lwd = 2, mar = c(4.5,4.5,1,4.5))
plot(1:final_day, mean_knob_byage[1:final_age],type = 'l', xlab = '', ylab = '', lwd = 2, axes = F, ylim = ylimknob)
par(new = T, lwd = 2)
plot(1:final_day, mean_weight_byage[1:final_age],type = 'l', col = 'red', axes = F, xlab = '', ylab = '', ylim = ylimweight)
box(lwd = 2)
axis(side = 1, lwd = 2, lwd.ticks = 2, font.axis = 4, cex.axis = 1.5)
axis(side = 2, lwd = 2, lwd.ticks = 2, font.axis = 4, cex.axis = 1.5, las = 2)
axis(side = 4, lwd = 2, lwd.ticks = 2, font.axis = 4, cex.axis = 1.5, las = 2, col='red',  col.axis = 'red')
mtext(side = 1, line = 3, font = 2, cex = 1.5, text = 'Age in Days')
mtext(side = 2, line = 3, font = 2, cex = 1.5, text = 'knob (cm)')
mtext(side = 4, line = 3, font = 2, cex = 1.5, text = 'Wet Weight (g)', col = 'red')
dev.off()

png(file = paste0(dirpath, 'figures/meanKnobWeightByageAlive.png'), width = 650, height = 650)
par(lwd = 2, mar = c(4.5,4.5,1,4.5))
plot(1:final_day, mean_knob_byage_alive[1:final_age],type = 'l', xlab = '', ylab = '', lwd = 2, axes = F, ylim = ylimknob)
par(new = T, lwd = 2)
plot(1:final_day, mean_weight_byage_alive[1:final_age],type = 'l', col = 'red', axes = F, xlab = '', ylab = '', ylim = ylimweight)
box(lwd = 2)
axis(side = 1, lwd = 2, lwd.ticks = 2, font.axis = 4, cex.axis = 1.5)
axis(side = 2, lwd = 2, lwd.ticks = 2, font.axis = 4, cex.axis = 1.5, las = 2)
axis(side = 4, lwd = 2, lwd.ticks = 2, font.axis = 4, cex.axis = 1.5, las = 2, col='red',  col.axis = 'red')
mtext(side = 1, line = 3, font = 2, cex = 1.5, text = 'Age in Days')
mtext(side = 2, line = 3, font = 2, cex = 1.5, text = 'knob (cm)')
mtext(side = 4, line = 3, font = 2, cex = 1.5, text = 'Wet Weight (g)', col = 'red')
dev.off()

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
hist_knob_weight_byage(df = df, Age = final_age, VB = VB40)

png(file = paste0(dirpath, 'figures/histKnobWeightByage.png'), width = 950, height = 550)
par(lwd = 2, mfrow = c(1,2), mar = c(4.5,4.5,1,4.5))

hist(hist_knob_byage  , freq = F, ylim = c(0,.6), axes = F, xlab = '', ylab = '', main = '')
axis(side = 1, lwd = 2, lwd.ticks = 2, font.axis = 4, cex.axis = 1.5)
axis(side = 2, lwd = 2, lwd.ticks = 2, font.axis = 4, cex.axis = 1.5, las = 2)
mtext(side = 1, line = 3, font = 2, cex = 1.5, text = 'knob (cm)')
mtext(side = 2, line = 3, font = 2, cex = 1.5, text = 'Relative Frequecy (%)')
mtext(side = 3, line =-2, font = 2, cex = 1.5, text = paste('Age:', final_age, 'days'), adj = 0.1)
box(lwd = 2)

hist(hist_weight_byage, freq = F, ylim = c(0,.6), axes = F, xlab = '', ylab = '', main = '')
axis(side = 1, lwd = 2, lwd.ticks = 2, font.axis = 4, cex.axis = 1.5)
axis(side = 2, lwd = 2, lwd.ticks = 2, font.axis = 4, cex.axis = 1.5, las = 2)
mtext(side = 1, line = 3, font = 2, cex = 1.5, text = 'Wet Weight (g)')
mtext(side = 2, line = 3, font = 2, cex = 1.5, text = 'Relative Frequecy (%)')
mtext(side = 3, line =-2, font = 2, cex = 1.5, text = paste('Age:', final_age, 'days'), adj = 0.1)
box(lwd = 2)
dev.off()
#=============================================================================#
# END OF PROGRAM
#=============================================================================#

sur_serie <- NULL
for(i in 1:final_age){
  VB_curve(day = i)
  surv <- subset(df, df$age == i & df$knob >= VB40)
  PA <- surv$PA
  surv <- dim(surv)[1]
  sur_per <- (surv*100)/max_paticles
  sur_serie <- c(sur_serie, sur_per)
}
 
VB_curve(day = final_age)
surv <- subset(df, df$age == final_age & df$knob >= VB40)
ind <- surv$drifter

PA_sur <- NULL
for(i in 1:final_age){
  surv <- subset(df, df$age == i)
  surv <- subset(surv, surv$drifter %in% ind)
  surv <- mean(surv$PA)
  PA_sur <- c(PA_sur, surv)
}

png(filename = paste0(outpathFigures,'survival.png'), width = 850, height = 850, res = 120)
plot(PA_sur, type = 'l', lty = 2, ylab = 'Survival', xlab = 'Age', ylim = c(0,100))
lines(abs(sur_serie - 100), type = 'l', col = 'red')
legend('topright', legend = c('40%+Z', '40%'), bty = 'n', lty = c(2,1), col = c('black','red'))
dev.off()

# Plotear serie de tiempo por variable
varis <- c('exSST', 'exPY', 'exSZ', 'exMZ')
png(filename = paste0(outpathFigures, 'varitimeserie.png'), width = 1250, height = 950, res = 120)
par(mfrow = c(2,2), mar = c(3.5,5,1,1))
for(i in varis){
  parsi <- timeserie_vari(df = df, outpath = outpathFigures, VB = VB40, alive = T, vari = i)[1:final_age]
  parno <- timeserie_vari(df = df, outpath = outpathFigures, VB = VB40, alive = F, vari = i)[1:final_age]

  rangetemp <- range(c(parsi, parno))

  plot(1:final_age, type = 'n', ylab = '', ylim = rangetemp, xlab = '', axes = F)
  mtext(text = i, side = 2, line = 3, font = 2)
  mtext(text = 'Age', side = 1, line = 2.5, font = 2)
  axis(side = 1, font = 2)
  axis(side = 2, font = 2, las = 2)
  box()
  lines(parsi, lwd = 2, col = 'black')
  lines(parno, lwd = 2, col = 'red')
  legend('topleft', legend = c('alive', 'no-alive'), bty = 'n', lty = c(1,1),
         col = c('black', 'red'), lwd = c(2,2))
}
dev.off()
 
