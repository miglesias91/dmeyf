!#/bin/bash

Rscript --vanilla ~/repos/dmeyf/scripts/lgbm_vali.R 201707 202003 201805-201905-202003-201707-201911-201802 2701 min_data_in_leaf=17197-max_bin=255-feature_fraction=0.147623-learning_rate=0.00797723697 0.05_0.05_1 2 ~/repos/dmeyf/features-importantes-lgbm/features_minmax_historicos6meses_paquete_final.txt 200 0.5 ~/buckets/b1/datasets/MinMaxTarjetas_Historico6MesesDesde202005_paquete_final.txt.gz ~/buckets/b1/work/validaciones/lgbm.txt &&

Rscript --vanilla ~/repos/dmeyf/scripts/lgbm_vali.R 201707 202003 201805-201905-202003-201707-201911-201802 2701 min_data_in_leaf=17197-max_bin=255-feature_fraction=0.147623-learning_rate=0.00797723697 0.05_0.05_1 2 ~/repos/dmeyf/features-importantes-lgbm/minmax_lagdeltas_hist6meses.txt 200 0.5 ~/buckets/b1/datasets/minmax_lags_deltas_hist6meses_final.txt.gz ~/buckets/b1/work/validaciones/lgbm.txt &&

Rscript --vanilla ~/repos/dmeyf/scripts/lgbm_vali.R 201707 202003 201805-201905-202003-201707-201911-201802 2701 min_data_in_leaf=17197-max_bin=63-feature_fraction=0.147623-learning_rate=0.00797723697 0.05_0.05_1 2 ~/repos/dmeyf/features-importantes-lgbm/features_minmax_historicos6meses_paquete_final.txt 200 0.5 ~/buckets/b1/datasets/MinMaxTarjetas_Historico6MesesDesde202005_paquete_final.txt.gz ~/buckets/b1/work/validaciones/lgbm.txt &&

Rscript --vanilla ~/repos/dmeyf/scripts/lgbm_vali.R 201707 202003 201805-201905-202003-201707-201911-201802 2701 min_data_in_leaf=17197-max_bin=63-feature_fraction=0.147623-learning_rate=0.00797723697 0.05_0.05_1 2 ~/repos/dmeyf/features-importantes-lgbm/minmax_lagdeltas_hist6meses.txt 200 0.5 ~/buckets/b1/datasets/minmax_lags_deltas_hist6meses_final.txt.gz ~/buckets/b1/work/validaciones/lgbm.txt &&

Rscript --vanilla ~/repos/dmeyf/scripts/lgbm_vali.R 201707 202003 201805-201905-202003-201707-201911-201802 2701 min_data_in_leaf=17197-max_bin=31-feature_fraction=0.147623-learning_rate=0.00797723697 0.05_0.05_1 2 ~/repos/dmeyf/features-importantes-lgbm/features_minmax_historicos6meses_paquete_final.txt 200 0.5 ~/buckets/b1/datasets/MinMaxTarjetas_Historico6MesesDesde202005_paquete_final.txt.gz ~/buckets/b1/work/validaciones/lgbm.txt &&

Rscript --vanilla ~/repos/dmeyf/scripts/lgbm_vali.R 201707 202003 201805-201905-202003-201707-201911-201802 2701 min_data_in_leaf=17197-max_bin=31-feature_fraction=0.147623-learning_rate=0.00797723697 0.05_0.05_1 2 ~/repos/dmeyf/features-importantes-lgbm/minmax_lagdeltas_hist6meses.txt 200 0.5 ~/buckets/b1/datasets/minmax_lags_deltas_hist6meses_final.txt.gz ~/buckets/b1/work/validaciones/lgbm.txt
