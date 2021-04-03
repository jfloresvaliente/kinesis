#=============================================================================#
# Name   : --
# Author : Jorge Flores
# Date   : 
# Version:
# Aim    : 
# URL    : 
#=============================================================================#
dirpath    <- 'C:/Users/jflores/Documents/JORGE/colaboradores/Takeshi/out/'
stepFinal  <- 360

library(ggplot2)
library(fields)
library(hexbin)
library(gridExtra)

outpathFigures <- paste0(dirpath, 'figures/')
dir.create(outpathFigures, showWarnings = F, recursive = T)

#========== Load functions and packages ==========#
source('R/readDataOutput/load_packages_functions.R')

#========== Get VonBertalanffy curve ==========#
VB_curve(day = stepFinal)

#========== Load data from KINESIS model outputs ==========#
load(paste0(dirpath, 'df.RData'))

xlim  <- c(-90, -70) # Londitude
ylim  <- c(-22, 0)   # Latitude
bin_x <- .25
bin_y <- .25
ggname   <- paste0(dirpath, 'grid_arrange', bin_x, '.png')
zlim1 <- c(0,50)
zlim2 <- c(10,15)
zlim3 <- c(5,21)
#=============================================================================#
# stat_bin_hex: count number of particles by pixel
#=============================================================================#
df <- subset(df, df$age == stepFinal & df$knob >= VB40 & df$TGL == 1)

p1 <- ggplot(data = df)+
  stat_bin_hex(data = df, mapping = aes(x = lon, y = lat), binwidth = c(bin_x, bin_y))+
  scale_fill_gradientn(colours = tim.colors(64), limits = zlim1, na.value = '#800000')+
  labs(x = 'Longitude (W)', y = 'Latitude (S)', fill = 'Recruited individuals [#]') +
  borders(fill='grey',colour='grey') +
  coord_fixed(xlim = xlim, ylim = ylim)+
  # annotate(geom='text', x = -74.5, y = -0.3, color = 'black', size = 3, hjust = 0.5, label = 'No mortality')+
  theme(axis.text.x  = element_text(face='bold', color='black', size=7, angle=0),
        axis.text.y  = element_text(face='bold', color='black', size=7, angle=0),
        axis.title.x = element_text(face='bold', color='black', size=7, angle=0),
        axis.title.y = element_text(face='bold', color='black', size=7, angle=90),
        legend.text  = element_text(size=7),
        legend.title = element_text(size=7, face= 'bold'),
        legend.position   = c(0.8, 0.65),
        legend.background = element_rect(fill=adjustcolor( 'red', alpha.f = 0), size=0.3, linetype='solid'))
ggname <- paste0(dirpath, 'figures/alive_count.png')
ggsave(filename = ggname, plot = last_plot(), width = 8, height = 8)

p2 <- ggplot(data = df)+
  stat_summary_hex(data = df, mapping = aes(x = lon, y = lat, z = knob), fun = mean, binwidth = c(bin_x, bin_y))+
  scale_fill_gradientn(colours = tim.colors(64), limits = zlim2)+#, na.value = '#800000')+
  labs(x = 'Longitude (W)', y = 'Latitude (S)', fill = 'Knob [cm]') +
  borders(fill='grey',colour='grey') +
  coord_fixed(xlim = xlim, ylim = ylim)+
  # annotate(geom='text', x = -74.5, y = -0.3, color = 'black', size = 3, hjust = 0.5, label = 'Constant\nMortality')+
  theme(axis.text.x  = element_text(face='bold', color='black', size=7, angle=0),
        axis.text.y  = element_text(face='bold', color='black', size=7, angle=0),
        axis.title.x = element_text(face='bold', color='black', size=7, angle=0),
        axis.title.y = element_text(face='bold', color='black', size=7, angle=90),
        legend.text  = element_text(size=7),
        legend.title = element_text(size=7, face= 'bold'),
        legend.position   = c(0.8, 0.65),
        legend.background = element_rect(fill=adjustcolor( 'red', alpha.f = 0), size=0.3, linetype='solid'))
ggname <- paste0(dirpath, 'figures/alive_mean_knob.png')
ggsave(filename = ggname, plot = last_plot(), width = 8, height = 8)

p3 <- ggplot(data = df)+
  stat_summary_hex(data = df, mapping = aes(x = lon, y = lat, z = Wweight), fun = mean, binwidth = c(bin_x, bin_y))+
  scale_fill_gradientn(colours = tim.colors(64), limits = zlim3)+#, na.value = '#800000')+
  labs(x = 'Longitude (W)', y = 'Latitude (S)', fill = 'Wet weight [g]') +
  borders(fill='grey',colour='grey') +
  coord_fixed(xlim = xlim, ylim = ylim)+
  # annotate(geom='text', x = -74.5, y = -0.3, color = 'black', size = 3, hjust = 0.5, label = 'Constant\nMortality')+
  theme(axis.text.x  = element_text(face='bold', color='black', size=7, angle=0),
        axis.text.y  = element_text(face='bold', color='black', size=7, angle=0),
        axis.title.x = element_text(face='bold', color='black', size=7, angle=0),
        axis.title.y = element_text(face='bold', color='black', size=7, angle=90),
        legend.text  = element_text(size=7),
        legend.title = element_text(size=7, face= 'bold'),
        legend.position   = c(0.8, 0.65),
        legend.background = element_rect(fill=adjustcolor( 'red', alpha.f = 0), size=0.3, linetype='solid'))
ggname <- paste0(dirpath, 'figures/alive_mean_weight.png')
ggsave(filename = ggname, plot = last_plot(), width = 8, height = 8)


