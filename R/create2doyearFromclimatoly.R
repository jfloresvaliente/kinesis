dirpath <- 'G:/ROMS_SIMULATIONS/ROMS6B_VINCENT_SIMULATION/climatologyM/'

files <- list.files(path = dirpath, pattern = '.txt', full.names = T, recursive = T)

for(i in 1:length(files)){
  dat <- read.table(files[i])
  new_name <- sub(pattern = 2000, replacement = 2001, x = files[i])
  write.table(x = dat, file = new_name, row.names = F, col.names = F)
  print(files[i])
}
