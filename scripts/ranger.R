#!/usr/bin/env Rscript

# borro todo
rm( list=ls() )

require(data.table)
require(rutiles)
require(ranger)
require(randomForest) # solo para na.roughfix

args = commandArgs(trailingOnly=TRUE)

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
dataset = fread(dataset_path, stringsAsFactors= TRUE)

# corrijo nulos
dataset  <-  na.roughfix( dataset )

# armo clase binaria 'baja':['si' , 'no']
dataset[, baja := as.factor(ifelse(clase_ternaria == 'BAJA+2', 'si', 'no'))]

# y elimino la clase ternaria
dataset[, clase_ternaria := NULL]

if (comparacion == 'mayora') {
  entrenamiento = dataset[  foto_mes >= foto_mes_entrenamiento, ]
} else if (comparacion == 'menora') {
  entrenamiento = dataset[  foto_mes <= foto_mes_entrenamiento, ]
} else if (comparacion == 'iguala') {
  entrenamiento = dataset[  foto_mes == foto_mes_entrenamiento, ]
} else {
  stop('el 1er parametro tiene que ser "mayora", "menora" o "iguala"')
}

# corro random forest
set.seed(200)
modelo = ranger( formula = "baja ~ .",
                   data = entrenamiento,
                   probability =   TRUE,  #para que devuelva las probabilidades
                   num.trees =     500,
                   mtry =          3,
                   min.node.size = 1,
                   max.depth =     0
)

# armo los datos de evaluacion
evaluacion = dataset[foto_mes == foto_mes_evaluacion, ]

# hago la prediccion y la guardo en una data.table
set.seed(200)
prediccion = predict(modelo, evaluacion)
predicciones = as.data.table(prediccion$predictions)

# armo la columna 'estimulo':[1,0]
predicciones[, estimulo := ifelse(si > 0.025, as.integer(1), as.integer(0))]

# armo data para calcular ganancia.
dganancia = data.table(real=evaluacion[, ifelse(baja=='si',as.integer(1),as.integer(0))], prediccion=predicciones[, estimulo])
rutiles::ganancia(data = dganancia) # calculo ganancia

# armo data para escribir output para kaggle
dkaggle = data.frame(numero_de_cliente=evaluacion[, numero_de_cliente], estimulo=predicciones[, estimulo])
rutiles::kaggle_csv(dkaggle, path = path_salida) # escribo output para kaggle
