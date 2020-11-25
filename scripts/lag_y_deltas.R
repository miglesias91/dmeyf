#necesita de 128GB de memoria RAM
#limpio la memoria
rm( list=ls() )  #remove all objects
gc()             #garbage collection

args = commandArgs(trailingOnly=TRUE)

# PARA DEBUG
# args = c('201908', '201909', '201911', 'min_data_in_leaf=100_1000', '~/repos/dmeyf/features-importantes-lgbm/features_standars.txt', 50,'~/Documentos/maestria-dm/dm-eyf/datasets/paquete_premium_201906_202001.txt.gz', '~/Documentos/maestria-dm/dm-eyf/workspace/opt_bayesiana_ranger', 2, 0.05, 0.2)
# args = c('201908', '201909', '201911', 'min_data_in_leaf=100_1000', '~/repos/dmeyf/features-importantes-lgbm/features_standars.txt', 50,'~/buckets/b1/datasets/paquete_premium_201906_202001.txt.gz', '~/buckets/b2/opt_bayesiana_lgbm', 3, 0.05, 0.2)

# test if there is at least one argument: if not, return an error
if (length(args) != 2) {
  stop('Tienen que ser 2 parametros:
       1: path dataset entrada: ~/paquete_premium_201906_202001.txt.gz
       2: path de salida: ~/feature_eng_paquete_premium_201906_202001.txt.gz
       ',
       call.=FALSE)
}

require('data.table')
require('lightgbm')
require('stringr')

dataset_path = args[1]
dataset_path_salida = args[2]

#cargo el dataset donde voy a entrenar
dataset = fread(dataset_path)

var_diff_y_acums = c(str_subset(names(dataset), 'acum_'), str_subset(names(dataset), 'var_'), str_subset(names(dataset), 'diff_'))

#creo los campos lags 'el valor del mes anterior'
setorderv( dataset, c('numero_de_cliente','foto_mes') ) #ordeno
campos_lags = setdiff(  colnames(dataset) ,  c('clase_ternaria', 'numero_de_cliente', var_diff_y_acums) )
dataset[,  paste0( 'lag1_', campos_lags) := shift(.SD, 1, NA, 'lag'), by = numero_de_cliente, .SDcols = campos_lags]
dataset[,  paste0( 'lag2_', campos_lags) := shift(.SD, 2, NA, 'lag'), by = numero_de_cliente, .SDcols = campos_lags]

for( vcol in campos_lags ) {
  dataset[, paste0('delta1_', vcol) := get(vcol) - get( paste0('lag1_', vcol) ) ]
  dataset[, paste0('delta2_', vcol) := get(vcol) - get( paste0('lag2_', vcol) ) ]
  dataset[, paste0('delta3_', vcol) := get( paste0('lag1_', vcol) ) - get( paste0('lag2_', vcol) ) ]
}

fwrite(dataset, file = dataset_path_salida, sep = '\t')

rm( list = ls() )  #remove all objects
gc()             #garbage collection