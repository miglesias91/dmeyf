#!/usr/bin/env Rscript

# borro todo
rm( list=ls() )

args = commandArgs(trailingOnly=TRUE)

# PARA DEBUG
args = c('201909', '201911', '202001', '50', '0.001', '100', '0.01', '0.01', '0.01', '0.01', '1', '-', '50', '~/Documentos/maestria-dm/dm-eyf/datasets/paquete_premium_201906_202001.txt.gz', '~/Documentos/maestria-dm/dm-eyf/kaggle/lgbm_basico.csv')

if (  length(args) != 15) {
  stop("Tienen que ser 15 parametros:
  1: mes entrenamiento 'desde'
  2: mes entrenamiento 'hasta'
  3: mes de evaluacion: 202001, 201911, ...
  4: numero de iteraciones: 100, 20, ...
  5: learning rate: 0.01, 0.001, 0.0005, ...
  6: hojas: 50, 100, ...
  7: feature extraction: 0.01, 0.001, 0.0005, ...
  8: main gain to split: 0.01, 0.001, 0.0005, ...
  9: lambda1: 0.01, 0.001, 0.0005, ...
  10: lambda2: 0.01, 0.001, 0.0005, ...
  11: log: -1, 0, 1, 2, ...
  12: path features importantes: '~/features_procesadas.txt'
  13: top features importantes a usar: 10, 20, 100, ...
  14: path dataset entrada: '~/paquete_premium_201906_202001.txt.gz'
  15: path de salida: '~/lgbm.csv'", call.=FALSE)
}

require(data.table)
require(rutiles)
require(lightgbm)
require(rsample)

foto_mes_desde = as.integer(args[1])
foto_mes_hasta = as.integer(args[2])
foto_mes_evaluacion = as.integer(args[3])
iteraciones = as.integer(args[4])
learning_rate = as.double(args[5])
hojas = as.integer(args[6])
feature_extraction = as.double(args[7])
min_gain_to_split = as.double(args[8])
lambda1 = as.double(args[9])
lambda2 = as.double(args[10])
log = as.integer(args[11])
path_features = args[12]
top_features = as.integer(args[13])
dataset_path = args[14]
path_salida = args[15]

dataset = levantar_clientes(path = dataset_path)

dataset[, baja := ifelse(baja == 'si', 1L, 0L)]

if (path_features != '-') {
  features = fread(path_features)
  features = names(features)[1:top_features]
} else {
  features = setdiff(names(dataset), c('numero_de_cliente', 'foto_mes', 'baja'))
}

desarrollo = dataset[foto_mes_desde <= foto_mes & foto_mes <= foto_mes_hasta]

# elegimos semilla
set.seed(44)

# armamos las particiones
dentrenamiento_dvalidacion = initial_split(desarrollo, prop = 0.7, strata = 'baja')

# separamos la partición de entrenamiento
dentrenamiento = training(dentrenamiento_dvalidacion)

# separamos la partición de validación
dvalidacion = testing(dentrenamiento_dvalidacion)

entrenamiento = lgb.Dataset(data = data.matrix(dentrenamiento[, ..features]),
                            label = dentrenamiento$baja,
                            free_raw_data = F)

validacion = lgb.Dataset.create.valid(entrenamiento,
                                      data = data.matrix(dvalidacion[, ..features]),
                                      label = dvalidacion$baja)

parametros = list(
  objective = 'binary',
  boost_from_average = T,
  max_bin= 31,
  num_iterations = iteraciones,
  learning_rate = learning_rate,
  # early_stopping_rounds = as.integer(50 + 5/learning_rate),
  feature_fraction = feature_extraction,
  min_gain_to_split = min_gain_to_split,
  num_leaves = hojas,
  lambda_l1 = lambda1,
  lambda_l2 = lambda2,
  verbose = log
)

modelo = lgb.cv(parametros,
                entrenamiento,
                nrounds = 5,
                eval = 'binary_error')

prediccion = predict(modelo$boosters[1], data.matrix( dataset[foto_mes == foto_mes_evaluacion, ..features]))

rutiles::ganancia(real = dataset[foto_mes == foto_mes_evaluacion, baja], prediccion = as.integer(prediccion > 0.025), imprimir = T)

cat('variables importantes\n', lgb.importance(modelo, percentage = T)$Feature)

if (path_salida != '-') {
  rutiles::kaggle_csv(clientes = dataset[foto_mes == foto_mes_evaluacion, numero_de_cliente], estimulos = as.integer(prediccion > 0.025), path = path_salida)
}

rm(list = ls())
gc()
