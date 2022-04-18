
date="2021-11-06"
output_dir=paste0("/proj/yunligrp/users/gangli/SCZ_pat_08172018/results/",date,"/")
print(output_dir)
#dir.create(output_dir)
setwd(output_dir)

## prepare the data
#load("/proj/yunligrp/users/gangli/SCZ_pat_08172018/code/2021-04-30-readdata/split5.Rdata")
#load("/proj/yunligrp/users/gangli/SCZ_pat_08172018/code/2021-05-17-readdata/split8.Rdata")
#pred_data = readRDS("AD_data/AD_data_drive_anno.rds")

#setwd("/proj/yunligrp/users/gangli/SCZ_pat_08172018/code/2021-11-06-SCZ-EUR")
load("/proj/yunligrp/users/gangli/SCZ_pat_08172018/code/2021-11-06-SCZ-EUR/Wave_2_2c_train.Rdata")
head(train_data)
dim(train_data)

load("/proj/yunligrp/users/gangli/SCZ_pat_08172018/code/2021-11-06-SCZ-EUR/Wave_2c_3_pred.Rdata")
pred_data$Fathxmm = as.numeric(pred_data$Fathxmm)
dim(pred_data) # 9958786      34    
head(pred_data)

diamond_list <- c(2:34)
#diamond_list <- c(2:3,7:8,34:36,9:33,37)
select_list <- diamond_list
#pred_labledata = data.matrix(pred_data[,select_list])


## Generate the train data format used for DNN
# subset: train data p < threshold
threshold1 = 1e-8 #0.0005 # 0.01 # 0.008 #5e-8
subset_id1 = which( as.numeric(as.matrix(train_data$'log10(p)') ) > -log10(threshold1))
length(subset_id1) # 8693 #15603 for 7e-8 # 14132 for 3e-8 # 12669 1e-8 #  1571

# Yun's recommendation
threshold2 = 0.1
subset_id2= which( as.numeric(as.matrix(train_data$'log10(p)') ) < -log10(threshold2))
length(subset_id2) # 5631432
set.seed(1314)
subset_id2 = sample(subset_id2,30000)


# undersampling
#temp = 1:length(train_data[,1])
#set.seed(1314)
#subset_id2 = sample(temp[!temp %in% subset_id1],50000)


subset_id = c(rep(subset_id1,2),subset_id2) #subset_id1 #c(subset_id1,subset_id2) #50 for split
length(subset_id)
train_data_sub = train_data[sample(subset_id) ,];

write.table(train_data_sub,"Example_data.txt",quote = F,sep="\t",col.names=T,row.names = F)

# diamond_list <- c(2:34)
# select_list <- diamond_list
# print("selected:")
# colnames(train_data)[select_list]

# trainLabels_matrix <- train_data_sub[,select_list];
# trainLabels_matrix = data.matrix(trainLabels_matrix);
# pred_labledata = data.matrix(pred_data[,select_list])