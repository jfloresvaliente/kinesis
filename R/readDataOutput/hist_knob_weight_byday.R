#=============================================================================#
# Name   : hist_knob_weight_byday
# Author : Jorge Flores
# Date   : 
# Version:
# Aim    : 
# URL    : 
#=============================================================================#
hist_knob_weight_byday <- function(df, Day = 360, VB = VB40){
  
  DF <- subset(df, df$TGL == 1)
  
  alive_index <- subset(DF, DF$day == Day & DF$knob >= VB)$drifter
  alive <- subset(DF, DF$drifter %in% alive_index)
  
  hist_knob   <- subset(alive, alive$day == Day)$knob
  hist_weight <- subset(alive, alive$day == Day)$Wweight
  
  assign(x = 'hist_knob_byday'  , value = hist_knob  , envir = .GlobalEnv)
  assign(x = 'hist_weight_byday', value = hist_weight, envir = .GlobalEnv)
}
#=============================================================================#
# END OF PROGRAM
#=============================================================================#