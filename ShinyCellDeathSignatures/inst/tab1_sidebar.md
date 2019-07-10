#### Measured cell viability

Here you can explore the matched instances between [CTRP](https://www.ncbi.nlm.nih.gov/pubmed/26482930) (drug perturbations) or [Achilles](https://www.ncbi.nlm.nih.gov/pubmed/28753430) (shRNA treatment) and [LINCS-L1000](https://www.ncbi.nlm.nih.gov/pubmed/29195078).

For CTRP cell viability is given in percent cell viaiblity (compared to non-treated control) so it is between 0 (all cells die) and 1 (similar to control). In some cases cell viaiblity is >1 (cell grows faster than in control conditions) but this is rare (see histogram, also CTRP screens anti-cancer drugs, so growth promoting effect is unlikely).

For Achilles cell viaiblity is given as normalized shRNA abundance. Negative values mean decreased cell viability, 0 neutral effect while positive values mean increased cell viaiblity (proliferation).

You can subset data based on:

* sig_id: unique ID from LINCS-L1000 for a gene expression signature
* pert_id: ID for a perturbation (compound, shRNA)
* pert_iname: name (compound of gene) for a perturbation
* cell_id: cell line
* pert_itime: duration of perturbation
* log10_conc_uM_LINCS / log10_conc_uM_CTRP: the log10 concentration values of the compound from LINCS / CTRP screen
* cell viaiblity / shRNA abundance: the matched cell viaiblity value for the signature
