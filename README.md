## Analysis code for: Signatures of cell death and proliferation in perturbation transcriptomics data - from confounding factor to effective prediction
**Abstract**

Transcriptomics perturbation signatures are valuable data sources for functional genomic studies. They can be used to identify mechanism of action for compounds and to infer functional activity of cellular processes. Linking perturbation signatures to phenotypic studies opens up the possibility to model cellular phenotypes from gene expression data and to predict drugs interfering with the phenotype. By linking perturbation transcriptomics data from the LINCS-L1000 project with cell viability phenotypic information upon genetic (Achilles project) and chemical (CTRP screen) perturbations for more than 90,000 signature - cell viability pairs, we show that cell death signature is a major factor behind perturbation signatures. Analysing this signature revealed transcription factors regulating cell death and proliferation. We use the cell death - signature relationship to predict cell viability from transcriptomics signatures, and identify and validate compounds that induce cell death. We show that cellular toxicity can lead to unexpected similarity of signatures, confounding mechanism of action discovery. Consensus compound signatures predict cell-specific drug sensitivity, even if the signature is not measured in the same cell line and outperform conventional drug-specific features. Our results can help understanding mechanisms behind cell death,  removing confounding factors of transcriptomics perturbation screens and show that expression signatures boost prediction of drug sensitivity.

<p style="text-align:justify">The corresponding article for this project is available at [Nucleic Acids Research](https://academic.oup.com/nar/advance-article/doi/10.1093/nar/gkz805/5573547?guestAccessKey=151831e1-0f78-4c70-854c-a471a28a5eac). We also proveide an R Shiny application, [CEVIChE](https://saezlab.shinyapps.io/ceviche/) (CEll VIability Calculator from gene Expression) to browse predicted cell viability values, and to perform predictions on any gene expression data online.

You have to clone / dowload the project, and run the different Jupyter Notebooks to reproduce our analysis

**Libraries used**

Beside basic scientific computing (NumPy, pandas, SciPy, scikit-learn) and plotting (Matplotlib, seaborn) we used the following libraries:

1. [cmapPy](https://clue.io/cmapPy/index.html) to access Connectivity Map Resources
2. [colormap](https://pypi.org/project/colormap/) for some coloring applications
3. [adjustText](https://github.com/Phlya/adjustText) for text adjustment in plots

We also use some R packages:

1. [viper](https://www.bioconductor.org/packages/release/bioc/html/viper.html) for regulon enrichment
2. [biomaRt](https://bioconductor.org/packages/release/bioc/html/biomaRt.html) for translating between gene IDs
3. [msigdbr](https://cran.r-project.org/web/packages/msigdbr/) for GO and KEGG
4. [piano](https://bioconductor.org/packages/release/bioc/html/piano.html) for enrichment analysis
5. [pROC](https://cran.r-project.org/web/packages/pROC/index.html) statistical analysis of ROC curves

**Data download**

We used the data from LINCS, CTRP and Achilles for this project.

**cell\_death\_0\_download.ipynb**: downloads / helps to download all the necessary files.

**cell\_death\_1\_preprocess.ipynb**: performs data preprocess / matching between the different datasets

**cell\_death\_2\_model\_analysis.ipynb**: performs model building (related to Fig.1 of manuscript)

**cell\_death\_3\_functional\_analysis.ipynb**: pathway enrichmnets and associations with drug response (related to Fig.2 of manuscript)

**cell\_death\_4\_moa.ipynb**: mechanism of action inference

**cell\_death\_5\_prediction.ipynb**: predicting cell viability for the whole LINCS-L1000 dataset

**cell\_death\_6\_ML.ipynb**: Machine Learning prediction of drug sensitivity

**cell\_death\_7\_additional.ipynb**: additional analysis (not in manuscript)

**cell\_death\_8\_figures.ipynb**: recreating figures