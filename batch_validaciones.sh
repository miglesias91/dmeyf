!#/bin/bash

Rscript --vanilla ~/repos/dmeyf/scripts/lgbm_vali.R 201707 202003 201805-201905-202003-201707-201911-201802 1500 min_data_in_leaf=9822-num_leaves=500-feature_fraction=0.25-learning_rate=0.0124789989 0.05_0.5_10 2 ~/repos/dmeyf/features-importantes-lgbm/features_minmax_historicos6meses_paquete_final.txt 200 0.2 ~/buckets/b1/datasets/MinMaxTarjetas_Historico6MesesDesde202005_paquete_final.txt.gz ~/buckets/b1/work/validaciones/lgbm.txt &&

Rscript --vanilla ~/repos/dmeyf/scripts/lgbm_vali.R 201707 202003 201805-201905-202003-201707-201911-201802 2500 min_data_in_leaf=9822-num_leaves=500-feature_fraction=0.25-learning_rate=0.0124789989 0.05_0.5_10 2 ~/repos/dmeyf/features-importantes-lgbm/features_minmax_historicos6meses_paquete_final.txt 200 0.2 ~/buckets/b1/datasets/MinMaxTarjetas_Historico6MesesDesde202005_paquete_final.txt.gz ~/buckets/b1/work/validaciones/lgbm.txt &&

Rscript --vanilla ~/repos/dmeyf/scripts/lgbm_vali.R 201707 202003 201805-201905-202003-201707-201911-201802 3500 min_data_in_leaf=9822-num_leaves=500-feature_fraction=0.25-learning_rate=0.0124789989 0.05_0.5_10 2 ~/repos/dmeyf/features-importantes-lgbm/features_minmax_historicos6meses_paquete_final.txt 200 0.2 ~/buckets/b1/datasets/MinMaxTarjetas_Historico6MesesDesde202005_paquete_final.txt.gz ~/buckets/b1/work/validaciones/lgbm.txt
