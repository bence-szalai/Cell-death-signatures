library("compareDrugScreens")

data('gcsi.line.info')
data("gcsi.genomics")
data('gcsi.genomics.feature.info')

write.csv(gcsi.line.info,file = '../data/gCSI/cell_line_info.csv',sep=',')
write.csv(gcsi.genomics,file = '../data/gCSI//genomics.csv',sep=',')
write.csv(gcsi.genomics.feature.info,file = '../data/gCSI//genomics_info.csv',sep=',')