#=============================================================================#
# Name   : surviv_barplot
# Author : Jorge Flores
# Date   : 
# Version:
# Aim    : 
# URL    : 
#=============================================================================#

dirpath <- '/run/media/jtam/JORGE_OLD/kinesis_escenarios_outputs/escenario_c2/'

survival_cruve <- NULL
for(i in 1:12){
  dir_folder <- paste0(dirpath, 'outM', i)
  surv <- as.numeric(read.table(file = paste0(dir_folder, '/survivePercent.txt')))
  survival_cruve <- c(survival_cruve, surv)
}

ylabs <- seq(0,40,5)
png(filename = paste0(dirpath, 'barplot_survival.png'), width = 650, height = 650, res = 120)
par(lwd = 2)
graph <- barplot(survival_cruve, axes = F, ylim = c(0,40))
axis(side = 1, font = 2, lwd.ticks = 2, lwd = 2, at = graph, labels = 1:12)
axis(side = 2, font = 2, lwd.ticks = 2, lwd = 2, at = ylabs, labels = ylabs,las = 2)
dev.off()
#=============================================================================#
# END OF PROGRAM
#=============================================================================#
