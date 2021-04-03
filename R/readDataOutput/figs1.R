#=============================================================================#
# Name   : --
# Author : Jorge Flores
# Date   : 
# Version:
# Aim    : 
# URL    : 
#=============================================================================#
dirpath    <- 'C:/Users/jflores/Documents/JORGE/colaboradores/Takeshi/out/'
stepFinal  <- 360
ylimknob   <- c(0,15)
ylimweight <- c(0,20)
#=============================================================================#
#===================== Do not change anything from here ======================#
#=============================================================================#

#========== Create directory to save figures ==========#
outpathFigures <- paste0(dirpath, 'figures/')
dir.create(outpathFigures, showWarnings = F, recursive = T)

#========== Load functions and packages ==========#
source('R/readDataOutput/load_packages_functions.R')

#========== Get VonBertalanffy curve ==========#
VB_curve(day = stepFinal)

#========== Load data from KINESIS model outputs ==========#
load(paste0(dirpath, 'df.RData'))

#=============================================================================#
# Plot Mean Growth (by age) with Wweight
#=============================================================================#
knob_weight_byday(df = df, alive = T)
knob_weight_byday(df = df, alive = F)

png(file = paste0(dirpath, 'figures/mean_knobWeight_age_alive.png'), width = 650, height = 650)
par(lwd = 2, mar = c(5,5,1,5))
plot(0:stepFinal, knob_byage_alive[[1]],  type = 'l', xlab = '', ylab = '', lwd = 2, axes = F, ylim = ylimknob)
axis(side = 1, lwd = 2, lwd.ticks = 2, font.axis = 4, cex.axis = 1.5)
axis(side = 2, lwd = 2, lwd.ticks = 2, font.axis = 4, cex.axis = 1.5, at = seq(ylimknob[1],ylimknob[2],2), las = 2)
mtext(side = 1, line = 3, font = 2, cex = 1.5, text = 'Time after spawning [d]')
mtext(side = 2, line = 3, font = 2, cex = 1.5, text = 'knob [cm]')
box(lwd = 2)
par(new = T, lwd = 2)
plot(0:stepFinal, weight_byage_alive[[1]],type = 'l', xlab = '', ylab = '', lwd = 2, axes = F, ylim = ylimweight , col = 'red')
axis(side = 4, lwd = 2, line = .5, lwd.ticks = 2, font.axis = 4, cex.axis = 1.5, las = 2, col='red',  col.axis = 'red')
mtext(side = 4, line = 3, font = 2, cex = 1.5, text = 'Wet Weight (g)', col = 'red')
dev.off()

png(file = paste0(dirpath, 'figures/mean_knobWeight_age_nonalive.png'), width = 650, height = 650)
par(lwd = 2, mar = c(5,5,1,5))
plot(0:stepFinal, knob_byage_nonalive[[1]],  type = 'l', xlab = '', ylab = '', lwd = 2, axes = F, ylim = ylimknob)
axis(side = 1, lwd = 2, lwd.ticks = 2, font.axis = 4, cex.axis = 1.5)
axis(side = 2, lwd = 2, lwd.ticks = 2, font.axis = 4, cex.axis = 1.5, at = seq(ylimknob[1],ylimknob[2],2), las = 2)
mtext(side = 1, line = 3, font = 2, cex = 1.5, text = 'Time after spawning [d]')
mtext(side = 2, line = 3, font = 2, cex = 1.5, text = 'knob [cm]')
box(lwd = 2)
par(new = T, lwd = 2)
plot(0:stepFinal, weight_byage_nonalive[[1]],type = 'l', xlab = '', ylab = '', lwd = 2, axes = F, ylim = ylimweight , col = 'red')
axis(side = 4, lwd = 2, line = .5, lwd.ticks = 2, font.axis = 4, cex.axis = 1.5, las = 2, col='red',  col.axis = 'red')
mtext(side = 4, line = 3, font = 2, cex = 1.5, text = 'Wet Weight (g)', col = 'red')
dev.off()

#=============================================================================#
# Plot histogram of Knob and weight
#=============================================================================#
DF <- subset(df, df$age == stepFinal & df$knob >= VB40 & df$TGL == 1)

png(file = paste0(dirpath, 'figures/hist_knob_age_alive.png'), width = 650, height = 650)
par(mar = c(6,6,1,1), lwd = 2)
hist(DF$knob, xlab = '', ylab = '', axes = F, main = '')
axis(side = 1, lwd = 2, lwd.ticks = 2, font.axis = 4, cex.axis = 1.5)
axis(side = 2, lwd = 2, lwd.ticks = 2, font.axis = 4, cex.axis = 1.5, las = 2)
mtext(side = 1, line = 3, font = 2, cex = 1.5, text = 'Knob [cm]')
mtext(side = 2, line = 4, font = 2, cex = 1.5, text = 'Absolute frecuency [#]')
mtext(side = 3, line =-2, font = 2, cex = 1.5, text = paste('Age:', stepFinal), adj = 0.1)
box(lwd = 2)
dev.off()

png(file = paste0(dirpath, 'figures/hist_weight_age_alive.png'), width = 650, height = 650)
par(mar = c(6,6,1,1), lwd = 2)
hist(DF$Wweight, xlab = '', ylab = '', axes = F, main = '')
axis(side = 1, lwd = 2, lwd.ticks = 2, font.axis = 4, cex.axis = 1.5)
axis(side = 2, lwd = 2, lwd.ticks = 2, font.axis = 4, cex.axis = 1.5, las = 2)
mtext(side = 1, line = 3, font = 2, cex = 1.5, text = 'Wet weight [g]')
mtext(side = 2, line = 4, font = 2, cex = 1.5, text = 'Absolute frecuency [#]')
mtext(side = 3, line =-2, font = 2, cex = 1.5, text = paste('Age:', stepFinal), adj = 0.1)
box(lwd = 2)
dev.off()

#=============================================================================#
# Plot PA curve
#=============================================================================#
DF <- subset(df, df$age == stepFinal & df$knob >= VB40 & df$TGL == 1)$drifter
DF <- subset(df, df$drifter %in% DF)
DF <- tapply(DF$PA, list(DF$age), mean)

png(file = paste0(dirpath, 'figures/PA_age_alive.png'), width = 650, height = 650)
par(mar = c(6,6,1,1), lwd = 2)
plot(0:stepFinal, DF[1:(stepFinal+1)],  type = 'l', xlab = '', ylab = '', lwd = 2, axes = F, ylim = c(0,100))
axis(side = 1, lwd = 2, lwd.ticks = 2, font.axis = 4, cex.axis = 1.5)
axis(side = 2, lwd = 2, lwd.ticks = 2, font.axis = 4, cex.axis = 1.5, las = 2)
mtext(side = 1, line = 3, font = 2, cex = 1.5, text = 'Time after spawning [d]')
mtext(side = 2, line = 4, font = 2, cex = 1.5, text = 'PA')
box(lwd = 2)
dev.off()


