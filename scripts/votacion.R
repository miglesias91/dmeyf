

library(data.table)

votos = data.table()
i = 0
for (path in list.files('~/repos/dmeyf/votacion/2/')){
  i = i + 1
  csv = fread(paste0('~/repos/dmeyf/votacion/2/',path))
  csv[order(numero_de_cliente)]
  votos = votos[, paste0('voto',i) := csv$estimulo]
}

votantes = paste0('voto', seq(1,i))
votos[, numero_de_cliente := csv$numero_de_cliente]

porcentaje = 1
minimo_votos = as.integer(i*porcentaje)
votos[, estimulo := ifelse(rowSums(.SD) >= minimo_votos, 1, 0) , .SDcols = votantes]

votos[, .N, keyby=estimulo]

fwrite(votos[, .(numero_de_cliente, estimulo)], sep=',',  file=paste0('~/repos/dmeyf/votacion/votacion_2_',porcentaje,'.csv'))
