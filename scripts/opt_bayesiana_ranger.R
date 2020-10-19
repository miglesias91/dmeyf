#!/usr/bin/env Rscript

# borro todo
rm( list=ls() )

require(data.table)
require(ranger)
require(rutiles)
require(DiceKriging)
require(mlrMBO)

args = commandArgs(trailingOnly=TRUE)

# PARA DEBUG
# args = c('iguala', '201909', '201911', '~/Documentos/maestria-dm/dm-eyf/datasets/paquete_premium_201906_202001.txt.gz', '~/Documentos/maestria-dm/dm-eyf/workspace/opt_bayesiana_ranger', 2)

# test if there is at least one argument: if not, return an error
if ( length(args) != 6) {
  stop("Tienen que ser 6 parametros:
  1: 'mayora', 'menora' o 'iguala'
  2: meses de entrenamiento: 201911, 201910, ...
  3: mes de evaluacion: 202001, 201911, ...
  4: path dataset entrada: '~/paquete_premium_201906_202001.txt.gz'
  5: carpeta salida: '~/opt_bayesiana_ranger'
  6: número de iteraciones: 100, 200, ...",
      call.=FALSE)
}

comparacion = args[1]
foto_mes_entrenamiento = as.integer(args[2])
foto_mes_evaluacion = as.integer(args[3])
dataset_path = args[4]
carpeta = args[5]
n_iteraciones = as.numeric(args[6])

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
ganancia_ranger = function( x )
{
  modelo = ranger( formula = paste0(clase_a_predecir, ' ~ .'),
                   data = entrenamiento,  #aqui considero los 6 meses de 201906 a 201912
                   probability =   TRUE,  #para que devuelva las probabilidades
                   num.trees =     x$pnum.trees,
                   mtry =          x$pmtry,
                   min.node.size = x$pmin.node.size,
                   max.depth =     x$pmax.depth
  )
  
  #aplico el modelo a testing
  prediccion = predict(modelo, evaluacion)
  
  #calculo la ganancia en los datos de testing
  g = sum((prediccion$predictions[ , 'si'] > 0.025) * evaluacion[, ifelse(baja == 'si', 29250, -750)])
  
  #imprimo los resultados al archivo klog
  cat(file = log, append= TRUE, sep="",
      format(Sys.time(), "%Y%m%d_%H%M%S"), "\t",
      x$pnum.trees, "\t",
      x$pmtry, "\t",
      x$pmin.node.size, "\t",
      x$pmax.depth, "\t",
      g, "\n"
  )
  
  return(g)
}

# parametros de prediccion
clase_a_predecir = 'baja'
factor_positivo = 'si'
factor_negativo = 'no'

# levanto dataset
dataset = levantar_clientes(path = dataset_path, nombre_clase_binaria = clase_a_predecir, positivo = factor_positivo,
                            negativo = factor_negativo, fix_nulos = T)

if (comparacion == 'mayora') {
  entrenamiento = dataset[  foto_mes >= foto_mes_entrenamiento, ]
} else if (comparacion == 'menora') {
  entrenamiento = dataset[  foto_mes <= foto_mes_entrenamiento, ]
} else if (comparacion == 'iguala') {
  entrenamiento = dataset[  foto_mes == foto_mes_entrenamiento, ]
} else {
  stop('el 1er parametro tiene que ser "mayora", "menora" o "iguala"')
}

evaluacion = dataset[foto_mes == foto_mes_evaluacion, ]



#Aqui comienza la configuracion de la Bayesian Optimization
configureMlr(show.learner.output = FALSE)

funcion_objetivo = makeSingleObjectiveFunction(
  fn = ganancia_ranger,
  minimize = FALSE,   #estoy Maximizando la ganancia
  noisy = TRUE,
  par.set = makeParamSet(
    makeIntegerParam("pnum.trees",     lower = 100L, upper = 999L),
    makeIntegerParam("pmtry",          lower = 2L, upper = 20L),
    makeIntegerParam("pmin.node.size", lower = 1L, upper = 40L),
    makeIntegerParam("pmax.depth",     lower = 0L, upper = 20L)),
  has.simple.signature = FALSE
)
control = makeMBOControl(save.on.disk.at.time = 60,  save.file.path = rdata)
control = setMBOControlTermination(control, iters = n_iteraciones)
control = setMBOControlInfill(control, crit = makeMBOInfillCritEI())

aprendedor = makeLearner('regr.km', predict.type = 'se', covtype = 'matern3_2', control = list(trace = FALSE))

if(!file.exists(rdata)) {
  # escribo cabecera del log 
  cat(file= log, 
      append= FALSE,
      sep='',
      'fecha', '\t',
      'num.trees', '\t',
      'mtry', '\t', 
      'min.node.size', '\t',
      'max.depth', '\t',
      'ganancia', '\n')
  
  # INICIO EJECUCIÓN DESDE CERO
  run = mbo(funcion_objetivo, learner = aprendedor, control = control)
} else {
  # RETOMO EJECUCIÓN
  run = mboContinue(rdata)
}

jsonsalida = paste0(
'{
"algoritmo" : "ranger",
"n_arboles" : ', run$x$pnum.trees,',
"n_split" : ', run$x$pmtry,',
"nodo_min" : ', run$x$pmin.node.size,',
"profundidad_max" :', run$x$pmax.depth,
'
}'
)

write(x = jsonsalida, salida)