#=============================================================================#
# Name   : DividirCorrientes
# Author : Jorge Flores
# Date   : 
# Version:
# Aim    : 
# URL    : 
#=============================================================================#
var_serie <- read.table('C:/Users/ASUS/Desktop/t_serie.csv', header = F)

year_in <- 1958
year_on <- 2008

mon_seri <- NULL
for (i in year_in:year_on){
  for (j in 1:12){
    m <- subset(var_serie, var_serie$V3 == i & var_serie$V4 == j)
    m <- mean(m$V2)
    mon_seri <- c(mon_seri, m)
  }
}
var_serie <- cbind(var_serie, mon_seri)

date_in <- as.Date(paste0(year_in, '-','01','-','01'))
date_on <- as.Date(paste0(year_on, '-','12','-','01'))
fechas <- seq(date_in, date_on, by = 'months')

plot(fechas, mon_seri, type = 'l')

# Convertir el dataframe en un objeto de serie temporal
data_ts  = ts(data = mon_seri, start= c(1958,1), frequency = 12)


#############
# data(data_ts)
class(data_ts)

#This is the start of the time series
start(data_ts)

#This is the end of the time series
end(data_ts)

#The cycle of this time series is 12months in a year
frequency(data_ts)

summary(data_ts)

#The number of passengers are distributed across the spectrum
plot(data_ts)

# This will fit in a line
abline(reg=lm(data_ts~time(data_ts)))

#This will print the cycle across years.
cycle(data_ts)

#This will aggregate the cycles and display a year on year trend
plot(aggregate(data_ts,FUN=mean))

#Box plot across months will give us a sense on seasonal effect
boxplot(data_ts~cycle(data_ts))


### ### ### ### ###
serie_dat <- cbind(mon_seri, rep(1:12, times =51))
clim <- tapply(serie_dat[,1], list(serie_dat[,2]), mean)
serie_dat <- cbind(serie_dat, rep(clim, times = 51))
anom <- serie_dat[,1] - serie_dat[,3]

plot(fechas, anom, type = 'l')
abline(h = 0)

# # Convertir el dataframe en un objeto de serie temporal
# data_ts  = ts(data = var_serie, start= c(1958,1), frequency = 5)
# 
# # DESCOMPONIENDO LA SERIE -------------------------------------------------
# 
# ## descomposiciÃ³n de la serie
# data_STL  = stl(x = data_ts, s.window = 12, t.window = 60)
# 
# x11() ;
# plot(data_STL)
# 
# data_mat <- data_STL$time.series
# trend <- data_mat[,2]
# 
# anom <- var_serie - trend
# plot(anom)
# abline(h = 0)




# #############
# data(AirPassengers)
# class(AirPassengers)
# 
# #This is the start of the time series
# start(AirPassengers)
# 
# #This is the end of the time series
# end(AirPassengers)
# 
# #The cycle of this time series is 12months in a year
# frequency(AirPassengers)
# 
# summary(AirPassengers)
# 
# #The number of passengers are distributed across the spectrum
# plot(AirPassengers)
# # This will fit in a line
# abline(reg=lm(AirPassengers~time(AirPassengers)))
# 
# #This will print the cycle across years.
# cycle(AirPassengers)
# 
# #This will aggregate the cycles and display a year on year trend
# plot(aggregate(AirPassengers,FUN=mean))
# 
# #Box plot across months will give us a sense on seasonal effect
# boxplot(AirPassengers~cycle(AirPassengers))
# 
#=============================================================================#
# END OF PROGRAM
#=============================================================================#