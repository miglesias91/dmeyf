#!/usr/bin/env Rscript

# borro todo
rm( list=ls() )

args = commandArgs(trailingOnly=TRUE)

# PARA DEBUG
# args = c('201908', '201909', '201911', 'min_data_in_leaf=100_1000', '~/repos/dmeyf/features-importantes-lgbm/features_standars.txt', 50,'~/Documentos/maestria-dm/dm-eyf/datasets/paquete_premium_201906_202001.txt.gz', '~/Documentos/maestria-dm/dm-eyf/workspace/opt_bayesiana_ranger', 2, 0.05, 0.2)
# args = c('201908', '201909', '201911', 'min_data_in_leaf=100_1000', '~/repos/dmeyf/features-importantes-lgbm/features_minmax_historicos6meses_paquete_final.txt', 50,'~/buckets/b1/datasets/paquete_premium_201906_202001.txt.gz', '~/buckets/b2/opt_bayesiana_lgbm', 3, 0.05, 0.2)

# test if there is at least one argument: if not, return an error
if (length(args) != 11) {
  stop("Tienen que ser 11 parametros:
  1: mes entrenamiento 'desde'
  2: mes entrenamiento 'hasta'
  3: mes evaluacion
  4: hiperparametros a optimizar: 'learning_rate=0.0005_0.005-num_leaves=500_800-feature_extraction=0.25_0.25-...'
  5: path features importantes: '~/features_procesadas.txt'
  6: top features importantes a usar: 10, 20, 100, ...
  7: path dataset entrada: '~/paquete_premium_201906_202001.txt.gz'
  8: carpeta salida: '~/opt_bayesiana_lgbm'
  9: número de iteraciones: 100, 200, ...
  10: undersampling: 0.01, 0.1, 1.0, ...
  11: prob corte inicial: 0.025, 0.25, ...",
       call.=FALSE)
}

require(data.table)
require(lightgbm)
require(rutiles)
require(DiceKriging)
require(mlrMBO)

foto_mes_entrenamiento_desde = as.integer(args[1])
foto_mes_entrenamiento_hasta = as.integer(args[2])
foto_mes_evaluacion = as.integer(args[3])

# seteo los rangos de parametros por default:
rangos_de_parametros = list()
rangos_de_parametros[['min_data_in_leaf']] = list('desde' = '20', 'hasta' = '20')
rangos_de_parametros[['num_leaves']] = list('desde' = '31', 'hasta' = '31')
rangos_de_parametros[['learning_rate']] = list('desde' = '0.1', 'hasta' = '0.1')
rangos_de_parametros[['feature_fraction']] = list('desde' = '1.0', 'hasta' = '1.0')
rangos_de_parametros[['min_gain_to_split']] = list('desde' = '0', 'hasta' = '0')
rangos_de_parametros[['lambda_l1']] = list('desde' = '0', 'hasta' = '0')
rangos_de_parametros[['lambda_l2']] = list('desde' = '0', 'hasta' = '0')
rangos_de_parametros[['prob_corte']] = list('desde' = '0.025', 'hasta' = '0.025')

pars = strsplit(args[4], '-')[[1]]
for (par in pars) {
  nombre_rango = strsplit(par, '=')[[1]]
  nombre = nombre_rango[1]
  
  if (nombre %in% names(rangos_de_parametros) == F) {
    stop(paste0("Error de hiperparametros: '", nombre, "' no es un hiperparamétro a optimizar."), call.=FALSE)
  }
  
  rango = strsplit(nombre_rango[2], '_')[[1]]
  desde = rango[1]
  hasta = rango[2]
  rangos_de_parametros[[nombre]] = list('desde' = desde, 'hasta' = hasta)
}

path_features = args[5]
top_features = as.integer(args[6])
dataset_path = args[7]
carpeta = args[8]
n_iteraciones = as.numeric(args[9])
porcion_undersampling = as.numeric(args[10])
prob_corte_inicial = as.numeric(args[11])

# pruebo numero de corrida hasta el llegar al ultimo numero de archivo de salida
n_corrida = 1
while(file.exists(paste0(carpeta,"/", n_corrida, ".log"))) {
  n_corrida = n_corrida + 1
}

# en estos archivos queda el resultado
rdata = paste0(carpeta,"/", n_corrida, ".RDATA" )
log = paste0(carpeta,"/", n_corrida, ".log" )
salida = paste0(carpeta,"/", n_corrida, ".json" )

# funcion objetivo
#esta es la funcion de ganancia, que se busca optimizar
#se usa internamente a LightGBM

# uso este parametro global para comunicar la funcion de ganancia con el entrenamiento y poder optimizar la prob de corte.
GLOBAL_prob_corte =  prob_corte_inicial

