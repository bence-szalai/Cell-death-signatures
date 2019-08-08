data=read.csv('../results/GDSC/auc.csv',sep=',',header = T,row.names = 1)
fil=(data$method=='same_target') & (data$features!='fingerprints')
model=lm('r ~ features', data=data[fil,])
