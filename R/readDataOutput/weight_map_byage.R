#=============================================================================#
# Name   : weight_map_byage
# Author : Jorge Flores
# Date   : 
# Version:
# Aim    : 
# URL    : 
#=============================================================================#
weight_map_byage <- function(df, outpath, ages = c(1,360),xlimmap = c(-100,-70), ylimmap = c(-30,0), zlimmap = c(0,15)){
  
  for(i in 1:length(ages)){
    sub_df <- subset(df, df$age == ages[i] & df$TGL == 1)
    
    PNG <- paste0(outpath, 'weightMapAge', ages[i],'.png')
    map <- ggplot(data = sub_df, aes(x = lon, y = lat))
    map <- map +
      geom_point(data = sub_df, aes(x = lon, y = lat, colour = Wweight), size = 1)+
      scale_colour_gradientn(colours = tim.colors(64), limits = zlimmap)+
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