import numpy as np
import pandas as pd

data=pd.read_csv('../results/to_application/predictions/merged_pred.csv',
                sep=',',header=0,index_col=0)
                
data['CTRP_prediction']=data['CTRP_prediction'].round(3)
data['Achilles_prediction']=data['Achilles_prediction'].round(3)
                
                                                
fil_ctl=np.in1d(data['pert_type'],['ctl_untrt','ctl_untrt.cns','ctl_vector',
                               'ctl_vector.cns','ctl_vehicle',
                               'ctl_vehicle.cns'])
fil_cp=np.in1d(data['pert_type'],['trt_cp','trt_lig'])
fil_oe=np.in1d(data['pert_type'],['trt_oe','trt_oe.mut'])
fil_sh=np.in1d(data['pert_type'],['trt_sh','trt_sh.cgs','trt_sh.css'])
fil_xpr=np.in1d(data['pert_type'],['trt_xpr'])

data[fil_ctl].to_csv('../results/to_application/predictions/control_pred.csv',
                    sep=',')
data[fil_cp].to_csv('../results/to_application/predictions/compound_ligand_pred.csv',
                    sep=',')
data[fil_oe].to_csv('../results/to_application/predictions/over_expression_pred.csv',
                    sep=',')
data[fil_sh].to_csv('../results/to_application/predictions/shRNA_pred.csv',
                    sep=',')
data[fil_xpr].to_csv('../results/to_application/predictions/crispr_pred.csv',
                    sep=',')
              
