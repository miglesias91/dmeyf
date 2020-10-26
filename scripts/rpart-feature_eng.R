#!/usr/bin/env Rscript

# borro todo
rm( list=ls() )

require(data.table)
require(stringr)
require(rutiles)

args = commandArgs(trailingOnly=TRUE)

# PARA DEBUG
# args = c('iguala', '201909', '201911', '~/Documentos/maestria-dm/dm-eyf/datasets/paquete_premium_201906_202001.txt.gz', '~/Documentos/maestria-dm/dm-eyf/kaggle/ranger_basico.csv', 610, 20, 25, 12)

if (  length(args) != 12) {
  stop("Tienen que ser 12 parametros:
  1: mes entrenamiento 'desde'
  2: mes entrenamiento 'hasta'
  3: mes de evaluacion: 202001, 201911, ...
  4: combinar tarjetas: T o F
  5: ventana historico: 0, 1, 2, 3 ... (0 = sin historico)
  6: historico desde: 202001, 201912, ...
  7: top variables importantes: 10, 15, 20, ... (min = 1, max = 78)
  8: historico de combinaciones de tarjetas: T o F
  9: borrar originales de tarjeta: T o F
  10: correccion de catedra: T o F
  11: path dataset entrada: '~/paquete_premium_201906_202001.txt.gz'
  12: path de salida: '~/ranger.csv'", call.=FALSE)
}

foto_mes_desde = as.integer(args[1])
foto_mes_hasta = as.integer(args[2])
foto_mes_evaluacion = as.integer(args[3])
combinar_tarjetas = as.logical(args[4])
ventana_historico = as.integer(args[5])
historico_desde = as.integer(args[6])
top_importantes = as.integer(args[7])
historico_de_combi_de_tarjetas = as.logical(args[8])
borrar_origi_de_tarjetas = as.logical(args[9])
correccion_catedra = as.logical(args[10])

dataset_path = args[11]
path_salida = args[12]

dataset = levantar_clientes(path = dataset_path)

datase = rutiles::feature_eng(dataset,
                              combinar_tarjetas = combinar_tarjetas,
                              historico_de = ventana_historico, historico_desde = historico_desde,
                              historicos_de_tarjetas = historico_de_combi_de_tarjetas,
                              borrar_originales_de_tarjetas = borrar_origi_de_tarjetas,
                              top_variables_importantes = top_importantes,
                              correccion_catedra = correccion_catedra)

rutiles::rt_rpart(a_predecir = 'baja', positivo = 'si',
                  complejidad = 0.0002024526, n_split = 29, nodo_min = 4, profundidad_max = 17,
                  entrenamiento = dataset[foto_mes_desde <= foto_mes & foto_mes <= foto_mes_hasta], evaluacion = dataset[foto_mes == foto_mes_evaluacion],
                  salida_csv = path_salida)

rm(list=ls())
gc()