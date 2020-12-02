!#/bin/bash

Rscript --vanilla ~/repos/dmeyf/scripts/lgbm.R 201707 202003 202005 99999 min_data_in_leaf=15000-feature_fraction=0.75-learning_rate=0.01 0.05 0.2 2 ~/repos/dmeyf/features-importantes-lgbm/minmax_hist3_lags_deltas.txt 400 ~/buckets/b1/datasets/minmax_hist3_lags_deltas.txt.gz ~/buckets/b1/work/probs/lgbm/20201202/minmax_hist3_lags_deltas.csv F T > corrida_lgbm_hist3_lags_deltas.txt &&

Rscript --vanilla ~/repos/dmeyf/scripts/lgbm.R 201707 202003 202005 99999 min_data_in_leaf=15000-feature_fraction=0.75-learning_rate=0.01 0.05 0.2 2 ~/repos/dmeyf/features-importantes-lgbm/minmax_hist6_lags_deltas.txt 400 ~/buckets/b1/datasets/minmax_hist6_lags_deltas.txt.gz ~/buckets/b1/work/probs/lgbm/20201202/minmax_hist6_lags_deltas.csv F T > corrida_lgbm_hist6_lags_deltas.txt &&

Rscript --vanilla ~/repos/dmeyf/scripts/lgbm.R 201707 202003 202005 99999 min_data_in_leaf=15000-feature_fraction=0.75-learning_rate=0.01 0.05 0.2 2 ~/repos/dmeyf/features-importantes-lgbm/minmax_hist9_lags_deltas.txt 400 ~/buckets/b1/datasets/minmax_hist9_lags_deltas.txt.gz ~/buckets/b1/work/probs/lgbm/20201202/minmax_hist9_lags_deltas.csv F T > corrida_lgbm_hist9_lags_deltas.txt &&

Rscript --vanilla ~/repos/dmeyf/scripts/lgbm.R 201707 202003 202005 99999 min_data_in_leaf=15000-feature_fraction=0.75-learning_rate=0.01 0.05 0.2 2 ~/repos/dmeyf/features-importantes-lgbm/minmax_hist12_lags_deltas.txt 400 ~/buckets/b1/datasets/minmax_hist12_lags_deltas.txt.gz ~/buckets/b1/work/probs/lgbm/20201202/minmax_hist12_lags_deltas.csv F T > corrida_lgbm_hist12_lags_deltas.txt
