#=============================================================================#
# Name   : 
# Author : Jorge Flores
# Date   : 
# Version:
# Aim    :
# URL    : 
#=============================================================================#
# PLOT INITIAL POSITIONS FOR PARTICLES IN KINESIS MODEL

## STEP 1: PLOT A MAP
# Establish the working environment were the map will be save
dirpath = 'F:/' 

# Countries to be plotted
countries = c('peru','bolivia','brazil','ecuador','colombia','chile')

# Named of the plot
name = 'map_peru'

# Limits of the plot
xmin = -84
xmax = -68
ymin = -20
ymax = 0.0
interval = 2 # interval to be plotted degrees in the axis

library(maps)
library(mapdata)

tiff(filename = paste0(dirpath,name,'.tiff'), width = 950, height = 950, res = 120)
par(mar = c(3,3,1,1), mai = c(1,1,1,1), lwd = 2)
my_map = map('worldHires' , resolution=0 , xlim=c(xmin,xmax) , ylim=c(ymin,ymax),
             col='gray90' , fill=TRUE)

axis(1, at=seq(xmin,xmax, interval), labels=seq(xmin,xmax, interval), lwd= 2 ,lwd.ticks = 2, font=2)
axis(2, at=seq(ymin,ymax, interval), labels=seq(ymin,ymax, interval), lwd= 2 ,lwd.ticks = 2, font=2, las = 2)
axis(3, at=seq(xmin,xmax, interval), lwd.ticks=0, lwd=2, labels=FALSE) 
axis(4, at=seq(ymin,ymax, interval), lwd.ticks=0, lwd=2, labels=FALSE) 

mtext('Longitude', 1, line = 2.5 , cex= 2)
mtext('Latitude' , 2, line = 2.5 , cex= 2)

### OBTENER LOS PUNTOS DE LINEA DE COSTA A PATIR DEL MAPA
lon = my_map$x
lat = my_map$y
positions = cbind(lon,lat)

a = subset(positions, positions[,2]<= -6 & positions[,2]>= -17 & positions[,1]<= -74.1)
b = subset(positions, positions[,2]<= -12 & positions[,1]> -74.1 & positions[,1]<= -72.3)
c = rbind(a,b)

indexes = seq(1, length.out = 100, by = round(length(c[,1])/100))
c = c[indexes,]
points(c[,1],c[,2], type='p', cex=0.01, pch=19, col='red',bg='red')
# points(b[,1],b[,2], type='p', cex=0.01, pch=19, col='blue',bg='blue')

# ## STEP 2: PLOT INITIAL POSITIONS LIKE A POINTS
# dat = read.table('set01.csv',sep=',')
# dat = dat[1:86,]
# points(dat[,1]-360,dat[,2], type = 'p', cex=0.01, pch=19, col='red',bg='red')
# 
mtext('PERU', 1, line= -22, cex= 3) # to draw name into the map

dev.off()

### New Points off coast

d1 = cbind(c[,1]-0.30, c[,2])
d2 = cbind(c[,1]-0.40, c[,2])
d  = rbind(d1,d2); d = cbind(d, rep(1,times=length(d[,1])))

e1 = cbind(c[,1]-1.00, c[,2])
e2 = cbind(c[,1]-1.25, c[,2])
e  = rbind(e1,e2); e = cbind(e, rep(1,times=length(e[,1])))

# win.metafile(filename = paste0(dirpath,name,'_new','.emf'), width = 8, height = 8, pointsize = 12)
tiff(filename = paste0(dirpath,name,'_new','.tiff'), width = 950, height = 950, res =120)
par(mar = c(3,3,1,1), mai = c(1,1,1,1), lwd = 2)
my_map = map('worldHires' , resolution=0 , xlim=c(xmin,xmax) , ylim=c(ymin,ymax),
             col='gray90' , fill=TRUE)

axis(1, at=seq(xmin,xmax, interval), labels=seq(xmin,xmax, interval), lwd= 2 ,lwd.ticks = 2, font=2)
axis(2, at=seq(ymin,ymax, interval), labels=seq(ymin,ymax, interval), lwd= 2 ,lwd.ticks = 2, font=2, las = 2)
axis(3, at=seq(xmin,xmax, interval), lwd.ticks=0, lwd=2, labels=FALSE) 
axis(4, at=seq(ymin,ymax, interval), lwd.ticks=0, lwd=2, labels=FALSE) 

mtext('Longitude', 1, line = 2.5 , cex= 2)
mtext('Latitude' , 2, line = 2.5 , cex= 2)

# points(c[,1],c[,2], type='p', cex=0.01, pch=19, col='red',bg='red')
points(d[,1],d[,2], type='p', cex=0.01, pch=19, col='blue',bg='blue')
points(e[,1],e[,2], type='p', cex=0.01, pch=19, col='green',bg='green')
mtext('PERU', 1, line= -22, cex= 3) # to draw name into the map

legend('bottomleft', c('Anchovy', 'Sardine'), bty='n', pch=c(19,19), col=c('blue','green'))
dev.off()

d = cbind(round((d[,1]+360), digits = 6), round(d[,2],digits = 6), d[,3])
e = cbind(round((e[,1]+360), digits = 6), round(e[,2],digits = 6), e[,3])

write.table(d, paste0(dirpath,'anchovy_pos.csv'), row.names = F, col.names = F, sep = ' ')
write.table(e, paste0(dirpath,'sardine_pos.csv'), row.names = F, col.names = F, sep = ' ')
#=============================================================================#
# END OF PROGRAM
#=============================================================================#