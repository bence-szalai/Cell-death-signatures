library(biomaRt)

data=read.table('../data/GDSC/sanger1018_brainarray_ensemblgene_rma.txt',sep='\t',
              header=T,stringsAsFactors=FALSE)
genelist=data$ensembl_gene

species='hsapiens_gene_ensembl'

from='ensembl_gene_id'
to='hgnc_symbol'

mart = useMart("ensembl", dataset = species)

genelist=getBM(values=genelist,attributes = c(from,to), 
               filters = from,mart = mart)

write.csv(genelist,file='../data/GDSC/ensembl_hgnc.csv')