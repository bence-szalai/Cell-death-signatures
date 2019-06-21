setwd("~/Documents/Projects/NAR2019_revision/code")

data=read.csv('../results/moa/moa_ctrp_predictions.csv',sep=',',header=T,row.names = 1)
library(pROC)

p_0_vs_chem=roc.test(response=data$moa,predictor1 = data$X0,
            predictor2 = data$chem_1024)

p_0_vs_sens=roc.test(response=data$moa,predictor1 = data$X0,
                     predictor2 = data$sens)

p_700_vs_chem=roc.test(response=data$moa,predictor1 = data$X700,
                     predictor2 = data$chem_1024)

p_700_vs_sens=roc.test(response=data$moa,predictor1 = data$X700,
                     predictor2 = data$sens)

p_700_vs_0=roc.test(response=data$moa,predictor1 = data$X0,
                       predictor2 = data$X700)
