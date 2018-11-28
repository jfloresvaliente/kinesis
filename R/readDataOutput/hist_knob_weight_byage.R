#=============================================================================#
# Name   : hist_knob_weight_byage
# Author : Jorge Flores
# Date   : 
# Version:
# Aim    : 
# URL    : 
#=============================================================================#
hist_knob_weight_byage <- function(df, Age = 360, VB = VB40){
  
  DF <- subset(df, df$TGL == 1)
  
  alive_index <- subset(DF, DF$age == Age & DF$knob >= VB)$drifter
  alive <- subset(DF, DF$drifter %in% alive_index)
  
  hist_knob   <- subset(alive, alive$age == Age)$knob
  hist_weight <- subset(alive, alive$age == Age)$Wweight
  
  assign(x = 'hist_knob_byage'  , value = hist_knob  , envir = .GlobalEnv)
  assign(x = 'hist_weight_byage', value = hist_weight, envir = .GlobalEnv)
}
#=============================================================================#
# END OF PROGRAM
#=============================================================================#