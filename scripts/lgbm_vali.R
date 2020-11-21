#!/usr/bin/env Rscript

# borro todo
rm( list=ls() )

args = commandArgs(trailingOnly=TRUE)

# PARA DEBUG
# args = c('201906', '201911', '201907-201910', '10', 'min_data_in_leaf=9822-learning_rate=0.01', '0.01_0.3_15', '1', '~/repos/dmeyf/features-importantes-lgbm/features_standars.txt', '50', '0.01','~/Documentos/maestria-dm/dm-eyf/datasets/paquete_premium_201906_202001.txt.gz')

if (length(args) != 11) {
  stop("Tienen que ser 11 parametros:
  1: mes entrenamiento 'desde'
  2: mes entrenamiento 'hasta'
  3: meses de validacion: 201905-202003-201805-...
  4: numero de iteraciones: 100, 20, ...
  5: parametros: 'learning_rate=0.0005-num_leaves=800-feature_extraction=0.25-...'
  6: rango y freq de prob de corte: 0.01_0.1_10, 0.025_0.25_5, ...
  7: log: -1, 0, 1, 2, ...
  8: path features importantes: '~/features_procesadas.txt'
  9: top features importantes a usar: 10, 20, 100, ...
  10: undersampling: 0.01, 0.1, 1.0, ...
  11: path dataset entrada: '~/paquete_premium_201906_202001.txt.gz'", call.=FALSE)
}

require(data.table)
require(rutiles)
require(lightgbm)
require(rsample)

foto_mes_desde = as.integer(args[1])
foto_mes_hasta = as.integer(args[2])
foto_meses_validacion = as.integer(strsplit(args[3], '-')[[1]])
iteraciones = as.integer(args[4])

# seteo los rangos de parametros por default:
parametros = list()
parametros[['min_data_in_leaf']] = '20'
parametros[['num_leaves']] = '31'
parametros[['learning_rate']] = '0.1'
parametros[['feature_fraction']] = '1.0'
parametros[['min_gain_to_split']] = '0'
parametros[['lambda_l1']] = '0'
parametros[['lambda_l2']] = '0'

pars = strsplit(args[5], '-')[[1]]
for (par in pars) {
  nombre_valor = strsplit(par, '=')[[1]]
  nombre = nombre_valor[1]
  
  if (nombre %in% names(parametros) == F) {
    stop(paste0("Error de parametros: '", nombre, "' no es un paramétro de lgbm."), call.=FALSE)
  }
  
  parametros[[nombre]] = nombre_valor[2]
}

campos_prob_de_corte  = as.numeric(strsplit(args[6], '_')[[1]])
prob_de_corte_desde = campos_prob_de_corte[1]
prob_de_corte_hasta = campos_prob_de_corte[2]
prob_de_corte_bins = campos_prob_de_corte[3]

log = as.integer(args[7])
path_features = args[8]
top_features = as.integer(args[9])
undersampling = as.numeric(args[10])
dataset_path = args[11]

dataset = levantar_clientes(path = dataset_path)

dataset[, baja := ifelse(baja == 'si', 1L, 0L)]

if (path_features != '-') {
  features = fread(path_features)
  features = names(features)[1:top_features]
} else {
  features = setdiff(names(dataset), c('numero_de_cliente', 'foto_mes', 'baja'))
}

dataset[, azar := runif(nrow(dataset)) ]

dentrenamiento = dataset[foto_mes_desde <= foto_mes & foto_mes <= foto_mes_hasta & !(foto_mes %in% foto_meses_validacion) & (baja == 1L | azar <= undersampling)]

entrenamiento = lgb.Dataset(data = data.matrix(dentrenamiento[, ..features]),
                            label = dentrenamiento$baja,
                            free_raw_data = F)

modelo = lgb.train(data = entrenamiento, objective = 'binary',
                   boost_from_average = T,
                   max_bin= 31,
                   num_iterations = iteraciones,
                   min_data_in_leaf = as.integer(parametros[['min_data_in_leaf']]),
                   learning_rate = as.numeric(parametros[['learning_rate']]),
                   # early_stopping_rounds = as.integer(50 + 5/learning_rate),
                   feature_fraction = as.numeric(parametros[['feature_extraction']]),
                   min_gain_to_split = as.numeric(parametros[['min_gain_to_split']]),
                   num_leaves = as.integer(parametros[['num_leaves']]),
                   lambda_l1 = as.numeric(parametros[['lambda_l1']]),
                   lambda_l2 = as.numeric(parametros[['lambda_l2']]),
                   verbose = log)

mejor_ganancia = 0
mejor_prob = 0
for (prob_de_corte in seq(prob_de_corte_desde, prob_de_corte_hasta, length.out = prob_de_corte_bins)) {
  ganancia_total = 0
  for (foto_mes_validacion in foto_meses_validacion) {
    prediccion = predict(modelo, data.matrix(dataset[foto_mes == foto_mes_validacion, ..features]))
    ganancia = rutiles::ganancia(real = dataset[foto_mes == foto_mes_validacion, baja], prediccion = as.integer(prediccion > prob_de_corte), imprimir = T, devolver = T)
    ganancia_total = ganancia_total + ganancia
  }
  cat('ganacia promedio para', prob_de_corte, ':', ganancia_total, '\n')
  if (ganancia_total > mejor_ganancia) {
    mejor_ganancia = ganancia_total
    mejor_prob = prob_de_corte
  }
}
cat('mejor ganacia promedio:', mejor_ganancia, ', prob corte:', mejor_prob)

rm(list = ls())
gc()
