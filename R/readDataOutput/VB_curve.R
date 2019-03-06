#=============================================================================#
# Name   : VB_curve
# Author : Jorge Flores
# Date   : 
# Version:
# Aim    : 
# URL    : 
#=============================================================================#
VB_curve <- function(Linf = 20.5, k = 0.86, t0 = -0.14, day = 360){
  
  # Get VB limits
  # VB - (Marzloff et all 2009)
  # Linf <- 20.5
  # k    <- 0.86
  # t0   <- -0.14
  
  t_serie <- 1:(365*10)/365
  L0   <- Linf * (1 - exp(-k*(t_serie-t0)))
  
  # x11();plot(t_serie, L0, type = 'l', yaxs = 'i', xaxs = 'i')
  # abline(v = 1)
  
  per40 <- L0[day]
  per40 <- per40 - (per40 * 40)/100 # Regla del 40%
  assign(x = 'VB40', value = per40, envir = .GlobalEnv)
}
#=============================================================================#
# END OF PROGRAM
#=============================================================================#