## Reproduce Jaccard Plot
# Gang Li
# 04.18.2022

setwd("~/Documents/GitHub/DeepGWAS/plot/jaccard_plot")

if (!require("RColorBrewer")) {
  install.packages("RColorBrewer")
  library(RColorBrewer)
}

##
jaccard_table <- read.table('pairwise_jaccard_XinHeOnly.txt', header=TRUE,sep=" ")
row.names(jaccard_table) <- jaccard_table$name
jaccard_table <- jaccard_table[, -1]
jaccard_matrix <- as.matrix(jaccard_table)
#library(ggplot2)

for (i in 1:31){
  for (j in i:31){
    if (is.na(jaccard_matrix[i,j])){
      jaccard_matrix[i,j] = jaccard_matrix[j,i]
    } else {
      jaccard_matrix[j,i] = jaccard_matrix[i,j]
    }
  }
}
sum(is.na(jaccard_matrix))

# 08.21 remove IPS
# IPS is reprogramming cells, mimic immature early stage stem cell.
# other data for differentiated tissue/cell type.
colnames(jaccard_matrix)[14]

library(gplots)
png("heatmap_XinHe_only_high_res.png", width=12, height=12,units="in",res=1200) # 1k 1k
heatmap.2(jaccard_matrix[-14,-14], 
          col=brewer.pal(9,"Blues"), 
          margins = c(14, 14),
          density.info = "none",
          lhei = c(4, 10),
          trace="none",
          cexRow = 1.4,
          cexCol = 1.4)
dev.off()

# ## read data
# jaccard_table0 <- read.table('pairwise_jaccard_XinHeOnly.txt', header=TRUE,sep=" ")
# row.names(jaccard_table0) <- jaccard_table0$name
# jaccard_table0 <- jaccard_table0[, -1]
# jaccard_matrix0 <- as.matrix(jaccard_table0)
# 
# jaccard_table2 <- read.table('pairwise_jaccard_2.txt', header=TRUE,sep=" ")
# row.names(jaccard_table2) <- jaccard_table2$name
# jaccard_table2 <- jaccard_table2[, -1]
# jaccard_matrix2 <- as.matrix(jaccard_table2)
# 
# jaccard_table <- read.table('pairwise_jaccard_1.txt', header=TRUE,sep=" ")
# row.names(jaccard_table) <- jaccard_table$name
# jaccard_table <- jaccard_table[, -1]
# jaccard_matrix <- as.matrix(jaccard_table)
# 
# encode_list <- c("encode3_cCRE","encode3_chiapet","encode3_dhs_footprints","encode3_dhs_peaks","encode3_rad21","encode3_tfbinding")
# #sjaccard_matrix[is.na(jaccard_matrix)]=0
# for (i in 1:37){
#   for (j in 1:37){
#     # check if in the table 1
#     if (is.na(jaccard_matrix[i,j])){
#       jaccard_matrix[i,j] = jaccard_matrix[j,i]
#     } else {
#       jaccard_matrix[j,i] = jaccard_matrix[i,j]
#     }
#     if (is.na(jaccard_matrix[i,j])){
#       r = rownames(jaccard_matrix)[i]
#       c = colnames(jaccard_matrix)[j]
#       
#       #if (is.na(jaccard_matrix[i,j])){
#       #if ((r %in% encode_list) || (c %in% encode_list)){
#       # check if in the table 2
#       if ((r %in% encode_list) && ( !is.na(jaccard_matrix2[r,c]) ) ){
#         jaccard_matrix[i,j] = jaccard_matrix2[r,c]#jaccard_matrix2[max(i-7,7-i),c]
#         jaccard_matrix[j,i] = jaccard_matrix2[r,c]
#       } 
#       if ((c %in% encode_list) && ( !is.na(jaccard_matrix2[c,r]) ) ){
#         jaccard_matrix[i,j] = jaccard_matrix2[c,r]#jaccard_matrix2[max(j-7,7-j),r]
#         jaccard_matrix[j,i] = jaccard_matrix2[c,r]
#       }
#       
#       # check if in the table 0
#       if ((!(r %in% encode_list)) && (!(c %in% encode_list))  ){
#         if (is.na(jaccard_matrix0[r,c])){
#           jaccard_matrix[i,j] = jaccard_matrix0[c,r]
#           jaccard_matrix[j,i] = jaccard_matrix0[c,r]
#         }else{
#           jaccard_matrix[i,j] = jaccard_matrix0[r,c]
#           jaccard_matrix[j,i] = jaccard_matrix0[r,c]
#         }
#       }
#       
#     }
#   }
# }
# 
# sum(is.na(jaccard_matrix))
# 
# 
# #### plot 1
# 
# library(gplots)
# png("heatmap_anno_1.png", width=1000, height=1000)
# heatmap.2(jaccard_matrix, 
#           col=brewer.pal(9,"Blues"), 
#           margins = c(14, 14),
#           density.info = "none",
#           lhei = c(2, 8),
#           trace="none")
# dev.off()

### Plot 2: all anno (37)
jaccard_table <- read.table('pairwise_jaccard.txt', header=TRUE,sep=" ")
row.names(jaccard_table) <- jaccard_table$name
jaccard_table <- jaccard_table[, -1]
jaccard_matrix <- as.matrix(jaccard_table)
#library(ggplot2)
sum(is.na(jaccard_matrix))


for (i in 1:37){
  for (j in i:37){
    if (is.na(jaccard_matrix[i,j])){
      jaccard_matrix[i,j] = jaccard_matrix[j,i]
    } else {
      jaccard_matrix[j,i] = jaccard_matrix[i,j]
    }
  }
}
sum(is.na(jaccard_matrix))

jaccard_matrix[10,10]=1

library(gplots)
png("heatmap_anno_1_high_res.png", width=14, height=14,units="in",res=1200)
heatmap.2(jaccard_matrix, 
          col=brewer.pal(9,"Blues"), 
          margins = c(14, 14),
          density.info = "none",
          lhei = c(4, 10),
          trace="none",
          cexRow = 1.4,
          cexCol = 1.4)
dev.off()
