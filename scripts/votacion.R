

library(data.table)

votos = data.table()
i = 0
for (path in list.files('~/repos/dmeyf/votacion/')){
  i = i + 1
  csv = fread(paste0('~/repos/dmeyf/votacion/',path))
  csv[order(numero_de_cliente)]
  votos = votos[, paste0('voto',i) := csv$estimulo]
}

votantes = paste0('voto', seq(1,i))
votos[, numero_de_cliente := csv$numero_de_cliente]

minimo_votos = as.integer(i*0.8)
votos[, estimulo := ifelse(rowSums(.SD) >= minimo_votos, 1, 0) , .SDcols = votantes]

fwrite(votos[, .(numero_de_cliente, estimulo)], sep=',',  file='votacion_50.csv')
