!#/bin/bash

Rscript --vanilla repos/dmeyf/scripts/lgbm_vali.R 201701 201801 201803 33 min_data_in_leaf=131-feature_fraction=0.25-learning_rate=0.02 0.2_0.2_1 2 - 0 0.05 ~/buckets/b1/datasets/lags_deltas_final.txt.gz ~/buckets/b1/work/validaciones/lineasdemuerte.txt > corrida_lineasdemuerte.txt &&

Rscript --vanilla repos/dmeyf/scripts/lgbm_vali.R 201801 201901 201903 33 min_data_in_leaf=131-feature_fraction=0.25-learning_rate=0.02 0.2_0.2_1 2 - 0 0.05 ~/buckets/b1/datasets/lags_deltas_final.txt.gz ~/buckets/b1/work/validaciones/lineasdemuerte.txt > corrida_lineasdemuerte.txt &&

Rscript --vanilla repos/dmeyf/scripts/lgbm_vali.R 201901 202001 202003 33 min_data_in_leaf=131-feature_fraction=0.25-learning_rate=0.02 0.2_0.2_1 2 - 0 0.05 ~/buckets/b1/datasets/lags_deltas_final.txt.gz ~/buckets/b1/work/validaciones/lineasdemuerte.txt > corrida_lineasdemuerte.txt &&

Rscript --vanilla repos/dmeyf/scripts/lgbm_vali.R 201701 201901 201903 33 min_data_in_leaf=131-feature_fraction=0.25-learning_rate=0.02 0.2_0.2_1 2 - 0 0.05 ~/buckets/b1/datasets/lags_deltas_final.txt.gz ~/buckets/b1/work/validaciones/lineasdemuerte.txt > corrida_lineasdemuerte.txt &&

Rscript --vanilla repos/dmeyf/scripts/lgbm_vali.R 201801 202001 202003 33 min_data_in_leaf=131-feature_fraction=0.25-learning_rate=0.02 0.2_0.2_1 2 - 0 0.05 ~/buckets/b1/datasets/lags_deltas_final.txt.gz ~/buckets/b1/work/validaciones/lineasdemuerte.txt > corrida_lineasdemuerte.txt &&

Rscript --vanilla repos/dmeyf/scripts/lgbm_vali.R 201701 202001 202003 33 min_data_in_leaf=131-feature_fraction=0.25-learning_rate=0.02 0.2_0.2_1 2 - 0 0.05 ~/buckets/b1/datasets/lags_deltas_final.txt.gz ~/buckets/b1/work/validaciones/lineasdemuerte.txt > corrida_lineasdemuerte.txt
