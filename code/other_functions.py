import pandas as pd
import numpy as np

from matplotlib import pyplot as plt
import seaborn as sns

from sklearn.mixture import GaussianMixture
from scipy.stats import spearmanr as scor

def make_dim_reduc_plot(sig_data,sig_info,color_by='viability',fname=None):
    """makes a plot of the 2 dimensional sig data, points are colored by
    {'viability','cell_id','pert_id','pert_itime','bin_viability'}
    if fname is given, saves the plot as a pdf to ../figures/"""
    plt.figure(dpi=600,figsize=(3.6,2.4))
    if color_by=='viability':
        cmap = sns.cubehelix_palette(8, start=.5, rot=-.75,as_cmap=True)
        points = plt.scatter(sig_data.iloc[:,0],sig_data.iloc[:,1], 
                            c=sig_info['cpd_avg_pv'], s=1, cmap=cmap,marker='.',
                            rasterized=True)
        plt.colorbar(points,label='Cell viability')
        r1=scor(sig_info['cpd_avg_pv'],sig_data.iloc[:,0])
        r2=scor(sig_info['cpd_avg_pv'],sig_data.iloc[:,1])
        print('Spearman Rho with X:',r1)
        print('Spearman Rho with Y:',r2)
    else:
        categories=sig_info[color_by].value_counts().index
        if len(categories)>5:
            categories=categories[:4]
            sns.set_palette('YlGnBu',len(categories)+1)
            plt.scatter(sig_data.iloc[:,0],sig_data.iloc[:,1],s=1,marker='.')
            leg=['other']+list(categories)
        else:
            sns.set_palette('YlGnBu',len(categories))
            leg=list(categories)
        if color_by=='bin_viability':
            #more informative this way
            categories=categories[::-1]
        for cat in categories:
            fil=sig_info[color_by]==cat
            plt.scatter(sig_data[fil].iloc[:,0],sig_data[fil].iloc[:,1],s=1,marker='.')
        plt.legend(leg,fontsize=7)
    plt.xlabel(sig_data.columns[0],size=10)
    plt.ylabel(sig_data.columns[1],size=10)
    plt.xticks(size=7)
    plt.yticks(size=7)
    plt.tight_layout()
    if fname:
        plt.savefig('../figures/raw/%s.pdf' % fname)