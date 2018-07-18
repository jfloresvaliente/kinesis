#===============================================================================
# Name   : kinesis_rename_input
# Author : Jorge Flores - Jorge Tam
# Date   : 
# Version:
# Aim    : 
# URL    : 
#===============================================================================

# Dirpath with Kinesis input files to rename
dirpath  <- 'G:/ROMS_SIMULATIONS/ROMS6B_VINCENT_SIMULATION/year1995/zlev40/'
year_in  <- 1995 # Initial year input
year_on  <- 1995 # End year input
variable <- c('c','t','u','v')

#===============================================================================
# DO NOT CHANGE ANYTHING AFTER HERE
#===============================================================================

initial_date  <- as.Date(paste0(year_in,'-01-03'))
filenames     <- list.files(path = dirpath, pattern = '.txt', full.names = T)
length_date   <- (year_on - year_in + 1) * 365/5
date          <- seq(from = initial_date, by = '5 days', length.out = length_date)
date          <- gsub(pattern = '-', replacement = '', date)

for(i in variable){
  vars      <- i
  date_ini  <- 1
  for(year in year_in:year_on){
    
    for(month in 1:12){
      
      if (month == 12){index = 7}else{index=6}
      
      for(j in 1:index){
        old_name <- paste0(dirpath, year, '_',month, '_', vars, j, '.txt')
        new_name <- paste0(dirpath, vars, date[date_ini], '.txt')
        file.rename(from=old_name, to=new_name)
        date_ini <- date_ini + 1
      }
    }
  }
}

# Store the dates used in .csv file
write.table(as.numeric(date), file=paste0(dirpath, 'dates.csv'), row.names = F, col.names = F)
#===============================================================================
# END OF PROGRAM
#===============================================================================
