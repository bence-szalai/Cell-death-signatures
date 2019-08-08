import numpy as np
import pandas as pd
import os

def count_different_datasets():
    datasets=['LINCS-L1000','CTRP','Achilles','CTRP-L1000','Achilles-L1000','CTRP-L1000 3h','CTRP-L1000 6h',
        'CTRP-L1000 24h','Achilles-L1000 96h','Achilles-L1000 120h','Achilles-L1000 144h','NCI60','NCI60-L1000',
        'NCI60-CTRP-L1000','GDSC-L1000']
    params=['Data points','Cell lines','Compounds','shRNAs','Time points']
    results=pd.DataFrame(0,index=datasets,columns=params)
    #LINCS-L1000
    data=pd.read_csv('../results/predictions/merged_pred.csv',sep=',',header=0,index_col=0)
    n=len(data)
    cell=len(set(data['cell_id']))
    fil=data['pert_type']=='trt_cp'
    comp=len(set(data[fil]['pert_id']))
    fil=data['pert_type']=='trt_sh'
    sh=len(set(data[fil]['pert_id']))
    t=len(set(data['pert_itime']))
    results.loc['LINCS-L1000']=[n,cell,comp,sh,t]
    #CTRP
    ctrp=pd.read_table('../data/CTRP/v20.data.per_cpd_post_qc.txt',sep='\t',header=0,index_col=None)
    experiment_info=pd.read_table('../data/CTRP/v20.meta.per_experiment.txt',sep='\t',header=0,index_col=None)
    n=len(ctrp)
    cell=len(set(experiment_info['master_ccl_id']))
    cp=len(set(ctrp['master_cpd_id']))
    results.loc['CTRP',:]=[n,cell,cp,0,1]
    #Achilles
    achilles=pd.read_table('../results/Achilles/achilles_merged.csv',sep=',',header=0,index_col=[0])
    cell=len(set(achilles.columns))
    sh=len(set(achilles.index))
    dp=np.sum(~pd.isnull(achilles.values.reshape((1,-1))[0]))
    results.loc['Achilles',:]=[dp,cell,0,sh,1]
    #CTRP-L1000
    l1000=pd.read_table('../results/CTRP/sig_info_merged_lm.csv',sep=',',header=0,index_col=[0])
    dp=len(l1000)
    cl=len(set(l1000['cell_id']))
    cp=len(set(l1000['pert_id']))
    t=len(set(l1000['pert_itime']))
    results.loc['CTRP-L1000',:]=[dp,cl,cp,0,t]
    names=['CTRP-L1000 3h','CTRP-L1000 6h','CTRP-L1000 24h']
    times=['3 h','6 h','24 h']
    for i in range(3):
        fil=l1000['pert_itime']==times[i]
        dp=len(l1000[fil])
        cl=len(set(l1000[fil]['cell_id']))
        cp=len(set(l1000[fil]['pert_id']))
        t=len(set(l1000[fil]['pert_itime']))
        results.loc[names[i],:]=[dp,cl,cp,0,t]
    #Achilles-L1000
    l1000=pd.read_table('../results/Achilles/sig_info_merged_lm.csv',sep=',',header=0,index_col=[0])
    dp=len(l1000)
    cl=len(set(l1000['cell_id']))
    sh=len(set(l1000['pert_id']))
    t=len(set(l1000['pert_itime']))
    results.loc['Achilles-L1000',:]=[dp,cl,0,sh,t]
    names=['Achilles-L1000 96h','Achilles-L1000 120h','Achilles-L1000 144h']
    times=['96 h','120 h','144 h']
    for i in range(3):
        fil=l1000['pert_itime']==times[i]
        dp=len(l1000[fil])
        cl=len(set(l1000[fil]['cell_id']))
        sh=len(set(l1000[fil]['pert_id']))
        t=len(set(l1000[fil]['pert_itime']))
        results.loc[names[i],:]=[dp,cl,0,sh,t]
    #NCI60
    nci60=pd.read_table('../data/NCI60/'+'CANCER60GI50.LST', sep=',',header=0,index_col=None)
    dp=len(nci60)
    cl=len(set(nci60['CELL']))
    cp=len(set(nci60['NSC']))
    results.loc['NCI60',:]=[dp,cl,cp,0,1]
    nci60=pd.read_table('../results/NCI60/'+'CANCER60GI50_validation.csv', sep=',',header=0,index_col=0)
    dp=len(nci60)
    cl=len(set(nci60['CELL']))
    cp=len(set(nci60['NSC']))
    results.loc['NCI60-L1000',:]=[dp,cl,cp,0,1]
    fil=~pd.isnull(nci60['area_under_curve'])
    nci60=nci60[fil]
    dp=len(nci60)
    cl=len(set(nci60['CELL']))
    cp=len(set(nci60['NSC']))
    results.loc['NCI60-CTRP-L1000',:]=[dp,cl,cp,0,1]
    gdsc=pd.read_csv('../data/GDSC/ML/sig_info.csv',sep=',',header=0,index_col=0)
    n=len(gdsc)
    cell=len(set(gdsc['cell_id']))
    cp=len(set(gdsc['pert_id']))
    results.loc['GDSC-L1000']=[n,cell,cp,0,1]
    #chem
    data=pd.read_csv('../results/predictions/merged_pred.csv',sep=',',header=0,index_col=0)
    fil=np.in1d(data['pert_type'],['trt_cp','trt_lig'])
    data=data[fil]
    n=len(data)
    cell=len(set(data['cell_id']))
    comp=len(set(data['pert_id']))
    t=len(set(data['pert_itime']))
    results.loc['LINCS-Chem']=[n,cell,comp,0,t]
    #moa
    fnames=pd.Series(os.listdir('../results/moa/signatures/')).apply(lambda x:x.split('.')[0])
    data=pd.read_csv('../results/predictions/merged_pred.csv',sep=',',header=0,index_col=0)
    fil=np.in1d(data['pert_id'],fnames)
    data=data[fil]
    n=len(data)
    cell=len(set(data['cell_id']))
    fil=data['pert_type']=='trt_cp'
    comp=len(set(data[fil]['pert_id']))
    fil=data['pert_type']=='trt_sh'
    sh=len(set(data[fil]['pert_id']))
    t=len(set(data['pert_itime']))
    results.loc['Moa']=[n,cell,comp,sh,t]
    #fil=np.in1d(data['pert_id'],fnames)&data['
    results.to_csv('../results/summary_statistic.csv',sep=',')
    