fganancia_logistic_lightgbm = function(probs, data)  {
  vlabels = getinfo(data, 'label')
  
  gan = sum((probs > GLOBAL_prob_corte) * ifelse(vlabels == 1, +29250, -750))
  
  return(list(name = 'ganancia',
              value =  ifelse(is.na(gan), 0, gan),
              higher_better= TRUE))
}

#------------------------------------------------------------------------------

ganancia_lgbm = function(x) {
  gc()
  
  if (as.integer(rangos_de_parametros[['min_data_in_leaf']]['desde']) == as.integer(rangos_de_parametros[['min_data_in_leaf']]['hasta'])) {
    pmin_data_in_leaf = as.integer(rangos_de_parametros[['min_data_in_leaf']]['desde'])
  } else {
    pmin_data_in_leaf = x$pmin_data_in_leaf
  }
  
  if (as.integer(rangos_de_parametros[['num_leaves']]['desde']) == as.integer(rangos_de_parametros[['num_leaves']]['hasta'])) {
    pnum_leaves = as.integer(rangos_de_parametros[['num_leaves']]['desde'])
  } else {
    pnum_leaves = x$pnum_leaves
  }
  
  if (as.numeric(rangos_de_parametros[['feature_fraction']]['desde']) == as.numeric(rangos_de_parametros[['feature_fraction']]['hasta'])) {
    pfeature_fraction = as.numeric(rangos_de_parametros[['feature_fraction']]['desde'])
  } else {
    pfeature_fraction = x$pfeature_fraction
  }
  
  if (as.numeric(rangos_de_parametros[['min_gain_to_split']]['desde']) == as.numeric(rangos_de_parametros[['min_gain_to_split']]['hasta'])) {
    pmin_gain_to_split = as.numeric(rangos_de_parametros[['min_gain_to_split']]['desde'])
  } else {
    pmin_gain_to_split = x$pmin_gain_to_split
  }
  
  if (as.numeric(rangos_de_parametros[['learning_rate']]['desde']) == as.numeric(rangos_de_parametros[['learning_rate']]['hasta'])) {
    plearning_rate = as.numeric(rangos_de_parametros[['learning_rate']]['desde'])
  } else {
    plearning_rate = x$plearning_rate
  }
  
  if (as.numeric(rangos_de_parametros[['lambda_l1']]['desde']) == as.numeric(rangos_de_parametros[['lambda_l1']]['hasta'])) {
    plambda_l1 = as.numeric(rangos_de_parametros[['lambda_l1']]['desde'])
  } else {
    plambda_l1 = x$plambda_l1
  }
  
  if (as.numeric(rangos_de_parametros[['lambda_l2']]['desde']) == as.numeric(rangos_de_parametros[['lambda_l2']]['hasta'])) {
    plambda_l2 = as.numeric(rangos_de_parametros[['lambda_l2']]['desde'])
  } else {
    plambda_l2 = x$plambda_l2
  }
  
  if (as.numeric(rangos_de_parametros[['prob_corte']]['desde']) == as.numeric(rangos_de_parametros[['prob_corte']]['hasta'])) {
    pprob_corte = as.numeric(rangos_de_parametros[['prob_corte']]['desde'])
  } else {
    pprob_corte = x$pprob_corte
  }
  
  GLOBAL_prob_corte = pprob_corte
  
  set.seed(102191) # para que siempre me de el mismo resultado
  modelo = lgb.train(data = dBO_train,
                     objective = 'binary',  # la clase es binaria
                     eval = fganancia_logistic_lightgbm,  # esta es la fuciona optimizar
                     valids = list(valid = dBO_test),
                     metric = 'custom',  # ATENCION   tremendamente importante
                     boost_from_average = TRUE,
                     num_iterations = 999999,  # un numero muy grande
                     early_stopping_rounds= as.integer(50 + 5/plearning_rate),
                     min_data_in_leaf = pmin_data_in_leaf,
                     learning_rate = plearning_rate,
                     feature_fraction = pfeature_fraction,
                     min_gain_to_split = pmin_gain_to_split,
                     num_leaves = pnum_leaves,
                     lambda_l1 = plambda_l1,
                     lambda_l2 = plambda_l2,
                     max_bin = 31,
                     verbosity = -1)
  
  nrounds_optimo = modelo$best_iter
  ganancia = unlist(modelo$record_evals$valid$ganancia$eval)[nrounds_optimo]
  
  attr(ganancia, 'extras') = list('pnum_iterations' = modelo$best_iter) # esta es la forma de devolver un parametro extra
  
  cat(ganancia, ' ')
  
  #imprimo los resultados al archivo klog
  cat(file = log, append = TRUE, sep = '',
      format(Sys.time(), '%Y%m%d_%H%M%S'), '\t',
      pmin_data_in_leaf, '\t',
      pnum_leaves, '\t',
      pfeature_fraction, '\t',
      pmin_gain_to_split, '\t',
      plearning_rate, '\t',
      plambda_l1, '\t',
      plambda_l2, '\t',
      pprob_corte, '\t',
      ganancia, '\n')
  
  return(ganancia)
}

