#!/usr/bin/env Rscript

# borro todo
rm( list=ls() )

args = commandArgs(trailingOnly=TRUE)

# PARA DEBUG
args = c('0.025', '~/repos/dmeyf/path.probs')

if (length(args) != 2) {
  stop("Tienen que ser 18 parametros:
  1: prob de corte: 0.025, 0.05, 0.2, ...
  2: path probabilidades", call.=FALSE)
}

library(data.table)
library(rutiles)

prob_de_corte = as.numeric(args[1])
path_prob = args[2]
path_salida = paste0(path_prob,'.', args[1], '.csv')

probs = fread(path_prob, sep = ',')

rutiles::kaggle_csv(clientes = probs[, numero_de_cliente], estimulos = as.integer(probs[,prob] > prob_de_corte), path = path_salida)