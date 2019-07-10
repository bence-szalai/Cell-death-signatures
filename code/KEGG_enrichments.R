library(msigdbr)
library(piano)

set.seed(19890904)

data=read.csv('../results/functional/achilles_cors_lm.csv',header = T,row.names = 1,stringsAsFactors = F)

# read 
m_df = msigdbr(species = "Homo sapiens", category = 'C2', subcategory = 'CP:KEGG')
m_df=as.data.frame(m_df[,c('gene_symbol','gs_name')])

#fil for genes present in data
fil=m_df$gene_symbol %in% data$pr_gene_symbol
m_df=m_df[fil,]

# prepare GSE
myGSC = loadGSC(m_df)
geneStat=data$p_val
geneDir=data$Pearson_r
names(geneStat)=data$pr_gene_symbol
names(geneDir)=data$pr_gene_symbol

# run GSE
gsaRes <- runGSA(geneLevelStats = geneDir,gsc=myGSC,gsSizeLim=c(5,300),geneSetStat = 'fgsea')
gsea_table=GSAsummaryTable(gsaRes)
write.table(gsea_table,'../results/functional/enrichments/KEGG_achilles.tsv',sep='\t')

### the same for ctrp

data=read.csv('../results/functional/ctrp_cors_lm.csv',header = T,row.names = 1,stringsAsFactors = F)

# read 
m_df = msigdbr(species = "Homo sapiens", category = 'C2', subcategory = 'CP:KEGG')
m_df=as.data.frame(m_df[,c('gene_symbol','gs_name')])

#fil for genes present in data
fil=m_df$gene_symbol %in% data$pr_gene_symbol
m_df=m_df[fil,]

# prepare GSE
myGSC = loadGSC(m_df)
geneStat=data$p_val
geneDir=data$Pearson_r
names(geneStat)=data$pr_gene_symbol
names(geneDir)=data$pr_gene_symbol

# run GSE
gsaRes <- runGSA(geneLevelStats = geneDir,gsc=myGSC,gsSizeLim=c(5,300),geneSetStat = 'fgsea')
gsea_table=GSAsummaryTable(gsaRes)
write.table(gsea_table,'../results/functional/enrichments/KEGG_ctrp.tsv',sep='\t')  