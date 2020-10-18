#!/usr/bin/env Rscript

# borro todo
rm( list=ls() )

require(data.table)
require(rutiles)
# require(ranger)
require(randomForest) # solo para na.roughfix

args = commandArgs(trailingOnly=TRUE)

# PARA DEBUG
# args = c('iguala', '201911', '202001', '~/Documentos/maestria-dm/dm-eyf/datasets/paquete_premium_201906_202001.txt.gz', '~/Documentos/maestria-dm/dm-eyf/kaggle/ranger_basico.csv')

# test if there is at least one argument: if not, return an error
path_salida = '~/ranger_basico.csv'
if ( length(args) < 4 || length(args) > 5) {
  stop("Tienen que ser 4 o 5 parametros:
  1: 'mayora', 'menora' o 'iguala']
  2: meses de entrenamiento: 201911, 201910, ...
  3: mes de evaluacion: 202001, 201911, ...
  4: path dataset entrada: '~/paquete_premium_201906_202001.txt.gz'
  5: [OPCIONAL] path de salida: '~/ranger.csv'", call.=FALSE)
}
if (length(args) == 5) {
  path_salida = args[5]
}

comparacion = args[1]
foto_mes_entrenamiento = as.integer(args[2])
foto_mes_evaluacion = as.integer(args[3])
dataset_path = args[4]

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
                   n_arboles = 500, n_split = 3, nodo_min = 1, profundidad_max = 0,
                   salida_csv = path_salida,
                   entrenamiento = entrenamiento, evaluacion = dataset[foto_mes == foto_mes_evaluacion, ])
