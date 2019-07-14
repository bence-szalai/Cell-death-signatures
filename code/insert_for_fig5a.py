import pandas as pd
import numpy as np

from matplotlib import pyplot as plt
import seaborn as sns

sns.set_style('whitegrid')

from sklearn.manifold.t_sne import TSNE
from sklearn.metrics import silhouette_samples

data=pd.read_csv('../data/GDSC/ML/drug_features/signatures.csv',sep=',',header=0,index_col=0)
anno=pd.read_excel('../data/GDSC/Screened_Compounds.xlsx')
anno.index=anno['DRUG_ID']
drug_ids=list(set(data.index)&set(anno.index))
data=data.loc[drug_ids,:]
anno=anno.loc[drug_ids,:]
pathways=list(set(anno['TARGET_PATHWAY']))
model=TSNE(n_components=2,random_state=19890904,method='exact',learning_rate=80,perplexity=20)
data_tsne=model.fit_transform(data)
data_tsne=pd.DataFrame(data_tsne,index=data.index,columns=range(2))
clustering=pd.DataFrame(index=data.index)
clustering['Silhouette score']=silhouette_samples(data_tsne,anno.loc[data.index,'TARGET_PATHWAY'])
clustering['TARGET_PATHWAY']=anno.loc[data.index,'TARGET_PATHWAY']
clustering=clustering.sort_values('Silhouette score',ascending=False)
clustering=clustering.drop_duplicates('TARGET_PATHWAY')
f,ax=plt.subplots(1,1)
sns.set_palette('GnBu',21)
for j in range(len(pathways)):
        pw=pathways[j]
        fil=anno.loc[:,'TARGET_PATHWAY']==pw
        indexes=anno.index[fil]
        plt.plot(data_tsne.loc[indexes,0],data_tsne.loc[indexes,1],'o')
        fil=np.in1d(clustering.index,indexes)
        for i in indexes:
            plt.text(data_tsne.loc[i,0],data_tsne.loc[i,1],anno.loc[i,'DRUG_NAME'],color= 'k',ha=np.random.choice(['center','left','right']),size=20)

box = ax.get_position()
ax.set_position([box.x0, box.y0, box.width * 0.75, box.height])
ax.legend(pathways,loc='center left', bbox_to_anchor=(1, 0.5),prop={'size': 5})    
plt.xticks(size=7)
plt.yticks(size=7)
plt.xlabel('TSNE1',size=10)
plt.ylabel('TSNE2',size=10)
plt.tight_layout()
plt.show()