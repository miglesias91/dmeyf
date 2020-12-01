!#/bin/bash

Rscript --vanilla ~/repos/dmeyf/scripts/lgbm.R 201701 202001 202003 99999 min_data_in_leaf=15000-feature_fraction=0.5-learning_rate=0.02 0.05 0.2 2 ~/repos/dmeyf/features-importantes-lgbm/minmax_hist3_lags_deltas.txt 400 ~/buckets/b1/datasets/minmax_hist3_lags_deltas.txt.gz ~/buckets/b1/work/probs/lgbm/20201201/minmax_hist3_lags_deltas.csv F T > corrida_lgbm_hist3_lags_deltas.txt &&

Rscript --vanilla ~/repos/dmeyf/scripts/lgbm.R 201701 201912 202002 99999 min_data_in_leaf=15000-feature_fraction=0.5-learning_rate=0.02 0.05 0.2 2 ~/repos/dmeyf/features-importantes-lgbm/minmax_hist6_lags_deltas.txt 400 ~/buckets/b1/datasets/minmax_hist6_lags_deltas.txt.gz ~/buckets/b1/work/probs/lgbm/20201201/minmax_hist6_lags_deltas.csv F T > corrida_lgbm_hist6_lags_deltas.txt &&

Rscript --vanilla ~/repos/dmeyf/scripts/lgbm.R 201701 201911 202001 99999 min_data_in_leaf=15000-feature_fraction=0.5-learning_rate=0.02 0.05 0.2 2 ~/repos/dmeyf/features-importantes-lgbm/minmax_hist9_lags_deltas.txt 400 ~/buckets/b1/datasets/minmax_hist9_lags_deltas.txt.gz ~/buckets/b1/work/probs/lgbm/20201201/minmax_hist9_lags_deltas.csv F T > corrida_lgbm_hist9_lags_deltas.txt &&

Rscript --vanilla ~/repos/dmeyf/scripts/lgbm.R 201701 201910 201912 99999 min_data_in_leaf=15000-feature_fraction=0.5-learning_rate=0.02 0.05 0.2 2 ~/repos/dmeyf/features-importantes-lgbm/minmax_hist12_lags_deltas.txt 400 ~/buckets/b1/datasets/minmax_hist12_lags_deltas.txt.gz ~/buckets/b1/work/probs/lgbm/20201201/minmax_hist12_lags_deltas.csv F T > corrida_lgbm_hist12_lags_deltas.txt &&

Rscript --vanilla ~/repos/dmeyf/scripts/lgbm.R 201701 201909 201911 99999 min_data_in_leaf=15000-feature_fraction=0.5-learning_rate=0.02 0.05 0.2 2 ~/repos/dmeyf/features-importantes-lgbm/minmax_hist12_lags_deltas.txt 400 ~/buckets/b1/datasets/minmax_hist12_lags_deltas.txt.gz ~/buckets/b1/work/probs/lgbm/20201201/minmax_hist12_lags_deltas.csv F T > corrida_lgbm_hist12_lags_deltas.txt &&

Rscript --vanilla ~/repos/dmeyf/scripts/lgbm.R 201701 201908 201910 99999 min_data_in_leaf=15000-feature_fraction=0.5-learning_rate=0.02 0.05 0.2 2 ~/repos/dmeyf/features-importantes-lgbm/minmax_hist12_lags_deltas.txt 400 ~/buckets/b1/datasets/minmax_hist12_lags_deltas.txt.gz ~/buckets/b1/work/probs/lgbm/20201201/minmax_hist12_lags_deltas.csv F T > corrida_lgbm_hist12_lags_deltas.txt &&
