#!/usr/bin/env Rscript

# borro todo
rm( list=ls() )

require(data.table)
require(rutiles)
# require(ranger)
require(randomForest) # solo para na.roughfix

args = commandArgs(trailingOnly=TRUE)

# PARA DEBUG
# args = c('iguala', '201909', '201911', '~/Documentos/maestria-dm/dm-eyf/datasets/paquete_premium_201906_202001.txt.gz', '~/Documentos/maestria-dm/dm-eyf/kaggle/ranger_basico.csv', 610, 20, 25, 12)

if (  length(args) != 9) {
  stop("Tienen que ser 9 parametros:
  1: 'mayora', 'menora' o 'iguala']
  2: meses de entrenamiento: 201911, 201910, ...
  3: mes de evaluacion: 202001, 201911, ...
  4: path dataset entrada: '~/paquete_premium_201906_202001.txt.gz'
  5: path de salida: '~/ranger.csv'
  6: n_arboles: 100, 200, ..., 900 ...
  7: n_split: 2, 3, ... , 20...
  8: nodo_min: 1, 2, ... , 40
  9: profundidad_max: 0, 1, 2, ..., 20, 21,... ", call.=FALSE)
}

comparacion = args[1]
foto_mes_entrenamiento = as.integer(args[2])
foto_mes_evaluacion = as.integer(args[3])
dataset_path = args[4]
path_salida = args[5]
n_arboles = as.integer(args[6])
n_split = as.integer(args[7])
nodo_min = as.integer(args[8])
profundidad_max = as.integer(args[9])

# levanto dataset
dataset = levantar_clientes(path = dataset_path, nombre_clase_binaria = 'baja', positivo = 'si', negativo = 'no', fix_nulos = T)

if (comparacion == 'mayora') {
  entrenamiento = dataset[  foto_mes >= foto_mes_entrenamiento, ]
} else if (comparacion == 'menora') {
  entrenamiento = dataset[  foto_mes <= foto_mes_entrenamiento, ]
} else if (comparacion == 'iguala') {
  entrenamiento = dataset[  foto_mes == foto_mes_entrenamiento, ]
} else {
  stop('el 1er parametro tiene que ser "mayora", "menora" o "iguala"')
}

rutiles::rf_ranger(a_predecir = 'baja', positivo = 'si',
                   n_arboles = n_arboles, n_split = n_split, nodo_min = nodo_min, profundidad_max = profundidad_max,
                   salida_csv = path_salida,
                   entrenamiento = entrenamiento, evaluacion = dataset[foto_mes == foto_mes_evaluacion, ])
