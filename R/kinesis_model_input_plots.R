#===============================================================================
# Name   : kinesis_model_input_plots
# Author : Jorge Flores
# Date   : 
# Version:
# Aim    : Make boxplots, error_bar plots & histograms for KINESIS_MODEL' input
# URL    : 
#===============================================================================

dirpath = '/run/media/marissela/JORGE_OLD/ROMS_SIMULATIONS/ROMS6B_VINCENT_SIMULATION/viejo/' # input directory / where images will be saved

vari = 'u'            # t=temperature, c=chlorophyll, u&v=velocity currents
year = c(2001:2002)   # setup years to plot
months = c('01','02','03','04','05','06','07','08','09','10','11','12')
ylim = c(-0.25,0.25)  # limits for y-axis
interval = 2          # intervals for y-axis labels

# mask = as.matrix(read.csv(paste0(dirpath, 'mask_grid.csv'), header = T, sep = '')); class(mask); dim(mask)
# mask[mask[,]==0] = NA
mask <- as.vector(t(mask))

## Get values for vari
var.values = NULL
for(i in year){
  
  # Loop for get filenames
  for(j in months){
    a = i ; b = j
    pattern = paste0(vari,a,b)
    input.files = list.files(dirpath,pattern, full.names = T)
    
    # Loop for get variable values
    month.vari = NULL
    for(k in 1:length(input.files)){
      dat = read.table(input.files[k],header = F); dim(dat)
      print(input.files[k]); flush.console()
      # Subset of a domain close to Peru
      # dat = cbind(dat,mask); dim(dat)
      # dat = subset(dat, dat[,1] >= -85 & dat[,2] <= -4 & dat[,2] >= -18 & dat[,4]==1)
      dat = subset(dat, dat[,1] >= -85 & dat[,2] <= -4 & dat[,2] >= -18 & dat[,3]!=0)
      dat = dat[,3]
      month.vari = c(month.vari,dat)
    }
    
    # data.end = month.vari
    year.in  = rep(a,length(month.vari))
    month.in = rep(as.numeric(b),length(month.vari))
    month.mat = cbind(year.in,month.in,month.vari)
    var.values = rbind(var.values,month.mat)
  }
}

mon.factor = as.factor(var.values[,2])
mon.factor = levels(mon.factor); mon.factor = as.numeric(mon.factor)

## ## ## ## ## ## ## ## PLOTS ## ## ## ## ## ## ## ## 

## BOXPLOT ##
png(paste0(dirpath,vari,'_','boxplot.png'),width = 1050,height = 1050,res=120)
# par(mfrow=c(length(year),1))
par(mfrow=c(2,2))
for(i in year){
  names = NULL
  for(j in months){
    month.name = paste0(i,'-',months)
  }
  names = c(names,month.name)
  dat2plot = subset(var.values, var.values[,1]==i)
  draph = boxplot(dat2plot[,3]~dat2plot[,2], names = names, las = 2,ylab='',
                  ylim=ylim,yaxt='n', ann=FALSE, notch = T)
  abline(h=seq(ylim[1],ylim[2],interval),lty=rep(2,25))
  mtext(i,3,line=-2,cex=2)
  # mtext('Cold period',3,line=-2,cex=2)
  mtext('SST (°C)',side = 2,line= 2,cex=0.7)
  axis(2, at=seq(ylim[1],ylim[2],interval),las=2)
  abline(h=0)
}
dev.off()


## ERROR-BAR PLOT ##
# png(paste0(dirpath,vari,'_','sd_plot.png'),width = 1050,height = 1050,res=120)
par(mfrow=c(length(year),1))
# par(mfrow=c(2,2))
mat2 = NULL
for(i in year){
  names = NULL
  mat = NULL
  for(j in mon.factor){
    month.name = paste0(year,'-',months)
    dat2plot = subset(var.values, var.values[,1]==i & var.values[,2]==j)
    dat2plot = dat2plot[,3]
    
    x  = dat2plot; n  = length(x); m  = mean(x); s  = sd(x)
    a  = 0.05 # confianza 
    tt = -qt(a/2,n-1)
    ee = sd(x)/sqrt(n)  # error estandar, ES diferente a desviacion estandar
    e  = tt*ee          # margen de error
    d  = e/m            # error relativo, dice que el intervalo de confianza es un porcentaje del valor
    # li = m-e            # limite superior
    # ls = m+e            # limite inferior
    li = m-s            # limite superior
    ls = m+s            # limite inferior
    res = cbind(m , li , ls, i,j)
    mat = rbind(mat , res)
  }
  names = c(names,month.name)
  
  draph = plot(mat[,5],mat[,1],type='l',ylim=ylim,yaxt='n',xaxt='n', ann=FALSE,ylab='')
  arrows(1:length(mat[,1]) , y0= mat[,2], 1:length(mat[,1]), y1=mat[,3],code=3, angle=90, length=0.1)
  abline(h=seq(ylim[1],ylim[2],interval),lty=rep(2,25))
  mtext(i,3,line=-2,cex=2)
  mtext('SST (°C)',side = 2,line= 2,cex=0.7)
  axis(1, at = mat[,5],labels = names,las=2)
  axis(2, at=seq(ylim[1],ylim[2],interval),las=2)
  
  mat2 = rbind(mat2,mat)
  
}
# dev.off()


## HISTOGRAM ##
# range = c(round(min(var.values[,3]))-0.5,round(max(var.values[,3]))+0.5)
# range = c(14,30)
# if(length(year) >= 1){
#   for(i in year){
#     # png(paste0(dirpath,vari,'_',i,'_','hist_plot.png'),width = 1050,height = 1050,res=120)
#     par(mfrow=c(4,3),mar=c(2.5,3.5,2.5,1.5))
#     for(j in mon.factor){
#       
#       month.name = paste0(i,'-',months[j])
#       dat2plot = subset(var.values, var.values[,1]==i & var.values[,2]==j)
#       dat2plot = dat2plot[,3]
#       graph=hist(dat2plot, breaks = seq(range[1],range[2],0.25), freq = F, ylim=c(0,0.35),main='',xlab='',ylab='')
#       # lines(density(dat2plot),col='red',lwd=2)
#       mtext(paste0(i,'-',months[j]),side = 3,line=-1)
#       mtext('Density',side = 2,line= 2,cex=0.7)
#     }
#     # dev.off()
#   }
# }

### END OF PROGRAM ###

