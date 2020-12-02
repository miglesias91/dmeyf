!#/bin/bash

Rscript --vanilla ~/repos/dmeyf/scripts/lgbm_ob_vali.R 201701 202001 202003 min_data_in_leaf=15000_15000-feature_fraction=0.5_0.5-learning_rate=0.02_0.02-prob_corte=0.2_0.2 ~/repos/dmeyf/features-importantes-lgbm/minmax_hist9_lags_deltas.txt 400 ~/buckets/b1/datasets/minmax_hist9_lags_deltas.txt.gz ~/buckets/b2/opt_bayesiana_lgbm 10 0.05 0.2 ~/buckets/b1/validaciones/publico_y_privado.txt 10 F &&

Rscript --vanilla ~/repos/dmeyf/scripts/lgbm_ob_vali.R 201701 201912 202002 min_data_in_leaf=15000_15000-feature_fraction=0.5_0.5-learning_rate=0.02_0.02-prob_corte=0.2_0.2 ~/repos/dmeyf/features-importantes-lgbm/minmax_hist9_lags_deltas.txt 400 ~/buckets/b1/datasets/minmax_hist9_lags_deltas.txt.gz ~/buckets/b2/opt_bayesiana_lgbm 10 0.05 0.2 ~/buckets/b1/validaciones/publico_y_privado.txt 10 F &&

Rscript --vanilla ~/repos/dmeyf/scripts/lgbm_ob_vali.R 201701 201911 202001 min_data_in_leaf=15000_15000-feature_fraction=0.5_0.5-learning_rate=0.02_0.02-prob_corte=0.2_0.2 ~/repos/dmeyf/features-importantes-lgbm/minmax_hist9_lags_deltas.txt 400 ~/buckets/b1/datasets/minmax_hist9_lags_deltas.txt.gz ~/buckets/b2/opt_bayesiana_lgbm 10 0.05 0.2 ~/buckets/b1/validaciones/publico_y_privado.txt 10 F &&

Rscript --vanilla ~/repos/dmeyf/scripts/lgbm_ob_vali.R 201701 201910 201912 min_data_in_leaf=15000_15000-feature_fraction=0.5_0.5-learning_rate=0.02_0.02-prob_corte=0.2_0.2 ~/repos/dmeyf/features-importantes-lgbm/minmax_hist9_lags_deltas.txt 400 ~/buckets/b1/datasets/minmax_hist9_lags_deltas.txt.gz ~/buckets/b2/opt_bayesiana_lgbm 10 0.05 0.2 ~/buckets/b1/validaciones/publico_y_privado.txt 10 F &&

Rscript --vanilla ~/repos/dmeyf/scripts/lgbm_ob_vali.R 201701 201909 201911 min_data_in_leaf=15000_15000-feature_fraction=0.5_0.5-learning_rate=0.02_0.02-prob_corte=0.2_0.2 ~/repos/dmeyf/features-importantes-lgbm/minmax_hist9_lags_deltas.txt 400 ~/buckets/b1/datasets/minmax_hist9_lags_deltas.txt.gz ~/buckets/b2/opt_bayesiana_lgbm 10 0.05 0.2 ~/buckets/b1/validaciones/publico_y_privado.txt 10 F &&

Rscript --vanilla ~/repos/dmeyf/scripts/lgbm_ob_vali.R 201701 201908 201910 min_data_in_leaf=15000_15000-feature_fraction=0.5_0.5-learning_rate=0.02_0.02-prob_corte=0.2_0.2 ~/repos/dmeyf/features-importantes-lgbm/minmax_hist9_lags_deltas.txt 400 ~/buckets/b1/datasets/minmax_hist9_lags_deltas.txt.gz ~/buckets/b2/opt_bayesiana_lgbm 10 0.05 0.2 ~/buckets/b1/validaciones/publico_y_privado.txt 10 F &&

Rscript --vanilla ~/repos/dmeyf/scripts/lgbm_ob_vali.R 201701 201907 201909 min_data_in_leaf=15000_15000-feature_fraction=0.5_0.5-learning_rate=0.02_0.02-prob_corte=0.2_0.2 ~/repos/dmeyf/features-importantes-lgbm/minmax_hist9_lags_deltas.txt 400 ~/buckets/b1/datasets/minmax_hist9_lags_deltas.txt.gz ~/buckets/b2/opt_bayesiana_lgbm 10 0.05 0.2 ~/buckets/b1/validaciones/publico_y_privado.txt 10 F
