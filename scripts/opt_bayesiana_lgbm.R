#!/usr/bin/env Rscript

# borro todo
rm( list=ls() )

args = commandArgs(trailingOnly=TRUE)

# PARA DEBUG
# args = c('201908', '201909', '201911', '201911', '~/repos/dmeyf/features-importantes-lgbm/features_standars.txt', 50,'~/Documentos/maestria-dm/dm-eyf/datasets/paquete_premium_201906_202001.txt.gz', '~/Documentos/maestria-dm/dm-eyf/workspace/opt_bayesiana_ranger', 2)

# test if there is at least one argument: if not, return an error
if (length(args) != 9) {
  stop("Tienen que ser 9 parametros:
  1: mes entrenamiento 'desde'
  2: mes entrenamiento 'hasta'
  3: mes evaluacion 'desde'
  4: mes evaluacion 'hasta'
  5: path features importantes: '~/features_procesadas.txt'
  6: top features importantes a usar: 10, 20, 100, ...
  7: path dataset entrada: '~/paquete_premium_201906_202001.txt.gz'
  8: carpeta salida: '~/opt_bayesiana_lgbm'
  9: número de iteraciones: 100, 200, ...",
       call.=FALSE)
}

require(data.table)
require(lightgbm)
require(rutiles)
require(DiceKriging)
require(mlrMBO)

foto_mes_entrenamiento_desde = as.integer(args[1])
foto_mes_entrenamiento_hasta = as.integer(args[2])
foto_mes_evaluacion_desde = as.integer(args[3])
foto_mes_evaluacion_hasta = as.integer(args[4])
path_features = args[5]
top_features = as.integer(args[6])
dataset_path = args[7]
carpeta = args[8]
n_iteraciones = as.numeric(args[9])

# pruebo numero de corrida hasta el llegar al ultimo numero de archivo de salida
n_corrida = 1
while(file.exists(paste0(carpeta,"/", n_corrida, ".json"))) {
  n_corrida = n_corrida + 1
}

# en estos archivos queda el resultado
rdata = paste0(carpeta,"/", n_corrida, ".RDATA" )
log = paste0(carpeta,"/", n_corrida, ".log" )
salida = paste0(carpeta,"/", n_corrida, ".json" )

# funcion objetivo
#esta es la funcion de ganancia, que se busca optimizar
#se usa internamente a LightGBM
fganancia_logistic_lightgbm = function(probs, data)  {
  vlabels = getinfo(data, 'label')
  
  gan = sum((probs > 0.025) * ifelse(vlabels == 1, +29250, -750))
  
  return(list(name = 'ganancia',
              value =  ifelse(is.na(gan), 0, gan),
              higher_better= TRUE))
}

#------------------------------------------------------------------------------

