
rm( list=ls() )
gc()

require("data.table")
require("rpart")
require("rpart.plot")
require('rutiles')

# prediccion_mes = function(mes, modelo, calcular_ganancia=T, para_kaggle=F, path='/home/manu/Documentos/maestria-dm/dm-eyf/kaggle/input_', devolver_prediccion=F) {
#   test = dataset[foto_mes == mes]
#
#   set.seed(200)
#   prediccion = predict(modelo, test, type = 'prob')[,'si']
#
#   if (para_kaggle) {
#     entrega = as.data.table(cbind('numero_de_cliente' = test[, numero_de_cliente],  'prob' =prediccion) )
#     entrega[  ,  estimulo :=  as.integer( prob > 0.025)]
#
#     #genero el archivo de salida
#     if( file.exists(path) ) {
#       path = cat('/home/manu/Documentos/maestria-dm/dm-eyf/kaggle/input_kaggle_',format(Sys.time(),'%Y%m%d_%H%M%S'),'.csv')
#     }
#     fwrite( entrega[ ,  c('numero_de_cliente', 'estimulo'), with=FALSE], sep=',',  file=path)
#   }
#
#   if (calcular_ganancia) {
#     ganancia = sum( (prediccion> 0.025) * test[, ifelse( baja=='si',29250,-750)])
#     cat( 'ganancia1=',  ganancia, '\n')
#   }
#
#   if (devolver_prediccion) {
#     prediccion
#   }
# }

# dataset <- fread("/home/manu/Documentos/maestria-dm/dm-eyf/datasets/paquete_premium_201906_202001.txt.gz")
# saveRDS(dataset, '/home/manu/Documentos/maestria-dm/dm-eyf/datasets/dataset_6meses.rds')
dataset = readRDS('/home/manu/Documentos/maestria-dm/dm-eyf/datasets/dataset_6meses.rds')

dataset[, baja := ifelse(clase_ternaria == 'BAJA+2', 'si', 'no')]
dataset[, clase_ternaria := NULL]

train = dataset[foto_mes == 201909]

set.seed(2020)
modelo = rpart("baja ~ . ",
                  data= train,
                  xval= 0,
                  cp=         0.0002024526,
                  maxdepth=  17,
                  minsplit=  29,
                  minbucket=  4
)

test = dataset[foto_mes==201911]

set.seed(200)
prediccion = as.data.table(predict(modelo, test))

prediccion[, estimulo := ifelse(si > 0.025, as.integer(1), as.integer(0))]

dg = data.table(real=test[, ifelse(baja=='si',as.integer(1),as.integer(0))], prediccion=prediccion[, estimulo])
rutiles::ganancia(data = dg)

# prp(modelo1, extra=1)
dkaggle = data.frame(numero_de_cliente=test[, numero_de_cliente], estimulo=prediccion[, estimulo])
rutiles::kaggle_csv(dkaggle)

# prediccion_mes(mes = 201911, modelo = modelo, calcular_ganancia = T, para_kaggle = F, '/home/manu/Documentos/maestria-dm/dm-eyf/kaggle/arbol_basico_4meses_2.csv', devolver_prediccion = F)
