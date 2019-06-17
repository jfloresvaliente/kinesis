library(fields)
library(maps)
library(mapdata)
dirpath <- 'D:/kinesis_escenarios_outputs/escenario/input/'

mask <- as.matrix(read.table(paste0(dirpath,'mask_grid.csv'), header = F, sep = ';'))
lon  <- as.matrix(read.table(paste0(dirpath,'lon_grid.csv'), header = F, sep = ';'))[,1]
lat  <- as.matrix(read.table(paste0(dirpath,'lat_grid.csv'), header = F, sep = ';'))[1,]

xrange <- seq(range(lon)[1]+5, range(lon)[2], 5)
yrange <- seq(range(lat)[1]+10, range(lat)[2], 10)
zrange <- c(0,1)

png(filename = "C:/Users/ASUS/Desktop/layoutplot1.png", width = 1550, height = 1550, res = 120)

x_long <- 6
y_long <- 5
mat <- matrix(1:12, ncol= 4, byrow = T)
layout(mat = mat, widths = c(lcm(x_long), rep(lcm(x_long-1),2), lcm(x_long)),
       heights = c(lcm(y_long), lcm(y_long-1), lcm(y_long)))
cx <- 1/cm(1.5)

for(i in 1:12){
  if(i == 1)            par(mai = c(0, cx, cx, 0 ))
  if(i == 2 | i == 3)   par(mai = c(0, 0 , cx, 0 ))
  if(i == 4)            par(mai = c(0, 0 , cx, cx))
  if(i == 5)            par(mai = c(0, cx, 0 , 0 ))
  if(i == 6 | i == 7)   par(mai = c(0, 0 , 0 , 0 ))
  if(i == 8)            par(mai = c(0, 0 , 0 , cx))
  if(i == 9)            par(mai = c(cx,cx, 0 , 0 ))
  if(i == 10 | i == 11) par(mai = c(cx, 0, 0 , 0 ))
  if(i == 12)           par(mai = c(cx, 0, 0 , cx))
  
  image(lon,lat,mask,col = tim.colors(64), axes = F, zlim = zrange)
  mtext(text = paste('PLOT', i), side = 3, line = -4, adj = 0.5, font = 2)
  box(lwd=.5, col='black')
  # box("figure", lwd=.5, col='black')
  if(i == 9 | i == 10 | i == 11 | i == 12)  axis(side = 1, at = xrange, labels = xrange) else axis(side = 1, labels = F)
  if(i == 1 | i == 5 | i == 9)              axis(side = 2, at = yrange, labels = yrange, las = 2)
  # axis(side = 3, labels = F)
  # axis(side = 4, labels = F)
  
  print(par('pin'))
}
image.plot(legend.only=TRUE, zlim = zrange)
dev.off()
