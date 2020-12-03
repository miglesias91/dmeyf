!#/bin/bash

Rscript --vanilla ~/repos/dmeyf/scripts/opt_bayesiana_lgbm_v2.R 201707 202003 201905 min_data_in_leaf=2000_20000-feature_fraction=0.5_0.5-learning_rate=0.02_0.02-num_leaves=100-1000-min_gain_to_split=0.005_0.8-lambda_l1=0.01_10-lambda_l2=5_100-0.5-prob_corte=0.2_0.2 ~/repos/dmeyf/features-importantes-lgbm/minmax_hist3_lags_deltas.txt 400 ~/buckets/b1/datasets/minmax_hist3_lags_deltas.txt.gz ~/buckets/b2/opt_bayesiana_lgbm 60 0.05 0.2 > ~/corrida_ob_hist3_lags_deltas.txt &&

Rscript --vanilla ~/repos/dmeyf/scripts/opt_bayesiana_lgbm_v2.R 201707 202003 201905 min_data_in_leaf=2000_20000-feature_fraction=0.5_0.5-learning_rate=0.02_0.02-num_leaves=100-1000-min_gain_to_split=0.005_0.8-lambda_l1=0.01_10-lambda_l2=5_100-0.5-prob_corte=0.2_0.2 ~/repos/dmeyf/features-importantes-lgbm/minmax_hist6_lags_deltas.txt 400 ~/buckets/b1/datasets/minmax_hist6_lags_deltas.txt.gz ~/buckets/b2/opt_bayesiana_lgbm 60 0.05 0.2 > ~/corrida_ob_hist6_lags_deltas.txt &&

Rscript --vanilla ~/repos/dmeyf/scripts/opt_bayesiana_lgbm_v2.R 201707 202003 201905 min_data_in_leaf=2000_20000-feature_fraction=0.5_0.5-learning_rate=0.02_0.02-num_leaves=100-1000-min_gain_to_split=0.005_0.8-lambda_l1=0.01_10-lambda_l2=5_100-0.5-prob_corte=0.2_0.2 ~/repos/dmeyf/features-importantes-lgbm/minmax_hist9_lags_deltas.txt 400 ~/buckets/b1/datasets/minmax_hist9_lags_deltas.txt.gz ~/buckets/b2/opt_bayesiana_lgbm 60 0.05 0.2 > ~/corrida_ob_hist9_lags_deltas.txt &&

Rscript --vanilla ~/repos/dmeyf/scripts/opt_bayesiana_lgbm_v2.R 201707 202003 201905 min_data_in_leaf=2000_20000-feature_fraction=0.5_0.5-learning_rate=0.02_0.02-num_leaves=100-1000-min_gain_to_split=0.005_0.8-lambda_l1=0.01_10-lambda_l2=5_100-0.5-prob_corte=0.2_0.2 ~/repos/dmeyf/features-importantes-lgbm/minmax_hist12_lags_deltas.txt 400 ~/buckets/b1/datasets/minmax_hist12_lags_deltas.txt.gz ~/buckets/b2/opt_bayesiana_lgbm 60 0.05 0.2 > ~/corrida_ob_hist12_lags_deltas.txt