ganancia_lgbm = function(x) {
  gc()
  
  # meses = c(201908, 201907, 201906, 201905, 201904, 201903, 201902, 201901, 201812, 201811, 201810,
  # 201809, 201808, 201807, 201806, 201805, 201804, 201803, 201802, 201801, 201712, 201711, 201710, 201709)
  # vmes_desde = meses[x$pmeses]
  
  # dejo los datos en el formato que necesita LightGBM
  dBO_train = lgb.Dataset(data  = data.matrix(dataset[foto_mes_entrenamiento_desde <= foto_mes & foto_mes <= foto_mes_entrenamiento_hasta, ..features]),
                          label = dataset[foto_mes_entrenamiento_desde <= foto_mes & foto_mes <= foto_mes_entrenamiento_hasta, baja],
                          free_raw_data=TRUE)
  
  dBO_test = lgb.Dataset(data  = data.matrix(dataset[foto_mes_evaluacion_desde <= foto_mes & foto_mes <= foto_mes_evaluacion_hasta, ..features]),
                         label = dataset[foto_mes_evaluacion_desde <= foto_mes & foto_mes <= foto_mes_evaluacion_hasta, baja],
                         free_raw_data=TRUE)
  
  set.seed(102191) # para que siempre me de el mismo resultado
  modelo = lgb.train(data = dBO_train,
                     objective = 'binary',  # la clase es binaria
                     eval = fganancia_logistic_lightgbm,  # esta es la fuciona optimizar
                     valids = list(valid = dBO_test),
                     metric = 'custom',  # ATENCION   tremendamente importante
                     boost_from_average = TRUE,
                     num_iterations = 999999,  # un numero muy grande
                     early_stopping_rounds = as.integer(50 + 5/x$plearning_rate),
                     learning_rate = x$plearning_rate,
                     feature_fraction = x$pfeature_fraction,
                     min_gain_to_split = x$pmin_gain_to_split,
                     num_leaves = x$pnum_leaves,
                     lambda_l1 = x$plambda_l1,
                     lambda_l2 = x$plambda_l2,
                     max_bin = 31,
                     verbosity = -1,
                     verbose = -1)
  
  nrounds_optimo = modelo$best_iter
  ganancia = unlist(modelo$record_evals$valid$ganancia$eval)[nrounds_optimo]
  
  attr(ganancia, 'extras') = list('pnum_iterations' = modelo$best_iter) # esta es la forma de devolver un parametro extra
  
  cat(ganancia, ' ')
  
  #imprimo los resultados al archivo klog
  cat(file = log, append = TRUE, sep = '',
      format(Sys.time(), '%Y%m%d_%H%M%S'), '\t',
      x$pnum_leaves, '\t',
      x$pfeature_fraction, '\t',
      x$pmin_gain_to_split, '\t',
      x$plearning_rate, '\t',
      x$plambda_l1, '\t',
      x$plambda_l2, '\t',
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

entrenamiento = dataset[foto_mes_entrenamiento_desde <= foto_mes & foto_mes <= foto_mes_entrenamiento_hasta, ]
evaluacion = dataset[foto_mes_evaluacion_desde <= foto_mes & foto_mes <= foto_mes_evaluacion_hasta, ]

#Aqui comienza la configuracion de la Bayesian Optimization
configureMlr(show.learner.output = FALSE)

funcion_objetivo = makeSingleObjectiveFunction(
  fn = ganancia_lgbm,
  minimize = FALSE,   #estoy Maximizando la ganancia
  noisy = TRUE,
  par.set = makeParamSet(
    makeIntegerParam('pnum_leaves',       lower = 8L   , upper = 1023L),
    makeNumericParam('pfeature_fraction', lower = 0.10 , upper = 1.0),
    makeNumericParam('pmin_gain_to_split',lower = 0.0  , upper = 20),
    makeNumericParam('plearning_rate',    lower = 0.0005 , upper = 0.005),
    makeNumericParam('plambda_l1',        lower = 0.0  , upper = 10),
    makeNumericParam('plambda_l2',        lower = 0.0, upper = 100)
    # makeIntegerParam('pmeses',            lower = 1L, upper = 20L)
  ),
  has.simple.signature = FALSE)

control = makeMBOControl(save.on.disk.at.time = 600,  save.file.path = rdata)
control = setMBOControlTermination(control, iters = n_iteraciones)
control = setMBOControlInfill(control, crit = makeMBOInfillCritEI())

aprendedor = makeLearner('regr.km', predict.type = 'se', covtype = 'matern3_2', control = list(trace = FALSE))

if(!file.exists(rdata)) {
  # escribo cabecera del log 
  cat(file = log, 
      append = FALSE,
      sep = '',
      'fecha', '\t',
      'pnum_leaves', '\t',
      'pfeature_fraction', '\t',
      'pmin_gain_to_split', '\t', 
      'plearning_rate', '\t',
      'plambda_l1', '\t',
      'plambda_l2', '\t',
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
  "num_leaves" : ', run$x$pnum_leaves, ',
  "feature_fraction" : ', run$x$pfeature_fraction, ',
  "min_gain_to_split" : ', run$x$pmin_gain_to_split, ',
  "learning_rate" : ', run$x$plearning_rate, ',
  "lambda_l1" : ', run$x$plambda_l1, ',
  "lambda_l2" : ', run$x$plambda_l2,
  '
  }'
)

write(x = jsonsalida, salida)