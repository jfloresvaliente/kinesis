#=============================================================================#
# Name   : map_input_day
# Author : Jorge Flores
# Date   : 
# Version:
# Aim    : 
# URL    : 
#=============================================================================#
library(fields)
library(maps)
library(mapdata)

envipath <- 'D:/kinesis_escenarios_outputs/escenario/input/'
outpath <- 'D:/kinesis_escenarios_outputs/escenario/outM2/'
mes <- 2
duration <- 360

xlimmap <- c(-100,-70)
ylimmap <- c(-20,0)


# vari <- 'm'
# zlimmap <- c(0,4)

vari <- 't'
zlimmap <- c(12,30)

## -- No cambiar nada dede aqui ##
if(mes < 10) mes <- paste0('0', mes) else mes <- paste0(mes)

dateinit <- paste0(2000, mes)
# dates <- seq(as.Date('2000-01-03'), as.Date('2002-01-27'), by = '5 days')
# dates <- gsub(pattern = '-', replacement = '', x = dates)

# dateinit <- which(dates == paste0('2000', mes))


varfiles <- list.files(path = envipath, pattern = paste0(vari, dateinit), full.names = T)
fileinit <- list.files(path = envipath, pattern = paste0(vari, dateinit), full.names = T)[1]

varfiles <- list.files(path = envipath, pattern = paste0(vari, '.*\\.txt'), full.names = T)
fileindex <- which(varfiles == fileinit)

varfiles <- varfiles[fileindex:(fileindex+(duration/5))]

partfiles <- list.files(path = outpath, pattern = 'output', full.names = T)[seq(1, (duration+5), 5)]


mask <- as.matrix(read.table(paste0(envipath, 'mask_grid.csv'), sep = ';'))
mask[mask == 0] <- NA

dir.create(path = paste0(outpath, 'particlesEnvir/'), showWarnings = F)

iniday <- 0
for(i in 1:length(varfiles)){
  
  # Ambiente
  envi <- read.table(file = varfiles[i])
  colnames(envi) <- c('x', 'y', 'z')
  x <- as.numeric(levels(factor(envi[,1])))
  y <- as.numeric(levels(factor(envi[,2])))
  z <- matrix(data = envi[,3], nrow = length(x), ncol = length(y))*mask

  # Particulas
  part <- read.table(file = partfiles[i])

  # plot
  PNG <- paste0(outpath, 'particlesEnvir/', vari,iniday,'day.png')
  iniday <- iniday + 5
  png(file = PNG, height = 650, width = 650)
  par(mar = c(1,2,1,2), oma = c(2,1,.5,.5))
  image.plot(x,y,z, axes = F, ylim = ylimmap, xlim = xlimmap, zlim = zlimmap)
  map('worldHires', add=T, fill=T, col='gray')
  box(lwd = 2)
  axis(side = 1, at = seq(xlimmap[1], xlimmap[2], 5), labels = seq(xlimmap[1],xlimmap[2], 5),
       lwd = 2, lwd.ticks = 2, font.axis=4)
  axis(side = 2, at = seq(ylimmap[1], ylimmap[2], 5), labels = seq(ylimmap[1], ylimmap[2], 5),
       lwd = 2, lwd.ticks = 2, font.axis=4, las = 2)
  points(x = part[,1]-360, y = part[,2], pch = 19, cex = .2, col = 'black')
  grid()
  dev.off()
  print(PNG)
}









# 
# x11(); image.plot(x,y,z)



# PNG <- paste0(outpath, 'densityMapDay', days[i],'.png')
# map <- ggplot(data = envi, aes(x = x, y = y))
# map <- map +
#   # geom_point(data = sub_df, aes(x = lon, y = lat),colour ='black',size = .001)+
# 
#   scale_alpha(guide = F) +
#   labs(x = 'Longitude (W)', y = 'Latitude (S)') +
#   borders(fill='grey',colour='grey') +
#   coord_fixed(xlim = xlimmap, ylim = ylimmap, ratio = 2/2) +
#   theme(axis.text.x  = element_text(face='bold', color='black',
#                                     size=15, angle=0),
#         axis.text.y  = element_text(face='bold', color='black',
#                                     size=15, angle=0),
#         axis.title.x = element_text(face='bold', color='black',
#                                     size=15, angle=0),
#         axis.title.y = element_text(face='bold', color='black',
#                                     size=15, angle=90),
#         legend.text  = element_text(size=15),
#         legend.title = element_text(size=15))
# # if(!is.null(PNG)) ggsave(filename = PNG, width = 9, height = 9) else map
# print(PNG); flush.console()