# levanto dataset
dataset = levantar_clientes(path = dataset_path)

dataset[, baja := ifelse(baja == 'si', 1L, 0L)]

if (path_features != '-') {
  features = fread(path_features)
  features = names(features)[1:top_features]
} else {
  features = setdiff(names(dataset), c('numero_de_cliente', 'foto_mes', 'baja'))
}

# agrego la columna azar para hacer undersampling
dataset[, azar := runif(nrow(dataset)) ]

# dejo los datos en el formato que necesita LightGBM
dtrain = dataset[foto_mes_entrenamiento_desde <= foto_mes & foto_mes <= foto_mes_entrenamiento_hasta & foto_mes != foto_mes_evaluacion & (baja == 1L | azar <= porcion_undersampling)]
dBO_train = lgb.Dataset(data  = data.matrix(dtrain[, ..features]),
                        label = dtrain[, baja],
                        free_raw_data=TRUE)

dBO_test = lgb.Dataset(data  = data.matrix(dataset[foto_mes == foto_mes_evaluacion, ..features]),
                       label = dataset[foto_mes == foto_mes_evaluacion, baja],
                       free_raw_data=TRUE)

#ahora ya puedo borrar el dataset porque puse free_raw_data=TRUE
rm(dataset)
gc()

#Aqui comienza la configuracion de la Bayesian Optimization
configureMlr(show.learner.output = FALSE)

params = list()
if (as.integer(rangos_de_parametros[['min_data_in_leaf']]['desde']) != as.integer(rangos_de_parametros[['min_data_in_leaf']]['hasta'])) {
  params[['pmin_data_in_leaf']] = makeIntegerParam('pmin_data_in_leaf', lower = as.integer(rangos_de_parametros[['min_data_in_leaf']]['desde'])   , upper = as.integer(rangos_de_parametros[['min_data_in_leaf']]['hasta']))
}

if (as.integer(rangos_de_parametros[['num_leaves']]['desde']) != as.integer(rangos_de_parametros[['num_leaves']]['hasta'])) {
  params[['pnum_leaves']] = makeIntegerParam('pnum_leaves', lower = as.integer(rangos_de_parametros[['num_leaves']]['desde']), upper = as.integer(rangos_de_parametros[['num_leaves']]['hasta']))
}

if (as.numeric(rangos_de_parametros[['feature_fraction']]['desde']) != as.numeric(rangos_de_parametros[['feature_fraction']]['hasta'])) {
  params[['pfeature_fraction']] = makeNumericParam('pfeature_fraction', lower = as.numeric(rangos_de_parametros[['feature_fraction']]['desde']), upper = as.numeric(rangos_de_parametros[['feature_fraction']]['hasta']))
}

if (as.numeric(rangos_de_parametros[['min_gain_to_split']]['desde']) != as.numeric(rangos_de_parametros[['min_gain_to_split']]['hasta'])) {
  params[['pmin_gain_to_split']] = makeNumericParam('pmin_gain_to_split', lower = as.numeric(rangos_de_parametros[['min_gain_to_split']]['desde']), upper = as.numeric(rangos_de_parametros[['min_gain_to_split']]['hasta']))
}

if (as.numeric(rangos_de_parametros[['learning_rate']]['desde']) != as.numeric(rangos_de_parametros[['learning_rate']]['hasta'])) {
  params[['plearning_rate']] = makeNumericParam('plearning_rate', lower = as.numeric(rangos_de_parametros[['learning_rate']]['desde']), upper = as.numeric(rangos_de_parametros[['learning_rate']]['hasta']))
}

if (as.numeric(rangos_de_parametros[['lambda_l1']]['desde']) != as.numeric(rangos_de_parametros[['lambda_l1']]['hasta'])) {
  params[['plambda_l1']] =makeNumericParam('plambda_l1', lower = as.numeric(rangos_de_parametros[['lambda_l1']]['desde']), upper = as.numeric(rangos_de_parametros[['lambda_l1']]['hasta']))
}

if (as.numeric(rangos_de_parametros[['lambda_l2']]['desde']) != as.numeric(rangos_de_parametros[['lambda_l2']]['hasta'])) {
  params[['plambda_l2']] = makeNumericParam('plambda_l2', lower = as.numeric(rangos_de_parametros[['lambda_l2']]['desde']), upper = as.numeric(rangos_de_parametros[['lambda_l2']]['hasta']))
}

