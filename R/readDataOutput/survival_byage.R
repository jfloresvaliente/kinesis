#=============================================================================#
# Name   : survival_byage
# Author : Jorge Flores
# Date   : 
# Version:
# Aim    : 
# URL    : 
#=============================================================================#
survival_byage <- function(df, Age = 360, VB = VB40){
  
  DF <- subset(df, df$TGL == 1)
  
  alive_index <- subset(DF, DF$age == Age & DF$knob >= VB)$drifter
  alive <- subset(DF, DF$drifter %in% alive_index)
  
  surviv <- tapply(alive$PA, list(alive$age), mean, na.rm = T)
  surviv <- c(100, surviv)

  assign(x = 'survival_byage', value = surviv, envir = .GlobalEnv)
}
#=============================================================================#
# END OF PROGRAM
#=============================================================================#