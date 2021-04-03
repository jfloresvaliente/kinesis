#=============================================================================#
# Name   : knob_weight_byage
# Author : Jorge Flores
# Date   : 
# Version:
# Aim    : 
# URL    : 
#=============================================================================#
knob_weight_byday <- function(
  df    = df
  # ,age   = 360
  # ,VB    = VB40
  ,alive = T
){
  #============ ============ Arguments ============ ============#
  # df    = data frame with data of output kinesis
  # day   = day to plot in the map
  # VB    = length of Von Bertalanffy 
  # alive = if TRUE, plot the alive particles
  #============ ============ Arguments ============ ============#
  
  if(alive == T){
    index <- subset(df, df$age == stepFinal & df$knob >= VB40 & df$TGL == 1)$drifter
    DF    <- subset(df, df$drifter %in% index & df$age %in% 0:stepFinal)
    outname1 <- 'knob_byage_alive'
    outname2 <- 'weight_byage_alive'
  }else{
    index <- subset(df, df$age == stepFinal & df$knob < VB40)$drifter
    DF    <- subset(df, df$drifter %in% index & df$age %in% 0:stepFinal)
    outname1 <- 'knob_byage_nonalive'
    outname2 <- 'weight_byage_nonalive'
  }
  
  mean_knob   <- tapply(DF$knob   , list(DF$age), mean, na.rm = T)
  mean_weight <- tapply(DF$Wweight, list(DF$age), mean, na.rm = T)
  
  sd_knob   <- tapply(DF$knob   , list(DF$age), sd, na.rm = T)
  sd_weight <- tapply(DF$Wweight, list(DF$age), sd, na.rm = T)
  
  knob   <- list(mean_knob, sd_knob)
  names(knob) <- c('mean', 'sd')
  
  weight <- list(mean_weight, sd_weight)
  names(weight) <- c('mean', 'sd')
  
  assign(x = outname1, value = knob  , envir = .GlobalEnv)
  assign(x = outname2, value = weight, envir = .GlobalEnv)
}
#=============================================================================#
# END OF PROGRAM
#=============================================================================#