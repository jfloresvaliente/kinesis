#=============================================================================#
# Name   : knob_weight_byday
# Author : Jorge Flores
# Date   : 
# Version:
# Aim    : 
# URL    : 
#=============================================================================#
knob_weight_byday <- function(df, Day = 360, VB = VB40){
  
  DF <- subset(df, df$TGL == 1)
  
  alive_index <- subset(DF, DF$day == Day & DF$knob >= VB)$drifter
  alive <- subset(DF, DF$drifter %in% alive_index)

  mean_knob   <- tapply(alive$knob   , list(alive$day), mean, na.rm = T)
  mean_weight <- tapply(alive$Wweight, list(alive$day), mean, na.rm = T)
  
  assign(x = 'mean_knob_byday'  , value = mean_knob  , envir = .GlobalEnv)
  assign(x = 'mean_weight_byday', value = mean_weight, envir = .GlobalEnv)
}
#=============================================================================#
# END OF PROGRAM
#=============================================================================#