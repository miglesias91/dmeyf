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
library(rutiles)

cantidad_de_estimulos = as.numeric(args[1])
path_prob = args[2]
path_salida = paste0(path_prob,'.', args[1], '.csv')

probs = fread(path_prob, sep = ',')

probs = probs[order(-prob)]

estimulos = c(seq(1, 1, length.out = cantidad_de_estimulos), seq(0, 0, length.out = length(probs$numero_de_cliente) - cantidad_de_estimulos))

rutiles::kaggle_csv(clientes = probs$numero_de_cliente, estimulos = estimulos, path = path_salida)