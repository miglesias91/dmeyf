#!/usr/bin/env Rscript

# borro todo
rm( list=ls() )

args = commandArgs(trailingOnly=TRUE)

# PARA DEBUG
# args = c('201906', '201911', '202001', '100', '0.001', '100', '1', '~/repos/dmeyf/features-importantes-lgbm/features_minmax_historicos2meses.txt', '200', '~/Documentos/maestria-dm/dm-eyf/datasets/paquete_premium_201906_202001.txt.gz', '~/Documentos/maestria-dm/dm-eyf/kaggle/lgbm_basico.csv')

if (  length(args) != 17) {
  stop("Tienen que ser 15 parametros:
  1: mes entrenamiento 'desde'
  2: mes entrenamiento 'hasta'
  3: mes de evaluacion: 202001, 201911, ...
  4: numero de iteraciones: 100, 20, ...
  5: learning rate: 0.01, 0.001, 0.0005, ...
  6: min data in leaf: 100, 1000, 10000, ...
  7: hojas: 50, 100, ...
  8: feature extraction: 0.01, 0.001, 0.0005, ...
  9: main gain to split: 0.01, 0.001, 0.0005, ...
  10: lambda1: 0.01, 0.001, 0.0005, ...
  11: lambda2: 0.01, 0.001, 0.0005, ...
  12: log: -1, 0, 1, 2, ...
  13: path features importantes: '~/features_procesadas.txt'
  14: top features importantes a usar: 10, 20, 100, ...
  15: path dataset entrada: '~/paquete_premium_201906_202001.txt.gz'
  16: path de salida: '~/lgbm.csv'
  17: imprimir importantes: T o F", call.=FALSE)
}

require(data.table)
require(rutiles)
require(lightgbm)


foto_mes_desde = as.integer(args[1])
foto_mes_hasta = as.integer(args[2])
foto_mes_evaluacion = as.integer(args[3])
iteraciones = as.integer(args[4])
learning_rate = as.double(args[5])
min_data_in_leaf = as.integer(args[6])
hojas = as.integer(args[7])
feature_extraction = as.double(args[8])
min_gain_to_split = as.double(args[9])
lambda1 = as.double(args[10])
lambda2 = as.double(args[11])
log = as.integer(args[12])
path_features = args[13]
top_features = as.integer(args[14])
dataset_path = args[15]
path_salida = args[16]
imprimir_importantes = as.logical(args[17])

dataset = levantar_clientes(path = dataset_path)

dataset[, baja := ifelse(baja == 'si', 1L, 0L)]

if (path_features != '-') {
  features = fread(path_features)
  features = names(features)[1:top_features]
} else {
  features = setdiff(names(dataset), c('numero_de_cliente', 'foto_mes', 'baja'))
}

dentrenamiento = dataset[foto_mes_desde <= foto_mes & foto_mes <= foto_mes_hasta & foto_mes != foto_mes_evaluacion]

entrenamiento = lgb.Dataset(data = data.matrix(dentrenamiento[, ..features]),
                            label = dentrenamiento$baja,
                            free_raw_data = F)

modelo = lgb.train(data = entrenamiento, objective = 'binary',
                   boost_from_average = T,
                   max_bin= 31,
                   num_iterations = iteraciones,
                   min_data_in_leaf = min_data_in_leaf,
                   learning_rate = learning_rate,
                   # early_stopping_rounds = as.integer(50 + 5/learning_rate),
                   feature_fraction = feature_extraction,
                   min_gain_to_split = min_gain_to_split,
                   num_leaves = hojas,
                   lambda_l1 = lambda1,
                   lambda_l2 = lambda2,
                   verbose = log)

prediccion = predict(modelo, data.matrix( dataset[foto_mes == foto_mes_evaluacion, ..features]))

rutiles::ganancia(real = dataset[foto_mes == foto_mes_evaluacion, baja], prediccion = as.integer(prediccion > 0.025), imprimir = T)

if (imprimir_importantes) {
  cat('variables importantes\n', lgb.importance(modelo, percentage = T)$Feature)
}

if (path_salida != '-') {
  rutiles::kaggle_csv(clientes = dataset[foto_mes == foto_mes_evaluacion, numero_de_cliente], estimulos = as.integer(prediccion > 0.025), path = path_salida)
  
  data = data.table('numero_de_cliente' = clientes, 'prob' = prediccion)
  fwrite(data, sep = ',',  file = paste0(path_salida,'.probs'))
}

rm(list = ls())
gc()
