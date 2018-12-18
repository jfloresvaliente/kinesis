#=============================================================================#
# Name   : surviv_barplot
# Author : Jorge Flores
# Date   : 
# Version:
# Aim    : 
# URL    : 
#=============================================================================#
dirpath <- '/run/media/jtam/JORGE_OLD/kinesis_escenarios_outputs/escenario_t4/'

survival_dat <- NULL
for(i in 1:12){
  dir_folder <- paste0(dirpath, 'outM', i)
  if(file.exists(paste0(dir_folder, '/survivePercent.txt'))){
    surv <- as.numeric(read.table(file = paste0(dir_folder, '/survivePercent.txt')))
  }else{
    surv <- 0
  }
  survival_dat <- c(survival_dat, surv)
}

ylabs <- seq(0,40,5)
png(filename = paste0(dirpath, 'barplot_survival.png'), width = 750, height = 650, res = 120)
par(lwd = 2)
graph <- barplot(survival_dat, axes = F, ylim = c(0,40))
axis(side = 1, font = 2, lwd.ticks = 2, lwd = 2, at = graph, labels = 1:12)
axis(side = 2, font = 2, lwd.ticks = 2, lwd = 2, at = ylabs, labels = ylabs,las = 2)
dev.off()
#=============================================================================#
# END OF PROGRAM
#=============================================================================#
