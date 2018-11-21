library(ggplot2)
library(fields)
library(mapdata)
library(raster)
library(mgcv)

# setwd("~/Documents/case4")
dirpath <- '/home/jtam/Documents/case4/escenario/out/'
# input_path <- 'F:/'
xlimmap <- c(-100, -70)    # X limits of plot
ylimmap <- c(-30, -0)      # Y limits of plot

# xlimmap <- c(-85, -70)    # X limits of plot
# ylimmap <- c(-19, -4.95)      # Y limits of plot

nfiles  <- 60
max_paticles <- 11760

df <- readDataOutput(dirpath = dirpath, max_paticles = max_paticles, nfiles = nfiles)

outpath <- paste0(dirpath, 'trajectories/')
