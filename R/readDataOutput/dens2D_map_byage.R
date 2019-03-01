#=============================================================================#
# Name   : dens2D_map_byage
# Author : Jorge Flores
# Date   : 
# Version:
# Aim    : 
# URL    : 
#=============================================================================#
dens2D_map_byage <- function(df, outpath, ages = c(1,360), range = c(0, 0.5),xlimmap = c(-100,-70), ylimmap = c(-30,0)){
  library(fields)
  library(ggplot2)
  for(i in 1:length(ages)){
    sub_df <- subset(df, df$age == ages[i] & df$TGL == 1)
    
    PNG <- paste0(outpath, 'dens2DMapAge', ages[i],'.png')
    map <- ggplot(data = sub_df, aes(x = lon, y = lat))
    map <- map +
      stat_bin_2d(bins = 1000)+

    #   # geom_point(data = sub_df, aes(x = lon, y = lat),colour ='black',size = .001)+
    #   # geom_density2d(data = sub_df, aes(x = lon, y = lat), size = 0.05)+
    #   # stat_density2d(data = sub_df, aes(x = lon, y = lat, fill = ..level.., alpha = ..level..), size = 0.01, geom = 'polygon')+
    #   stat_density2d(data = sub_df, aes(x = lon, y = lat, fill = ..level.., alpha = ..level..), size = 0.01, geom = 'polygon',binwidth = 0.01)+
      # scale_fill_gradient(low = 'blue', high = 'red', expression(Density))+
      scale_fill_gradientn(colours = tim.colors(64), expression(Count))+
      # scale_colour_gradientn(colours = tim.colors(64), limits = zlimmap, expression('Knob'))+
    #   # scale_alpha(range = c(0.5,0.5), guide = FALSE)+
    #   scale_alpha(guide = F) +
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

    # rf <- colorRampPalette(tim.colors(32))
    # h <- cbind(sub_df$lon, sub_df$lat)
    # h <- hexbin(h)
    # png(filename = PNG, width = 850, height = 850, res = 120)
    
    # a<-plot(h, colramp = rf, xlab = 'lon', ylab = 'lat', xlim = c(-80,-75))
    # map('worldHires', add=T, fill=T, col='gray')
    # dev.off()
    print(PNG); flush.console()
  }
}
#=============================================================================#
# END OF PROGRAM
#=============================================================================#