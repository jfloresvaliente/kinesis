#===============================================================================
# Name   : kinesis_model_temp_particle_location
# Author : Jorge Flores
# Date   : 
# Version:
# Aim    : Plots temperature mean at particle position for Kinesis model
# URL    : 
#===============================================================================
dirpath = 'G:/kinesis_avances/long_run/run1/' # directory of outputs / where images will be saved

years = 1995:1997
file.names = NULL
for(i in years){
  files = list.files(paste0(dirpath,i,'/'),pattern = 'output', full.names = T)
  file.names = c(file.names,files)
}

by = 30
dates = seq(as.Date('1995-08-01'),length.out = length(file.names),by='days')
dates = dates[seq(1,length(dates),by=by)]
dates = format(dates, '%d/%b/%y')
file.names = file.names[seq(1,length(file.names),by=by)]

## DO NOT CHANGE ANYTHING AFTER HERE!!
mat = NULL
for(i in 1:length(file.names)){
  
  dat = read.table(file.names[i])
  
  sub = dat[,3]
  
  x  = sub; n  = length(x); m  = mean(x); s  = sd(x)
  a  = 0.05 # confianza 
  tt = -qt(a/2,n-1)
  ee = sd(x)/sqrt(n)  # error estandar, ES diferente a desviacion estandar
  e  = tt*ee          # margen de error
  d  = e/m            # error relativo, dice que el intervalo de confianza es un porcentaje del valor
  li = m-e            # limite superior
  ls = m+e            # limite inferior
  # li = m-s            # limite superior
  # ls = m+s            # limite inferior
 
  res = cbind(m , li , ls)
  mat = rbind(mat , res)
}

png(paste0(dirpath, 'mean_temp_particle_position.png'), width = 950, height = 950, res=120)
ylim = c(20,28)
plot(1:length(mat[,1]),rev(mat[,1]), type='l', ylim = ylim ,xaxt='n',
     xlab='', ylab='')
axis(1, at=1:length(dates), labels=FALSE)
text(x=1:length(dates), y = par()$usr[3] - 0.05*(par()$usr[4]-par()$usr[3]),
     labels=dates, srt=45, adj=1, xpd=TRUE, cex=1)
arrows(1:length(mat[,1]) , y0= rev(mat[,2]), 1:length(mat[,1]), y1=rev(mat[,3]),
       code=3, angle=90, length=0.1)
mtext('Mean temperature (T°) in each particles position', side=3, line= -1)

dev.off()

