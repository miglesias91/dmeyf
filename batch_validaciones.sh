!#/bin/bash

Rscript --vanilla ~/repos/dmeyf/scripts/lgbm_vali.R 201801 202003 201805-201905-202003-201707-201911-201802 447 min_data_in_leaf=1000-feature_fraction=0.25-learning_rate=0.02 0.2_0.2_1 2 ~/repos/dmeyf/features-importantes-lgbm/minmax_hist12.txt 400 0.05 ~/buckets/b1/datasets/minmax_hist12.txt.gz ~/buckets/b1/work/validaciones/lgbm.txt &&

Rscript --vanilla ~/repos/dmeyf/scripts/lgbm_vali.R 201801 202003 201805-201905-202003-201707-201911-201802 447 min_data_in_leaf=1000-feature_fraction=0.25-learning_rate=0.02 0.2_0.2_1 2 ~/repos/dmeyf/features-importantes-lgbm/minmax_hist12_lags_deltas.txt 400 0.05 ~/buckets/b1/datasets/minmax_hist12_lags_deltas.txt.gz ~/buckets/b1/work/validaciones/lgbm.txt &&

Rscript --vanilla ~/repos/dmeyf/scripts/lgbm_vali.R 201710 202003 201805-201905-202003-201707-201911-201802 447 min_data_in_leaf=1000-feature_fraction=0.25-learning_rate=0.02 0.2_0.2_1 2 ~/repos/dmeyf/features-importantes-lgbm/minmax_hist9.txt 400 0.05 ~/buckets/b1/datasets/minmax_hist9.txt.gz ~/buckets/b1/work/validaciones/lgbm.txt &&

Rscript --vanilla ~/repos/dmeyf/scripts/lgbm_vali.R 201710 202003 201805-201905-202003-201707-201911-201802 447 min_data_in_leaf=1000-feature_fraction=0.25-learning_rate=0.02 0.2_0.2_1 2 ~/repos/dmeyf/features-importantes-lgbm/minmax_hist9_lags_deltas.txt 400 0.05 ~/buckets/b1/datasets/minmax_hist9_lags_deltas.txt.gz ~/buckets/b1/work/validaciones/lgbm.txt &&

Rscript --vanilla ~/repos/dmeyf/scripts/lgbm_vali.R 201704 202003 201805-201905-202003-201707-201911-201802 447 min_data_in_leaf=1000-feature_fraction=0.25-learning_rate=0.02 0.2_0.2_1 2 ~/repos/dmeyf/features-importantes-lgbm/minmax_hist3.txt 400 0.05 ~/buckets/b1/datasets/minmax_hist3.txt.gz ~/buckets/b1/work/validaciones/lgbm.txt &&

Rscript --vanilla ~/repos/dmeyf/scripts/lgbm_vali.R 201704 202003 201805-201905-202003-201707-201911-201802 447 min_data_in_leaf=1000-feature_fraction=0.25-learning_rate=0.02 0.2_0.2_1 2 ~/repos/dmeyf/features-importantes-lgbm/minmax_hist3_lags_deltas.txt 400 0.05 ~/buckets/b1/datasets/minmax_hist3_lags_deltas.txt.gz ~/buckets/b1/work/validaciones/lgbm.txt
