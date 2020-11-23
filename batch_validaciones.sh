!#/bin/bash

Rscript --vanilla ~/repos/dmeyf/scripts/lgbm_vali.R 201707 202003 201805-201905-202003-201707-201911-201802 1500 min_data_in_leaf=6840-num_leaves=500-feature_fraction=0.25-learning_rate=0.02 0.01_0.2_10 2 ~/repos/dmeyf/features-importantes-lgbm/features_minmax_historicos6meses_paquete_final.txt 200 1.0 ~/buckets/b1/datasets/MinMaxTarjetas_Historico6MesesDesde202005_paquete_final.txt.gz ~/buckets/b1/work/validaciones/lgbm.txt &&

Rscript --vanilla ~/repos/dmeyf/scripts/lgbm_vali.R 201707 202003 201805-201905-202003-201707-201911-201802 1500 min_data_in_leaf=6840-num_leaves=500-feature_fraction=0.25-learning_rate=0.02 0.01_0.2_10 2 ~/repos/dmeyf/features-importantes-lgbm/features_minmax_historicos6meses_paquete_final.txt 200 0.75 ~/buckets/b1/datasets/MinMaxTarjetas_Historico6MesesDesde202005_paquete_final.txt.gz ~/buckets/b1/work/validaciones/lgbm.txt &&

Rscript --vanilla ~/repos/dmeyf/scripts/lgbm_vali.R 201707 202003 201805-201905-202003-201707-201911-201802 1500 min_data_in_leaf=6840-num_leaves=500-feature_fraction=0.25-learning_rate=0.02 0.01_0.2_10 2 ~/repos/dmeyf/features-importantes-lgbm/features_minmax_historicos6meses_paquete_final.txt 200 0.5 ~/buckets/b1/datasets/MinMaxTarjetas_Historico6MesesDesde202005_paquete_final.txt.gz ~/buckets/b1/work/validaciones/lgbm.txt &&

Rscript --vanilla ~/repos/dmeyf/scripts/lgbm_vali.R 201707 202003 201805-201905-202003-201707-201911-201802 1500 min_data_in_leaf=6840-num_leaves=500-feature_fraction=0.25-learning_rate=0.02 0.01_0.2_10 2 ~/repos/dmeyf/features-importantes-lgbm/features_minmax_historicos6meses_paquete_final.txt 200 0.25 ~/buckets/b1/datasets/MinMaxTarjetas_Historico6MesesDesde202005_paquete_final.txt.gz ~/buckets/b1/work/validaciones/lgbm.txt &&

Rscript --vanilla ~/repos/dmeyf/scripts/lgbm_vali.R 201707 202003 201805-201905-202003-201707-201911-201802 1500 min_data_in_leaf=6840-num_leaves=500-feature_fraction=0.25-learning_rate=0.02 0.01_0.2_10 2 ~/repos/dmeyf/features-importantes-lgbm/features_minmax_historicos6meses_paquete_final.txt 200 0.05 ~/buckets/b1/datasets/MinMaxTarjetas_Historico6MesesDesde202005_paquete_final.txt.gz ~/buckets/b1/work/validaciones/lgbm.txt
