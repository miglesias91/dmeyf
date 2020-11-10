#!/usr/bin/env Rscript

# borro todo
rm( list=ls() )

args = commandArgs(trailingOnly=TRUE)

# PARA DEBUG
# args = c('201907', '1', '~/Documentos/maestria-dm/dm-eyf/datasets/paquete_premium_201906_202001.txt.gz', '~/Documentos/maestria-dm/dm-eyf/kaggle/ranger_basico.csv')

if (  length(args) != 4) {
  stop("Tienen que ser 4 parametros:
  1: mes desde: 202001, 201911, ...
  2: ventana historico: 0, 1, 2, 3 ... (0 = sin historico)
  3: path dataset entrada: '~/paquete_premium_201906_202001.txt.gz'
  4: path de salida: '~/feature_eng_paquete_premium_201906_202001.txt.gz'", call.=FALSE)
}

require(data.table)
require(rutiles)

foto_mes_desde = as.integer(args[1])
ventana_historico = as.integer(args[2])
dataset_path = args[3]
path_salida = args[4]

dataset = levantar_clientes(path = dataset_path)

dataset = rutiles::feature_eng(dataset, historico_desde = foto_mes_desde, ventana_historico = ventana_historico, temp = path_salida)

if (path_salida != '-'){
  fwrite(dataset, file = path_salida, sep = '\t')
}

rm(list=ls())
gc()