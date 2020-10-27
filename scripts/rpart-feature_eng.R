#!/usr/bin/env Rscript

# borro todo
rm( list=ls() )

require(data.table)
require(rutiles)

args = commandArgs(trailingOnly=TRUE)

# PARA DEBUG
# args = c('201908', '201909', '201911', '2', '~/Documentos/maestria-dm/dm-eyf/datasets/paquete_premium_201906_202001.txt.gz', '~/Documentos/maestria-dm/dm-eyf/kaggle/ranger_basico.csv')

if (  length(args) != 6) {
  stop("Tienen que ser 6 parametros:
  1: mes entrenamiento 'desde'
  2: mes entrenamiento 'hasta'
  3: mes de evaluacion: 202001, 201911, ...
  4: ventana historico: 0, 1, 2, 3 ... (0 = sin historico)
  5: path dataset entrada: '~/paquete_premium_201906_202001.txt.gz'
  6: path de salida: '~/ranger.csv'", call.=FALSE)
}

foto_mes_desde = as.integer(args[1])
foto_mes_hasta = as.integer(args[2])
foto_mes_evaluacion = as.integer(args[3])
ventana_historico = as.integer(args[4])
dataset_path = args[5]
path_salida = args[6]

dataset = levantar_clientes(path = dataset_path)

dataset = rutiles::feature_eng(dataset, historico_desde = foto_mes_evaluacion, ventana_historico = 2)

rutiles::rt_rpart(a_predecir = 'baja', positivo = 'si',
                  complejidad = 0.0002024526, n_split = 29, nodo_min = 4, profundidad_max = 17,
                  entrenamiento = dataset[foto_mes_desde <= foto_mes & foto_mes <= foto_mes_hasta, ], evaluacion = dataset[foto_mes == foto_mes_evaluacion, ],
                  salida_csv = path_salida)

rm(list=ls())
gc()