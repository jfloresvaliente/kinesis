#=============================================================================#
# Name   : dens2D_map_byday
# Author : Jorge Flores
# Date   : 
# Version:
# Aim    : 
# URL    : 
#=============================================================================#
dens2D_map_byday <- function(
  df
  ,outpath
  ,days = c(1,360)
  ,xlimmap = c(-100,-70)
  ,ylimmap = c(-30,0)
  ,zlimmap = c(0,350)
  ,VB = VB40
  ,alive = F
  ,bins = c(2000,2000)
){
  #============ ============ Arguments ============ ============#
  # df = data frame with data of output kinesis
  # days = days to plot in the map
  # xlimmap = X domain of map
  # ylimmap = Y domain of map
  # zlimmap = Z domain for colour bar in map
  # VB = length of Von Bertalanffy 
  # alive = if TRUE, plot the alive particles
  #============ ============ Arguments ============ ============#
  
  if(alive == T){
    alive_index <- subset(df, df$age == 360 & df$knob >= VB)
    df <- subset(df, df$drifter %in% alive_index$drifter)
    outname <- 'dens2DMapDayAlive'
  }else{
    outname <- 'dens2DMapDay'
  }
  
  for(i in 1:length(days)){
    sub_df <- subset(df, df$day == days[i] & df$TGL == 1)
    
    PNG <- paste0(outpath, outname, days[i],'.png')
    map <- ggplot(data = sub_df, aes(x = lon, y = lat))
    map <- map +
      stat_bin_hex(bins = bins)+
      scale_fill_gradientn(colours = tim.colors(64), limits = zlimmap, expression(Count))+
      labs(x = 'Longitude (W)', y = 'Latitude (S)') +
      borders(fill='grey',colour='grey') +
      coord_fixed(xlim = xlimmap, ylim = ylimmap, ratio = 2/2) +
      theme(axis.text.x  = element_text(face='bold', color='black', size=15, angle=0),
            axis.text.y  = element_text(face='bold', color='black', size=15, angle=0),
            axis.title.x = element_text(face='bold', color='black', size=15, angle=0),
            axis.title.y = element_text(face='bold', color='black', size=15, angle=90),
            legend.text  = element_text(size=15),
            legend.title = element_text(size=15, face= 'bold'),
            legend.position   = c(0.92, 0.9),
            legend.background = element_rect(fill=adjustcolor( 'red', alpha.f = 0), size=0.5, linetype='solid'))
    if(!is.null(PNG)) ggsave(filename = PNG, width = 9, height = 9) else map
    print(PNG); flush.console()
  }
}
#=============================================================================#
# END OF PROGRAM
#=============================================================================#