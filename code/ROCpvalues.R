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

data=read.csv('../results/NCI60/CANCER60GI50_validation.csv',sep=',',header = T,row.names = 1)
data$DELTA=(data$DELTA<(-0.1))*1
p_ctrp_achilles=roc.test(response=data$DELTA,predictor1 = data$Achilles_prediction,
                         predictor2 = data$CTRP_prediction)
p_gt_achilles=roc.test(response=data$DELTA,predictor1 = data$Achilles_prediction,
                         predictor2 = data$area_under_curve)
p_gt_ctrp=roc.test(response=data$DELTA,predictor1 = data$CTRP_prediction,
                         predictor2 = data$area_under_curve)


