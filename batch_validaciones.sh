!#/bin/bash

Rscript --vanilla ~/repos/dmeyf/scripts/lgbm_vali.R 201701 202003 201805-201905-202002-201707-201911-201802 2701 min_data_in_leaf=17197-feature_fraction=0.5-learning_rate=0.0079772 0.2_0.2_1 2 ~/repos/dmeyf/features-importantes-lgbm/minmax_hist12.txt 400 0.05 ~/buckets/b1/datasets/minmax_hist12.txt.gz ~/buckets/b1/work/validaciones/lgbm.txt &&

Rscript --vanilla ~/repos/dmeyf/scripts/lgbm_vali.R 201701 202003 201805-201905-202002-201707-201911-201802 2701 min_data_in_leaf=17197-feature_fraction=0.5-learning_rate=0.0079772 0.2_0.2_1 2 ~/repos/dmeyf/features-importantes-lgbm/minmax_hist12_lags_deltas.txt 400 0.05 ~/buckets/b1/datasets/minmax_hist12_lags_deltas.txt.gz ~/buckets/b1/work/validaciones/lgbm.txt &&

Rscript --vanilla ~/repos/dmeyf/scripts/lgbm_vali.R 201701 202003 201805-201905-202002-201707-201911-201802 2701 min_data_in_leaf=17197-feature_fraction=0.5-learning_rate=0.0079772 0.2_0.2_1 2 ~/repos/dmeyf/features-importantes-lgbm/minmax_hist9.txt 400 0.05 ~/buckets/b1/datasets/minmax_hist9.txt.gz ~/buckets/b1/work/validaciones/lgbm.txt &&

Rscript --vanilla ~/repos/dmeyf/scripts/lgbm_vali.R 201701 202003 201805-201905-202002-201707-201911-201802 2701 min_data_in_leaf=17197-feature_fraction=0.5-learning_rate=0.0079772 0.2_0.2_1 2 ~/repos/dmeyf/features-importantes-lgbm/minmax_hist9_lags_deltas.txt 400 0.05 ~/buckets/b1/datasets/minmax_hist9_lags_deltas.txt.gz ~/buckets/b1/work/validaciones/lgbm.txt &&

Rscript --vanilla ~/repos/dmeyf/scripts/lgbm_vali.R 201701 202003 201805-201905-202002-201707-201911-201802 2701 min_data_in_leaf=17197-feature_fraction=0.5-learning_rate=0.0079772 0.2_0.2_1 2 ~/repos/dmeyf/features-importantes-lgbm/minmax_hist3.txt 400 0.05 ~/buckets/b1/datasets/minmax_hist3.txt.gz ~/buckets/b1/work/validaciones/lgbm.txt &&

Rscript --vanilla ~/repos/dmeyf/scripts/lgbm_vali.R 201701 202003 201805-201905-202002-201707-201911-201802 2701 min_data_in_leaf=17197-feature_fraction=0.5-learning_rate=0.0079772 0.2_0.2_1 2 ~/repos/dmeyf/features-importantes-lgbm/minmax_hist3_lags_deltas.txt 400 0.05 ~/buckets/b1/datasets/minmax_hist3_lags_deltas.txt.gz ~/buckets/b1/work/validaciones/lgbm.txt &&

Rscript --vanilla ~/repos/dmeyf/scripts/lgbm_vali.R 201701 202003 201805-201905-202002-201708-201911-201802 2701 min_data_in_leaf=17197-feature_fraction=0.5-learning_rate=0.0079772 0.2_0.2_1 2 ~/repos/dmeyf/features-importantes-lgbm/minmax_hist6.txt 400 0.05 ~/buckets/b1/datasets/minmax_hist6.txt.gz ~/buckets/b1/work/validaciones/lgbm.txt &&

Rscript --vanilla ~/repos/dmeyf/scripts/lgbm_vali.R 201701 202003 201805-201905-202002-201708-201911-201802 2701 min_data_in_leaf=17197-feature_fraction=0.5-learning_rate=0.0079772 0.2_0.2_1 2 ~/repos/dmeyf/features-importantes-lgbm/minmax_hist6_lags_deltas.txt 400 0.05 ~/buckets/b1/datasets/minmax_hist6_lags_deltas.txt.gz ~/buckets/b1/work/validaciones/lgbm.txt
