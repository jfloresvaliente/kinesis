M3  <- subset(datos, datos$mes == 3)[,c(1,2)]
M10 <- subset(datos, datos$mes == 10)[,c(1,2)]

M3[,3]<-1
M10[,3]<-1

write.table(x = M3, file = '/run/media/jtam/atun/anch/M3.csv', sep = ';', col.names = F, row.names = F)
write.table(x = M10, file = '/run/media/jtam/atun/anch/M10.csv', sep = ';', col.names = F, row.names = F)
