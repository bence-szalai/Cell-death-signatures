library(viper)
set.seed(19890904)
load('../data/Functional/DoRothEA.rdata')
regulon=viper_regulon
correlations=read.csv('../results/functional/achilles_cors_lm.csv',sep=',',header=T,row.names = 1,check.names=FALSE)
gex=correlations$Pearson_r
names(gex)=correlations$pr_gene_symbol
activities = viper(eset = gex, regulon = regulon, nes = T, method = 'none' ,minsize = 4, eset.filter = F)
write.csv(activities,file ='../results/functional/enrichments/DoRothEA_achilles.csv')

correlations=read.csv('../results/functional/ctrp_cors_lm.csv',sep=',',header=T,row.names = 1,check.names=FALSE)
gex=correlations$Pearson_r
names(gex)=correlations$pr_gene_symbol
activities = viper(eset = gex, regulon = regulon, nes = T, method = 'none' ,minsize = 4, eset.filter = F)
write.csv(activities,file ='../results/functional/enrichments/DoRothEA_ctrp.csv')