if (as.numeric(rangos_de_parametros[['prob_corte']]['desde']) != as.numeric(rangos_de_parametros[['prob_corte']]['hasta'])) {
  params[['pprob_corte']] =makeNumericParam("pprob_corte", lower = as.numeric(rangos_de_parametros[['prob_corte']]['desde']), upper = as.numeric(rangos_de_parametros[['prob_corte']]['hasta']))
}

funcion_objetivo = makeSingleObjectiveFunction(
  fn = ganancia_lgbm,
  minimize = FALSE,   #estoy Maximizando la ganancia
  noisy = TRUE,
  par.set = makeParamSet(params = params),
  # par.set = makeParamSet(
  #   makeIntegerParam('pmin_data_in_leaf', lower = as.integer(rangos_de_parametros[['min_data_in_leaf']]['desde'])   , upper = as.integer(rangos_de_parametros[['min_data_in_leaf']]['hasta'])),
  #   makeIntegerParam('pnum_leaves',       lower = as.integer(rangos_de_parametros[['num_leaves']]['desde'])   , upper = as.integer(rangos_de_parametros[['num_leaves']]['hasta'])),
  #   makeNumericParam('pfeature_fraction', lower = as.numeric(rangos_de_parametros[['feature_fraction']]['desde'])   , upper = as.numeric(rangos_de_parametros[['feature_fraction']]['hasta'])),
  #   makeNumericParam('pmin_gain_to_split',lower = as.numeric(rangos_de_parametros[['min_gain_to_split']]['desde'])   , upper = as.numeric(rangos_de_parametros[['min_gain_to_split']]['hasta'])),
  #   makeNumericParam('plearning_rate',    lower = as.numeric(rangos_de_parametros[['learning_rate']]['desde'])   , upper = as.numeric(rangos_de_parametros[['learning_rate']]['hasta'])),
  #   makeNumericParam('plambda_l1',        lower = as.numeric(rangos_de_parametros[['lambda_l1']]['desde'])   , upper = as.numeric(rangos_de_parametros[['lambda_l1']]['hasta'])),
  #   makeNumericParam('plambda_l2',        lower = as.numeric(rangos_de_parametros[['lambda_l2']]['desde'])   , upper = as.numeric(rangos_de_parametros[['lambda_l2']]['hasta'])),
  #   makeNumericParam("pprob_corte",       lower = as.numeric(rangos_de_parametros[['prob_corte']]['desde'])   , upper = as.numeric(rangos_de_parametros[['prob_corte']]['hasta']))
  # ),
  has.simple.signature = FALSE)

control = makeMBOControl(save.on.disk.at.time = Inf,  save.file.path = rdata)
control = setMBOControlTermination(control, iters = n_iteraciones)
control = setMBOControlInfill(control, crit = makeMBOInfillCritEI())

aprendedor = makeLearner('regr.km', predict.type = 'se', covtype = 'matern3_2', control = list(trace = FALSE))

if(!file.exists(rdata)) {
  # escribo cabecera del log 
  cat(file = log, 
      append = FALSE,
      sep = '',
      'fecha', '\t',
      'pmin_data_in_leaf', '\t',
      'pnum_leaves', '\t',
      'pfeature_fraction', '\t',
      'pmin_gain_to_split', '\t', 
      'plearning_rate', '\t',
      'plambda_l1', '\t',
      'plambda_l2', '\t',
      'pprob_corte', '\t',
      'ganancia','\t', 'n_iteraciones: ', n_iteraciones, '\n')
  
  # INICIO EJECUCIÓN DESDE CERO
  run = mbo(funcion_objetivo, learner = aprendedor, control = control)
} else {
  # RETOMO EJECUCIÓN
  run = mboContinue(rdata)
}

# me quedo con el pnrounds de la mejor corrida
tbl = as.data.table(run$opt.path)
setorder(tbl, -y)
mejor_pnrounds = tbl[1, pnum_iterations]

jsonsalida = paste0(
  '{
  "algoritmo" : "lgbm",
  "ganancia" : ', run$y, ',
  "nrounds" : ', mejor_pnrounds, ',
  "min_data_in_leaf" : ', run$x$pmin_data_in_leaf, ',
  "num_leaves" : ', run$x$pnum_leaves, ',
  "feature_fraction" : ', run$x$pfeature_fraction, ',
  "min_gain_to_split" : ', run$x$pmin_gain_to_split, ',
  "learning_rate" : ', run$x$plearning_rate, ',
  "lambda_l1" : ', run$x$plambda_l1, ',
  "lambda_l2" : ', run$x$plambda_l2, ',
  "prob_corte" : ', run$x$pprob_corte,
  '
  }'
)

write(x = jsonsalida, salida)