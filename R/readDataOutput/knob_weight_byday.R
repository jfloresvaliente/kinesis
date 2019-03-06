#=============================================================================#
# Name   : knob_weight_byday
# Author : Jorge Flores
# Date   : 
# Version:
# Aim    : 
# URL    : 
#=============================================================================#
knob_weight_byday <- function(
  df
  ,day = 360
  ,VB = VB40
  ,alive = F
  ){
  #============ ============ Arguments ============ ============#
  # df = data frame with data of output kinesis
  # day = day to plot in the map
  # VB = length of Von Bertalanffy 
  # alive = if TRUE, plot the alive particles
  #============ ============ Arguments ============ ============#
  
  DF <- subset(df, df$TGL == 1)
  
  if(alive == T){
    alive_index <- subset(DF, DF$day == day & DF$knob >= VB)$drifter
    DF <- subset(DF, DF$drifter %in% alive_index)
    outname1 <- 'mean_knob_byday_alive'
    outname2 <- 'mean_weight_byday_alive'
  }else{
    outname1 <- 'mean_knob_byday'
    outname2 <- 'mean_weight_byday'
  }

  mean_knob   <- tapply(DF$knob   , list(DF$day), mean, na.rm = T)
  mean_weight <- tapply(DF$Wweight, list(DF$day), mean, na.rm = T)
  
  assign(x = outname1, value = mean_knob  , envir = .GlobalEnv)
  assign(x = outname2, value = mean_weight, envir = .GlobalEnv)
}
#=============================================================================#
# END OF PROGRAM
#=============================================================================#