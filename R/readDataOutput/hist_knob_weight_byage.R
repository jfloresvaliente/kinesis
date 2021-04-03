#=============================================================================#
# Name   : hist_knob_weight_byage
# Author : Jorge Flores
# Date   : 
# Version:
# Aim    : 
# URL    : 
#=============================================================================#
hist_knob_weight_byage <- function(
   df
  # ,Age   = 360
  # ,VB    = VB40
  ,alive = T
  ){
  
  if(alive == T){
    DF <- subset(df, df$age == stepFinal & df$knob >= VB40 & df$TGL == 1)
    
    hist_knob   <- hist(DF$knob, plot = F, breaks = )
    hist_weight <- subset(alive, alive$age == Age)$Wweight
  }
  
  

  
  
  
  assign(x = 'hist_knob_byage'  , value = hist_knob  , envir = .GlobalEnv)
  assign(x = 'hist_weight_byage', value = hist_weight, envir = .GlobalEnv)
}
#=============================================================================#
# END OF PROGRAM
#=============================================================================#