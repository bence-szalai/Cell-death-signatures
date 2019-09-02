import pandas as pd
import numpy as np
import seaborn as sns
from matplotlib import pyplot as plt
sns.set_style('whitegrid')
data=pd.read_csv('../results/predictions/merged_pred.csv',sep=',',
                    header=0,index_col=0,low_memory=False)
                    
fil=data['pert_type']=='trt_cp'
data=data[fil]
fil=data['pert_idose']!='-666'
data=data[fil]

data['Dose']=data['pert_idose'].apply(lambda x:x.split(' ')[0]).astype(float)

fil=data['pert_idose'].apply(lambda x:x.split(' ')[1])=='nM'
data.loc[data.index[fil],'Dose']/=1000

data=data.sort_values('Dose')
fil=data['Dose']>0
data=data[fil]
data=data.drop_duplicates('pert_iname',keep='last')
data=data[['pert_iname','Dose']]
data.index=data['pert_iname']
data['Dose']=np.log10(data['Dose'])

groups=pd.read_csv('../results/predictions/predicted_min_max.csv',
                    sep=',',header=0,index_col=0)
groups.index=groups['pert_iname']

ids=list(set(groups.index) & set(data.index))

data=data.loc[ids]
groups=groups.loc[ids]

data['pred_max']=groups['pred_max']
data['pred_min']=groups['pred_min']

fil=data['pred_max']!=data['pred_min']
data=data[fil]

ctrp=pd.read_csv('../results/CTRP/sig_info_merged_lm.csv',
            sep=',',header=0,index_col=[0])
ctrp=list(set(ctrp['pert_iname']) & set(data.index))

tox=data.index[data['pred_min']<-3]
nontox=data.index[data['pred_min']>-3]
data['Group']=''
data.loc[tox,'Group']='Toxic'
data.loc[nontox,'Group']='Non-toxic'

ctrp_data=pd.read_csv('../data/CTRP/v20.meta.per_compound.txt',
                sep='\t',header=0)
ctrp_data=ctrp_data[['cpd_name','top_test_conc_umol']]
ctrp_data.columns=['pert_iname','Dose']
ctrp_data['Dose']=np.log10(ctrp_data['Dose'])
ctrp_data['pred_max']=0
ctrp_data['pred_min']=1
ctrp_data['Group']='CTRP'

data=pd.concat([data,ctrp_data])
plt.figure(dpi=600,figsize=(4,3))
sns.set_palette('YlGnBu',3)
sns.violinplot(x='Group',y='Dose',data=data)
plt.xticks(size=7)
plt.yticks(size=7)
plt.xlabel('Toxicity group',size=10)
plt.ylabel('log10(maximal tested concentration, uM)',size=10)
plt.tight_layout()
plt.show()
plt.savefig('../figures/raw/Sfig7new.pdf')    

   