#=============================================================================#
# Name   : timeserie_vari
# Author : Jorge Flores
# Date   : 
# Version:
# Aim    : 
# URL    : 
#=============================================================================#
timeserie_vari <- function(df, outpath, xlimmap = c(-100,-70), ylimmap = c(-30,0), zlimmap = c(0,15), VB = VB40, alive = T, vari = 'exSST'){
  
  if(alive == T){
    particle_index <- subset(df, df$age == 360 & df$knob >= VB)
  }else{
    particle_index <- subset(df, df$age == 360 & df$knob <  VB)
  }
  
  df <- subset(df, df$drifter %in% particle_index$drifter)
  col_index <- which(names(df) == vari)
  
  df <- tapply(df[,col_index], list(df$day), mean, na.rm = T)
  return(df)
}
#=============================================================================#
# END OF PROGRAM
#=============================================================================#