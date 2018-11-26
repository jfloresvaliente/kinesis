library(ggplot2)
library(fields)
library(mapdata)
library(raster)
library(mgcv)

source('/home/jtam/Documents/kinesis_GITHUB/R/readDataOutput.R')
source('/home/jtam/Documents/kinesis_GITHUB/R/MapParticlesByDay.R')
source('/home/jtam/Documents/kinesis_GITHUB/R/MapParticlesByAge.R')
source('/home/jtam/Documents/kinesis_GITHUB/R/density_map_byday.R')
source('/home/jtam/Documents/kinesis_GITHUB/R/density_map_byage.R')
source('/home/jtam/Documents/kinesis_GITHUB/R/VB_curve.R')
VB_curve()


dirpath <- '/home/jtam/Documents/case4/escenario/out/'
nfiles  <- 360 + 31
max_paticles <- 5880

df <- readDataOutput(dirpath = dirpath, max_paticles = max_paticles, nfiles = nfiles); dim(df)
df360 <- subset(df, df$age == 360 & df$knob >= VB40)
df40 <- levels(factor(df360$drifter))
df40 <- subset(df, df$drifter %in% df40)

dir.create(path = paste0(dirpath, 'particlesByDay/'), showWarnings = F)
dir.create(path = paste0(dirpath, 'particlesByAge/'), showWarnings = F)
dir.create(path = paste0(dirpath, 'figures/'), showWarnings = F)

outpathByDay <- paste0(dirpath, 'particlesByDay/')
outpathByAge <- paste0(dirpath, 'particlesByAge/')
outpathFigures <- paste0(dirpath, 'figures/')

MapParticlesByDay(df = df, outpath = outpathByDay)
MapParticlesByAge(df = df, outpath = outpathByAge)
density_map_byday(df = df40, outpath = outpathFigures, days = c(1,50,100,200,300,360))
density_map_byage(df = df40, outpath = outpathFigures, ages = c(1,50,100,200,300,360))









# setwd("~/Documents/case4")

# input_path <- 'F:/'
# xlimmap <- c(-100, -70)    # X limits of plot
# ylimmap <- c(-30, -0)      # Y limits of plot

# xlimmap <- c(-85, -70)    # X limits of plot
# ylimmap <- c(-19, -4.95)      # Y limits of plot

