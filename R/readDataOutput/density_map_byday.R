#=============================================================================#
# Name   : density_map_byday
# Author : Jorge Flores
# Date   : 
# Version:
# Aim    : 
# URL    : 
#=============================================================================#
density_map_byday <- function(df, outpath, days = c(1,360), range = c(0, 0.5),xlimmap = c(-100,-70), ylimmap = c(-30,0)){

  for(i in 1:length(days)){
    sub_df <- subset(df, df$day == days[i] & df$TGL == 1)
    
    PNG <- paste0(outpath, 'densityMapDay', days[i],'.png')
    map <- ggplot(data = sub_df, aes(x = lon, y = lat))
    map <- map +
      # geom_point(data = sub_df, aes(x = lon, y = lat),colour ='black',size = .001)+
      geom_density2d(data = sub_df, aes(x = lon, y = lat), size = 0.05)+
      stat_density2d(data = sub_df, aes(x = lon, y = lat, fill = ..level.., alpha = ..level..), size = 0.01, geom = 'polygon')+
      scale_fill_gradient(low = 'blue', high = 'red',expression(Density), limits = c(0,0.05))+
      scale_alpha(range = range, guide = FALSE)+
      labs(x = 'Longitude (W)', y = 'Latitude (S)') +
      borders(fill='grey',colour='grey') +
      coord_fixed(xlim = xlimmap, ylim = ylimmap, ratio = 2/2) +
      theme(axis.text.x  = element_text(face='bold', color='black',
                                        size=15, angle=0),
            axis.text.y  = element_text(face='bold', color='black',
                                        size=15, angle=0),
            axis.title.x = element_text(face='bold', color='black',
                                        size=15, angle=0),
            axis.title.y = element_text(face='bold', color='black',
                                        size=15, angle=90),
            legend.text  = element_text(size=15),
            legend.title = element_text(size=15))
    if(!is.null(PNG)) ggsave(filename = PNG, width = 9, height = 9) else map
    print(PNG); flush.console()
  }
}
#=============================================================================#
# END OF PROGRAM
#=============================================================================#