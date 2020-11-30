!#/bin/bash

Rscript --vanilla ~/repos/dmeyf/scripts/lgbm.R 201801 202003 202005 500 min_data_in_leaf=1000-feature_fraction=0.25-learning_rate=0.02 0.5 0.05 2 - 0 ~/buckets/b1/datasets/minmax_hist12.txt.gz ~/buckets/b1/work/probs/lgbm/20201129/minmax_hist12.csv T T > corrida_lgbm_hist12.txt &&

Rscript --vanilla ~/repos/dmeyf/scripts/lgbm.R 201801 202003 202005 500 min_data_in_leaf=1000-feature_fraction=0.25-learning_rate=0.02 0.5 0.05 2 - 0 ~/buckets/b1/datasets/minmax_hist12_lags_deltas.txt.gz ~/buckets/b1/work/probs/lgbm/20201129/minmax_hist12_lags_deltas.csv T T > corrida_lgbm_hist12_lags_deltas.txt &&

Rscript --vanilla ~/repos/dmeyf/scripts/lgbm.R 201704 202003 202005 500 min_data_in_leaf=1000-feature_fraction=0.25-learning_rate=0.02 0.5 0.05 2 - 0 ~/buckets/b1/datasets/minmax_hist3.txt.gz ~/buckets/b1/work/probs/lgbm/20201129/minmax_hist3.csv T T > corrida_lgbm_hist3.txt &&

Rscript --vanilla ~/repos/dmeyf/scripts/lgbm.R 201704 202003 202005 500 min_data_in_leaf=1000-feature_fraction=0.25-learning_rate=0.02 0.5 0.05 2 - 0 ~/buckets/b1/datasets/minmax_hist3_lags_deltas.txt.gz ~/buckets/b1/work/probs/lgbm/20201129/minmax_hist3_lags_deltas.csv T T > corrida_lgbm_hist3_lags_deltas.txt &&

Rscript --vanilla ~/repos/dmeyf/scripts/lgbm.R 201710 202003 202005 500 min_data_in_leaf=1000-feature_fraction=0.25-learning_rate=0.02 0.5 0.05 2 - 0 ~/buckets/b1/datasets/minmax_hist9.txt.gz ~/buckets/b1/work/probs/lgbm/20201129/minmax_hist9.csv T T > corrida_lgbm_hist9.txt &&

Rscript --vanilla ~/repos/dmeyf/scripts/lgbm.R 201710 202003 202005 500 min_data_in_leaf=1000-feature_fraction=0.25-learning_rate=0.02 0.5 0.05 2 - 0 ~/buckets/b1/datasets/minmax_hist9_lags_deltas.txt.gz ~/buckets/b1/work/probs/lgbm/20201129/minmax_hist9_lags_deltas.csv T T > corrida_lgbm_hist9_lags_deltas.txt
