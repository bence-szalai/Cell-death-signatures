library(viper)
ncores=11
set.seed(19890904)
load('../data/Functional/DoRothEA.rdata')
regulon=viper_regulon
data=read.csv('../data/GDSC/norm_gex.csv',sep=',',header=T,row.names = 1,check.names=FALSE)
activities = viper(eset = data, regulon = regulon, nes = T, 
                   method = 'none' ,minsize = 4, eset.filter = F,cores = ncores)
write.csv(activities,file ='../data/GDSC/ML/cell_features/dorothea.csv')