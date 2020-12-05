!#/bin/bash

Rscript --vanilla ~/repos/dmeyf/scripts/lgbm.R 201701 202003 201912 202005 99999 min_data_in_leaf=2000-feature_fraction=0.5-learning_rate=0.0175-num_leaves=750-min_gain_to_split=0.006-lambda_l1=5.5-lambda_l2=5.5 0.05 0.2 2 ~/repos/dmeyf/features-importantes-lgbm/minmax_hist3_lags_deltas.txt 400 ~/buckets/b1/datasets/minmax_hist3_lags_deltas.txt.gz ~/buckets/b1/work/probs/lgbm/20201205/minmax_hist3_lags_deltas.csv F T T > corrida_lgbm_hist3_lags_deltas.txt &&

Rscript --vanilla ~/repos/dmeyf/scripts/lgbm.R 201701 202003 201912 202005 99999 min_data_in_leaf=2073-feature_fraction=0.5-learning_rate=0.0175-num_leaves=517-min_gain_to_split=0.12-lambda_l1=0.03-lambda_l2=5.0 0.05 0.2 2 ~/repos/dmeyf/features-importantes-lgbm/minmax_hist9_lags_deltas.txt 400 ~/buckets/b1/datasets/minmax_hist9_lags_deltas.txt.gz ~/buckets/b1/work/probs/lgbm/20201205/minmax_hist9_lags_deltas.csv F T T > corrida_lgbm_hist9_lags_deltas.txt &&

Rscript --vanilla ~/repos/dmeyf/scripts/lgbm.R 201701 202003 201912 202005 99999 min_data_in_leaf=2292-feature_fraction=0.5-learning_rate=0.0175-num_leaves=720-min_gain_to_split=0.5-lambda_l1=0.06-lambda_l2=19.0 0.05 0.2 2 ~/repos/dmeyf/features-importantes-lgbm/minmax_hist12_lags_deltas.txt 400 ~/buckets/b1/datasets/minmax_hist12_lags_deltas.txt.gz ~/buckets/b1/work/probs/lgbm/20201205/minmax_hist12_lags_deltas.csv F T T > corrida_lgbm_hist12_lags_deltas.txt &&

Rscript --vanilla ~/repos/dmeyf/scripts/lgbm.R 201701 202003 201912 202005 99999 min_data_in_leaf=2000-feature_fraction=0.5-learning_rate=0.0175-num_leaves=750-min_gain_to_split=0.006-lambda_l1=5.5-lambda_l2=5.5 0.05 0.2 2 ~/repos/dmeyf/features-importantes-lgbm/minmax_hist3_lags_deltas.txt 400 ~/buckets/b1/datasets/minmax_hist3_lags_deltas.txt.gz ~/buckets/b1/work/probs/lgbm/20201205/minmax_hist3_lags_deltas_con_meses_fallados.csv F T F > corrida_lgbm_hist3_lags_deltas_con_meses_fallados.txt &&

Rscript --vanilla ~/repos/dmeyf/scripts/lgbm.R 201701 202003 201912 202005 99999 min_data_in_leaf=2073-feature_fraction=0.5-learning_rate=0.0175-num_leaves=517-min_gain_to_split=0.12-lambda_l1=0.03-lambda_l2=5.0 0.05 0.2 2 ~/repos/dmeyf/features-importantes-lgbm/minmax_hist9_lags_deltas.txt 400 ~/buckets/b1/datasets/minmax_hist9_lags_deltas.txt.gz ~/buckets/b1/work/probs/lgbm/20201205/minmax_hist9_lags_deltas_con_meses_fallados.csv F T F > corrida_lgbm_hist9_lags_deltas_con_meses_fallados.txt &&

Rscript --vanilla ~/repos/dmeyf/scripts/lgbm.R 201701 202003 201912 202005 99999 min_data_in_leaf=2292-feature_fraction=0.5-learning_rate=0.0175-num_leaves=720-min_gain_to_split=0.5-lambda_l1=0.06-lambda_l2=19.0 0.05 0.2 2 ~/repos/dmeyf/features-importantes-lgbm/minmax_hist12_lags_deltas.txt 400 ~/buckets/b1/datasets/minmax_hist12_lags_deltas.txt.gz ~/buckets/b1/work/probs/lgbm/20201205/minmax_hist12_lags_deltas_con_meses_fallados.csv F T F > corrida_lgbm_hist12_lags_deltas_con_meses_fallados.txt


