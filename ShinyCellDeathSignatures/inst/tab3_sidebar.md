#### Predicting cell viaiblity from gene expression

Using a gene expression matrix (rows: gene symbols, columns: samples) cell viaiblity can be predicted with CTRP and Achilles models. ased on our cross-validations the performance of Achilles model is better.

Models are originally trained on normalised gene expression contrast (perturbed - control), however based on our results they can be also used with raw expression values. However we suggest to perform a gene wise normalisation on the data, otherwise the predicted cell viability values are hard to interpret. 

The functionality of this app can be explored by using the example [data set](). Please note that the upload button will remain disabled as long as the user explores the example data set.
