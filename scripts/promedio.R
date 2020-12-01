#!/usr/bin/env Rscript

# borro todo
rm( list=ls() )

args = commandArgs(trailingOnly=TRUE)

# PARA DEBUG
# args = c('0.025', '~/repos/dmeyf/path.csv.probs')

if (length(args) != 2) {
  stop("Tienen que ser 2 parametros:
  1: cantidad de estimulos: 6000, 6500, 7000, ...
  2: path probabilidades", call.=FALSE)
}

library(data.table)

cantidad_de_estimulos = as.integer(args[1])
path_prob = args[2]
path_salida = paste0(path_prob,'/promedio_', cantidad_de_estimulos, '.csv')

votos = data.table()
i = 0
for (path in list.files(path_prob)){
  i = i + 1
  csv = fread(paste0(path_prob,path))
  csv[order(numero_de_cliente)]
  votos = votos[, paste0('prob',i) := csv$prob]
}

probabilidades = paste0('prob', seq(1,i))
votos[, numero_de_cliente := csv$numero_de_cliente]

votos[, promedio := rowMeans(.SD) , .SDcols = probabilidades]

probs = votos[order(-promedio)]

estimulos = c(seq(1, 1, length.out = cantidad_de_estimulos), seq(0, 0, length.out = length(probs$numero_de_cliente) - cantidad_de_estimulos))

rutiles::kaggle_csv(clientes = probs$numero_de_cliente, estimulos = estimulos, path = path_salida)
