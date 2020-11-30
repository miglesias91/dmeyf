!#/bin/bash

Rscript --vanilla ~/repos/dmeyf/scripts/lgbm.R 201701 202003 202005 9999 min_data_in_leaf=15000-feature_fraction=0.25-learning_rate=0.002 0.5 0.05 2 ~/repos/dmeyf/features-importantes-lgbm/minmax_hist12.txt 400 ~/buckets/b1/datasets/minmax_hist12.txt.gz ~/buckets/b1/work/probs/lgbm/20201130/minmax_hist12.csv F T > corrida_lgbm_hist12.txt &&

Rscript --vanilla ~/repos/dmeyf/scripts/lgbm.R 201701 202003 202005 9999 min_data_in_leaf=15000-feature_fraction=0.25-learning_rate=0.002 0.5 0.05 2 ~/repos/dmeyf/features-importantes-lgbm/minmax_hist12_lags_deltas.txt 400 ~/buckets/b1/datasets/minmax_hist12_lags_deltas.txt.gz ~/buckets/b1/work/probs/lgbm/20201130/minmax_hist12_lags_deltas.csv F T > corrida_lgbm_hist12_lags_deltas.txt &&

Rscript --vanilla ~/repos/dmeyf/scripts/lgbm.R 201701 202003 202005 9999 min_data_in_leaf=15000-feature_fraction=0.25-learning_rate=0.002 0.5 0.05 2 ~/repos/dmeyf/features-importantes-lgbm/minmax_hist3.txt 400 ~/buckets/b1/datasets/minmax_hist3.txt.gz ~/buckets/b1/work/probs/lgbm/20201130/minmax_hist3.csv F T > corrida_lgbm_hist3.txt &&

Rscript --vanilla ~/repos/dmeyf/scripts/lgbm.R 201701 202003 202005 9999 min_data_in_leaf=15000-feature_fraction=0.25-learning_rate=0.002 0.5 0.05 2 ~/repos/dmeyf/features-importantes-lgbm/minmax_hist3_lags_deltas.txt 400 ~/buckets/b1/datasets/minmax_hist3_lags_deltas.txt.gz ~/buckets/b1/work/probs/lgbm/20201130/minmax_hist3_lags_deltas.csv F T > corrida_lgbm_hist3_lags_deltas.txt &&

Rscript --vanilla ~/repos/dmeyf/scripts/lgbm.R 201701 202003 202005 9999 min_data_in_leaf=15000-feature_fraction=0.25-learning_rate=0.002 0.5 0.05 2 ~/repos/dmeyf/features-importantes-lgbm/minmax_hist9.txt 400 ~/buckets/b1/datasets/minmax_hist9.txt.gz ~/buckets/b1/work/probs/lgbm/20201130/minmax_hist9.csv F T > corrida_lgbm_hist9.txt &&

Rscript --vanilla ~/repos/dmeyf/scripts/lgbm.R 201701 202003 202005 9999 min_data_in_leaf=15000-feature_fraction=0.25-learning_rate=0.002 0.5 0.05 2 ~/repos/dmeyf/features-importantes-lgbm/minmax_hist9_lags_deltas.txt 400 ~/buckets/b1/datasets/minmax_hist9_lags_deltas.txt.gz ~/buckets/b1/work/probs/lgbm/20201130/minmax_hist9_lags_deltas.csv F T > corrida_lgbm_hist9_lags_deltas.txt
