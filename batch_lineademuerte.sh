!#/bin/bash

Rscript --vanilla repos/dmeyf/scripts/lgbm_vali.R 201707 201807 201809 447 min_data_in_leaf=1000-feature_fraction=0.25-learning_rate=0.02 0.2_0.2_1 2 ~/repos/dmeyf/features-importantes-lgbm/minmax_lagdeltas_hist6meses.txt 300 0.05 ~/buckets/b1/datasets/minmax_lags_deltas_hist6meses_final.txt.gz ~/buckets/b1/work/validaciones/lineasdemuerte.txt > corrida_lineasdemuerte.txt &&

Rscript --vanilla repos/dmeyf/scripts/lgbm_vali.R 201807 201907 201909 447 min_data_in_leaf=1000-feature_fraction=0.25-learning_rate=0.02 0.2_0.2_1 2 ~/repos/dmeyf/features-importantes-lgbm/minmax_lagdeltas_hist6meses.txt 300 0.05 ~/buckets/b1/datasets/minmax_lags_deltas_hist6meses_final.txt.gz ~/buckets/b1/work/validaciones/lineasdemuerte.txt > corrida_lineasdemuerte.txt &&

Rscript --vanilla repos/dmeyf/scripts/lgbm_vali.R 201707 201907 201909 447 min_data_in_leaf=1000-feature_fraction=0.25-learning_rate=0.02 0.2_0.2_1 2 ~/repos/dmeyf/features-importantes-lgbm/minmax_lagdeltas_hist6meses.txt 300 0.05 ~/buckets/b1/datasets/minmax_lags_deltas_hist6meses_final.txt.gz ~/buckets/b1/work/validaciones/lineasdemuerte.txt > corrida_lineasdemuerte.txt &&

Rscript --vanilla repos/dmeyf/scripts/lgbm_vali.R 201707 202001 202003 447 min_data_in_leaf=1000-feature_fraction=0.25-learning_rate=0.02 0.2_0.2_1 2 ~/repos/dmeyf/features-importantes-lgbm/minmax_lagdeltas_hist6meses.txt 300 0.05 ~/buckets/b1/datasets/minmax_lags_deltas_hist6meses_final.txt.gz ~/buckets/b1/work/validaciones/lineasdemuerte.txt > corrida_lineasdemuerte.txt &&

Rscript --vanilla repos/dmeyf/scripts/lgbm_vali.R 201901 202001 202003 447 min_data_in_leaf=1000-feature_fraction=0.25-learning_rate=0.02 0.2_0.2_1 2 ~/repos/dmeyf/features-importantes-lgbm/minmax_lagdeltas_hist6meses.txt 300 0.05 ~/buckets/b1/datasets/minmax_lags_deltas_hist6meses_final.txt.gz ~/buckets/b1/work/validaciones/lineasdemuerte.txt > corrida_lineasdemuerte.txt &&

Rscript --vanilla repos/dmeyf/scripts/lgbm_vali.R 201801 201901 201903 447 min_data_in_leaf=1000-feature_fraction=0.25-learning_rate=0.02 0.2_0.2_1 2 ~/repos/dmeyf/features-importantes-lgbm/minmax_lagdeltas_hist6meses.txt 300 0.05 ~/buckets/b1/datasets/minmax_lags_deltas_hist6meses_final.txt.gz ~/buckets/b1/work/validaciones/lineasdemuerte.txt > corrida_lineasdemuerte.txt
