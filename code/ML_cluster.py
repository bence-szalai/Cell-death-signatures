import pandas as pd
import numpy as np
from sklearn.ensemble import RandomForestRegressor as RFR

def read_data(drug_feature_type='target',response_type='auc'):
    response=pd.read_csv('../data/GDSC/ML/response/response_%s.csv' % response_type,sep=',',header=0,index_col=0)
    cell_feat=pd.read_csv('../data/GDSC/ML/cell_features/cell_features.csv',sep=',',header=0,index_col=0)
    drug_feat=pd.read_csv('../data/GDSC/ML/drug_features/%s.csv' % drug_feature_type,sep=',',header=0,index_col=0)
    cell_feat=cell_feat.loc[response['COSMIC_ID'].values]
    cell_feat.index=response.index
    drug_feat=drug_feat.loc[response['DRUG_ID'].values]
    drug_feat.index=response.index
    features=pd.concat([cell_feat,drug_feat],1)
    return response,features
    
TARGET_MATRIX=pd.read_csv('../data/GDSC/ML/drug_features/target.csv',sep=',',header=0,
                  index_col=0)
def make_split(data,s,split_type='random'):
    np.random.seed(s)
    drugs=list(set(data.loc[:,'DRUG_ID']))
    if split_type=='random':
        drugs_tr=np.random.choice(drugs,int(len(drugs)/2),False)
        fil=np.in1d(data.loc[:,'DRUG_ID'],drugs_tr)
        tr=data.index[fil]
        ts=data.index[~fil]
    elif split_type=='same_target':
        tr_drugs=[]
        ts_drugs=[]
        while len(drugs)>0:
            drug=np.random.choice(drugs,1)[0]
            fil=TARGET_MATRIX.loc[drug,:]==1
            targets_round=list(TARGET_MATRIX.columns[fil])
            fil=np.sum(TARGET_MATRIX.loc[:,targets_round],1)>0
            drugs_round=list(set(TARGET_MATRIX.index[fil])&set(drugs))
            if len(drugs_round)>1:
                drugs_round_tr=list(np.random.choice(drugs_round,int(len(drugs_round)/2),False))
                drugs_round_ts=list(set(drugs_round)-set(drugs_round_tr))
                tr_drugs+=drugs_round_tr
                ts_drugs+=drugs_round_ts
            else:
                tr_drugs+=drugs_round
            drugs=list(set(drugs)-set(drugs_round))
        fil=np.in1d(data.loc[:,'DRUG_ID'],tr_drugs)
        tr=data.index[fil]
        ts=data.index[~fil]
    elif split_type=='diff_target':
        tr_drugs=[]
        l=len(drugs)
        while len(drugs)>l/2:
            drug=np.random.choice(drugs,1)[0]
            fil=TARGET_MATRIX.loc[drug,:]==1
            targets_round=list(TARGET_MATRIX.columns[fil])
            targets_round_prev=[]
            while set(targets_round)!=set(targets_round_prev):
                targets_round_prev=targets_round[::]
                fil=np.sum(TARGET_MATRIX.loc[:,targets_round],1)>0
                drugs_round=list(set(TARGET_MATRIX.index[fil])&set(drugs))
                fil=np.sum(TARGET_MATRIX.loc[drugs_round,:],0)>0
                targets_round=TARGET_MATRIX.columns[fil]
            tr_drugs+=drugs_round
            drugs=list(set(drugs)-set(drugs_round))
        fil=np.in1d(data.loc[:,'DRUG_ID'],tr_drugs)
        tr=data.index[fil]
        ts=data.index[~fil]
    return tr,ts
    
def make_prediction(response,features,tr,ts):
    model=RFR(n_estimators=50,n_jobs=11)
    model.fit(features.loc[tr,:],response.loc[tr,'RESPONSE'])
    results=response.loc[ts,:].copy()
    y_pr=model.predict(features.loc[ts,:])
    results['Predicted']=y_pr
    return results
for resp in ['auc','ic50']:    
    for split in ['random','same_target','diff_target']:
        for df in ['target','pathway','fingerprints','signatures_pca']:
            data,features=read_data(df,response_type=resp)
            for s in range(20):
                tr,ts=make_split(data,s,split)
                results=make_prediction(data,features,tr,ts)
                rname='_'.join([resp,split,df,str(s)])
                results.to_csv('../results/GDSC/%s.csv' % rname,sep=',')