#!/usr/bin/env Rscript

# borro todo
rm( list=ls() )

args = commandArgs(trailingOnly=TRUE)

# PARA DEBUG
# args = c('201906', '201911', '202001', '100', '0.001', '100', '1', '~/repos/dmeyf/features-importantes-lgbm/features_minmax_historicos2meses.txt', '200', '~/Documentos/maestria-dm/dm-eyf/datasets/paquete_premium_201906_202001.txt.gz', '~/Documentos/maestria-dm/dm-eyf/kaggle/lgbm_basico.csv')

if (length(args) != 16) {
  stop("Tienen que ser 16 parametros:
  1: mes entrenamiento 'desde'
  2: mes entrenamiento 'hasta'
  3: mes de validacion: 201905, 201912, ...
  4: mes de evaluacion: 202001, 201911, ...
  5: numero de iteraciones: 100, 20, ...
  6: parametros: 'learning_rate=0.0005-num_leaves=800-feature_extraction=0.25-...'
  7: undersampling: 0.01, 0.1, 1.0, ...
  8: prob de corte: 0.01, 0.025, 0.25, ...
  9: log: -1, 0, 1, 2, ...
  10: path features importantes: '~/features_procesadas.txt'
  11: top features importantes a usar: 10, 20, 100, ...
  12: path dataset entrada: '~/paquete_premium_201906_202001.txt.gz'
  13: path de salida: '~/lgbm.csv'
  14: imprimir importantes: T o F
  15: incluir foto_mes: T o F
  16: sacar meses fallados (201801, 201802, 201910, 201911): T o F
       ", call.=FALSE)
}

require(data.table)
require(rutiles)
require(lightgbm)


foto_mes_desde = as.integer(args[1])
foto_mes_hasta = as.integer(args[2])
foto_mes_validacion = as.integer(args[3])
foto_mes_evaluacion = as.integer(args[4])
iteraciones = as.integer(args[5])

# seteo los rangos de parametros por default:
parametros = list()
parametros[['min_data_in_leaf']] = '20'
parametros[['num_leaves']] = '31'
parametros[['max_bin']] = '255'
parametros[['learning_rate']] = '0.1'
parametros[['feature_fraction']] = '1.0'
parametros[['min_gain_to_split']] = '0'
parametros[['lambda_l1']] = '0'
parametros[['lambda_l2']] = '0'

pars = strsplit(args[6], '-')[[1]]
for (par in pars) {
  nombre_valor = strsplit(par, '=')[[1]]
  nombre = nombre_valor[1]
  
  if (nombre %in% names(parametros) == F) {
    stop(paste0("Error de parametros: '", nombre, "' no es un paramétro de lgbm."), call.=FALSE)
  }
  
  parametros[[nombre]] = nombre_valor[2]
}

undersampling = as.numeric(args[7])
prob_de_corte = as.numeric(args[8])
log = as.integer(args[9])
path_features = args[10]
top_features = as.integer(args[11])
dataset_path = args[12]
path_salida = args[13]
imprimir_importantes = as.logical(args[14])
incluir_foto_mes = as.logical(args[15])
sacar_meses_fallados = as.logical(args[16])

fganancia_logistic_lightgbm = function(probs, data)  {
  
  vlabels = getinfo(data, 'label')
  tbl <- as.data.table( list( "prob"=probs, "gan"= ifelse( vlabels==1, 29250, -750 ) ) )
  
  setorder( tbl, -prob )
  tbl[ , gan_acum :=  cumsum( gan ) ]
  gan <- max( tbl$gan_acum )
  
  return(  list( name= "ganancia", value=  gan, higher_better= TRUE ) )
}

dataset = levantar_clientes(path = dataset_path)

dataset[, baja := ifelse(baja == 'si', 1L, 0L)]

if (path_features != '-') {
  features = fread(path_features)
  features = names(features)[1:top_features]
} else {
  if (incluir_foto_mes) {
    features = setdiff(names(dataset), c('numero_de_cliente', 'baja'))
  } else {
    features = setdiff(names(dataset), c('numero_de_cliente', 'foto_mes', 'baja'))
  }
  
}
# agrego la columna azar para hacer undersampling
dataset[, azar := runif(nrow(dataset)) ]

# dejo los datos en el formato que necesita LightGBMdtrain = dataset[foto_mes_entrenamiento_desde <= foto_mes & foto_mes <= foto_mes_entrenamiento_hasta & foto_mes != foto_mes_evaluacion & (baja == 1L | azar <= porcion_undersampling)]
# dentrenamiento = dataset[foto_mes_desde <= foto_mes & foto_mes <= foto_mes_hasta & foto_mes != foto_mes_evaluacion & (baja == 1L | azar <= undersampling)]
fotos_meses_fallados = c()
if (sacar_meses_fallados) {
  fotos_meses_fallados = c(201801, 201802, 201910, 201911)
}

dentrenamiento = dataset[foto_mes_desde <= foto_mes & foto_mes <= foto_mes_hasta & foto_mes != foto_mes_evaluacion & foto_mes != foto_mes_validacion  & !(foto_mes %in% fotos_meses_fallados) & (baja == 1L | azar <= undersampling)]

entrenamiento = lgb.Dataset(data = data.matrix(dentrenamiento[, ..features]),
                            label = dentrenamiento$baja,
                            free_raw_data = F)

# valido un año para atras
validacion = lgb.Dataset(data  = data.matrix(dataset[foto_mes == foto_mes_validacion, ..features]),
                       label = dataset[foto_mes == foto_mes_validacion, baja],
                       free_raw_data = F)

modelo = lgb.train(data = entrenamiento, objective = 'binary',
                   eval = fganancia_logistic_lightgbm,  # esta es la fuciona optimizar
                   valids = list(valid = validacion),
                   metric = 'custom',  # ATENCION   tremendamente importante
                   boost_from_average = T,
                   max_bin= as.integer(parametros[['max_bin']]),
                   num_iterations = iteraciones,
                   min_data_in_leaf = as.integer(parametros[['min_data_in_leaf']]),
                   learning_rate = as.numeric(parametros[['learning_rate']]),
                   early_stopping_rounds = as.integer(50 + 5/as.numeric(parametros[['learning_rate']])),
                   feature_fraction = as.numeric(parametros[['feature_extraction']]),
                   min_gain_to_split = as.numeric(parametros[['min_gain_to_split']]),
                   num_leaves = as.integer(parametros[['num_leaves']]),
                   lambda_l1 = as.numeric(parametros[['lambda_l1']]),
                   lambda_l2 = as.numeric(parametros[['lambda_l2']]),
                   verbose = log)

lgb.save(modelo, paste0(path_salida, '.modelo'))

prediccion = predict(modelo, data.matrix( dataset[foto_mes == foto_mes_evaluacion, ..features]))

rutiles::ganancia(real = dataset[foto_mes == foto_mes_evaluacion, baja], prediccion = as.integer(prediccion > prob_de_corte), imprimir = T)

if (imprimir_importantes) {
  cat('variables importantes\n', lgb.importance(modelo, percentage = T)$Feature)
}

if (path_salida != '-') {
  rutiles::kaggle_csv(clientes = dataset[foto_mes == foto_mes_evaluacion, numero_de_cliente], estimulos = as.integer(prediccion > prob_de_corte), path = path_salida)
  
  data = data.table('numero_de_cliente' = dataset[foto_mes == foto_mes_evaluacion, numero_de_cliente], 'prob' = prediccion)
  fwrite(data, sep = ',',  file = paste0(path_salida,'.probs'))
}

rm(list = ls())
gc()
