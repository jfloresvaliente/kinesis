#=============================================================================#
# Name   : MapParticlesByDay
# Author : Jorge Flores
# Date   : 
# Version:
# Aim    : 
# URL    : 
#=============================================================================#
MapParticlesByDay <- function(
  df
  ,outpath
  ,xlimmap = c(-100,-70)
  ,ylimmap = c(-30,0)
  ,zlimmap = c(0,15)
  ,VB = VB40
  ,alive = F
  ){
  #============ ============ Arguments ============ ============#
  # df = data frame with data of output kinesis
  # ages = ages to plot in the map
  # xlimmap = X domain of map
  # ylimmap = Y domain of map
  # VB = length of Von Bertalanffy 
  # alive = if TRUE, plot the alive particles
  #============ ============ Arguments ============ ============#
  
  if(alive == T){
    alive_index <- subset(df, df$age == 360 & df$knob >= VB)
    df <- subset(df, df$drifter %in% alive_index$drifter)
    outname <- 'dayAlive'
  }else{
    outname <- 'day'
  }
  
  var_fact <- as.numeric(levels(factor(df$day)))
  
  for(i in 1:length(var_fact)){
    
    i_name <- var_fact[i]
    if(i_name < 10) number <- paste0('00',i_name)
    if(i_name >= 10 & i_name <100) number <- paste0('0',i_name)
    if(i_name >= 100) number <- i_name
    
    if(i_name == 0){
      
      sub_df <- subset(df, df$day == i_name)
      PNG <- paste0(outpath, outname, number ,'.png')
      
      png(file = PNG, height = 650, width = 650)
      par(mar = c(1,2,1,2), oma = c(2,1,.5,.5))
      map('worldHires', add=F, fill=T, col='gray', ylim = ylimmap, xlim = xlimmap)
      box(lwd = 2)
      axis(side = 1, at = seq(xlimmap[1], xlimmap[2], 5), labels = seq(xlimmap[1],xlimmap[2], 5),
           lwd = 2, lwd.ticks = 2, font.axis=4)
      axis(side = 2, at = seq(ylimmap[1], ylimmap[2], 5), labels = seq(ylimmap[1], ylimmap[2], 5),
           lwd = 2, lwd.ticks = 2, font.axis=4, las = 2)
      points(x = sub_df[,1], y = sub_df[,2], pch = 19, cex = .2, col = 'red')
      mtext(text = paste('Day', i_name), side = 3, adj = 0.05, line = -1, font = 2)
      # mtext(text = paste('# Drifters:', dim(sub_df)[1]), side = 3, adj = 0.05, line = -3, font = 2)
      grid()
      dev.off()
      print(PNG)
    }else{
      sub_df <- subset(df, df$day == i_name & df$TGL == 1)
      PNG <- paste0(outpath, 'day',number ,'.png')
      
      png(file = PNG, height = 650, width = 650)
      par(mar = c(1,2,1,2), oma = c(2,1,.5,.5))
      map('worldHires', add=F, fill=T, col='gray', ylim = ylimmap, xlim = xlimmap)
      box(lwd = 2)
      axis(side = 1, at = seq(xlimmap[1], xlimmap[2], 5), labels = seq(xlimmap[1],xlimmap[2], 5),
           lwd = 2, lwd.ticks = 2, font.axis=4)
      axis(side = 2, at = seq(ylimmap[1], ylimmap[2], 5), labels = seq(ylimmap[1], ylimmap[2], 5),
           lwd = 2, lwd.ticks = 2, font.axis=4, las = 2)
      points(x = sub_df[,1], y = sub_df[,2], pch = 19, cex = .2, col = 'red')
      mtext(text = paste('Day', i_name), side = 3, adj = 0.05, line = -1, font = 2)
      mtext(text = paste('# Drifters:', dim(sub_df)[1]), side = 3, adj = 0.05, line = -3, font = 2)
      grid()
      dev.off()
      print(PNG)
    }
  }
}
#=============================================================================#
# END OF PROGRAM
#=============================================================================#