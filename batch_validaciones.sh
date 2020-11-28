!#/bin/bash

Rscript --vanilla ~/repos/dmeyf/scripts/lgbm_vali.R 201707 202003 201805-201905-202003-201707-201911-201802 447 min_data_in_leaf=1000-feature_fraction=0.25-learning_rate=0.02 0.2_0.2_1 2 ~/repos/dmeyf/features-importantes-lgbm/features_standars.txt 140 0.05 ~/buckets/b1/datasetsOri/paquete_premium_final.txt.gz ~/buckets/b1/work/validaciones/lgbm.txt &&

Rscript --vanilla ~/repos/dmeyf/scripts/lgbm_vali.R 201707 202003 201805-201905-202003-201707-201911-201802 447 min_data_in_leaf=1000-feature_fraction=0.25-learning_rate=0.02 0.2_0.2_1 2 ~/repos/dmeyf/features-importantes-lgbm/features_minmax_historicos6meses_paquete_final.txt 400 0.05 ~/buckets/b1/datasets/MinMaxTarjetas_Historico6MesesDesde202005_paquete_final.txt.gz ~/buckets/b1/work/validaciones/lgbm.txt &&

Rscript --vanilla ~/repos/dmeyf/scripts/lgbm_vali.R 201707 202003 201805-201905-202003-201707-201911-201802 447 min_data_in_leaf=1000-feature_fraction=0.25-learning_rate=0.02 0.2_0.2_1 2 ~/repos/dmeyf/features-importantes-lgbm/minmax_lagdeltas_hist6meses.txt 400 0.05 ~/buckets/b1/datasets/minmax_lags_deltas_hist6meses_final.txt.gz ~/buckets/b1/work/validaciones/lgbm.txt
