init <- Sys.time()
source('F:/GitHub/kinesis/R/kinesis_regrid_input.R')
dirpath <- 'G:/ROMS_SIMULATIONS/ROMS6B_VINCENT_SIMULATION/japonForcing/zlev1/'

vars <- c('z')
for(i in vars){
  kinesis_regrid_input(dirpath,i)
}
endit <- Sys.time()
print(endit - init)
