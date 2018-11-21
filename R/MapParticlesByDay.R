#=============================================================================#
# Name   : MapParticlesByDay
# Author : Jorge Flores
# Date   : 
# Version:
# Aim    : 
# URL    : 
#=============================================================================#
MapParticlesByDay <- function(df, outpath, TGL = 1){
  
  dir.create(outpath, showWarnings = F)
  var_fact <- levels(factor(df$day))
  
  for(i in 1:length(var_fact)){
    
    if(is.null(TGL)){
      sub_df <- subset(df, df$day == var_fact[i])
    }else{
      sub_df <- subset(df, df$day == var_fact[i] & df$TGL == 1)
    }
    
    i_name <- as.numeric(var_fact[i]) - 1
    if(i_name < 10) number <- paste0('00',i_name)
    if(i_name >= 10 & i_name <=100) number <- paste0('0',i_name)
    if(i_name > 100) number <- i_name
    
    PNG <- paste0(dirpath,'trajectories/', '/ParticlesReleaseDay',number ,'.png')
    
    png(file = PNG, height = 650, width = 650)
    par(mar = c(1,2,1,2), oma = c(2,1,.5,.5))
    map('worldHires', add=F, fill=T, col='gray', ylim = ylimmap, xlim = xlimmap)
    box(lwd = 2)
    axis(side = 1, at = seq(xlimmap[1], xlimmap[2], 5), labels = seq(xlimmap[1],xlimmap[2], 5),
         lwd = 2, lwd.ticks = 2, font.axis=4)
    axis(side = 2, at = seq(ylimmap[1], ylimmap[2], 5), labels = seq(ylimmap[1], ylimmap[2], 5),
         lwd = 2, lwd.ticks = 2, font.axis=4, las = 2)
    points(x = sub_df[,1], y = sub_df[,2], pch = 19, cex = .2, col = 'red')
    mtext(text = paste('Day', (i-1)), side = 3, adj = 0.05, line = -1, font = 2)
    mtext(text = paste('# Drifter:', dim(sub_df)[1]), side = 3, adj = 0.05, line = -3, font = 2)
    grid()
    dev.off()
    print(PNG)
  }
}
#=============================================================================#
# END OF PROGRAM
#=============================================================================#
MapParticlesByDay(df = df, outpath = outpath, TGL = 1)
