# Load packages
library(fields)
library(mapdata)
library(maps)
library(ggplot2)
library(raster)
library(mgcv)
library(hexbin)

# load functions
#==== Funciones de lectura ===#
source('R/readDataOutput/readDataOutput.R')
source('R/readDataOutput/VB_curve.R')

#=== Funciones en base DAY ===#
source('R/readDataOutput/dens2D_map_byday.R')
source('R/readDataOutput/knob_map_byday.R')
source('R/readDataOutput/weight_map_byday.R')
source('R/readDataOutput/MapParticlesByDay.R')
source('R/readDataOutput/knob_weight_byday.R')

source('R/readDataOutput/hist_knob_weight_byday.R')

#=== Funciones en base AGE ===#
source('R/readDataOutput/dens2D_map_byage.R')
source('R/readDataOutput/knob_map_byage.R')
source('R/readDataOutput/weight_map_byage.R')
source('R/readDataOutput/MapParticlesByAge.R')
source('R/readDataOutput/knob_weight_byage.R')

source('R/readDataOutput/hist_knob_weight_byage.R')

#=== funciones para gráficos extra ===#
source('R/readDataOutput/timeserie_vari.R')