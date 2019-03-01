nc_orderText <- NULL
for(month in 1:12) {
  nc_month <- NULL
  for(year in 1958:2008){
    nc_name <- paste0('roms6b_avg.Y', year,'.M',month,'.rl1b.nc')
    nc_month <- cbind(nc_month, nc_name)
  }
  nco_order <- 'ncea'
  nc_outname <- paste0('climatologyM', month, '.nc')
  nc_month <- cbind(nco_order, nc_month, nc_outname)
  
  nc_orderText <- rbind(nc_orderText, nc_month)
}
write.table(x = nc_orderText, file = paste0('G:/ROMS_SIMULATIONS/ROMS6B_VINCENT_SIMULATION/', 'climatology.txt'), sep = ' ', row.names = F, col.names = F)
