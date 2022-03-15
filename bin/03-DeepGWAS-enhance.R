## enhance template
# 11.06.2021

## Applied pre-trained DeepGWAS model to wave 2c
# Gang Li



library(keras);
library(stringr);
library(pbapply);
library(tensorflow);

## prepare the data
load("/proj/yunligrp/users/gangli/SCZ_pat_08172018/code/2021-11-06-SCZ-EUR/Wave_2c_3_pred.Rdata")
pred_data$Fathxmm = as.numeric(pred_data$Fathxmm)
dim(pred_data) # 9958786      34    
head(pred_data)

diamond_list <- c(2:34)
select_list <- diamond_list



## load the model 

model_dir = "/proj/yunligrp/users/gangli/SCZ_pat_08172018/results/2021-11-06/"
model_name = "Run-2021-11-06-1_DNN_diamond_baseline.h5"

model <- keras_model_sequential();

model %>% 
layer_dense(units = 5, activation = 'relu', kernel_initializer = 'orthogonal',input_shape = c(length(select_list))) %>% 
layer_dense(units = 20, activation = 'relu', kernel_initializer = 'orthogonal',input_shape = c(5)) %>% 
layer_dense(units = 5, activation = 'relu', kernel_initializer = 'orthogonal',input_shape = c(20)) %>% 
layer_dense(units = 10, activation = 'relu',kernel_initializer = 'orthogonal',input_shape = c(5)) %>% 
layer_dense(units = 5, activation = 'relu', kernel_initializer = 'orthogonal',input_shape = c(10)) %>% 
layer_dense(units = 10, activation = 'relu', kernel_initializer = 'orthogonal',input_shape = c(5)) %>% 
layer_dense(units = 5, activation = 'relu',kernel_initializer = 'orthogonal',input_shape = c(10)) %>% 
layer_dense(units = 10, activation = 'relu', kernel_initializer = 'orthogonal',input_shape = c(5)) %>% 
layer_dense(units = 5, activation = 'relu', kernel_initializer = 'orthogonal',input_shape = c(10)) %>% 
layer_dense(units = 10, activation = 'relu',kernel_initializer = 'orthogonal',input_shape = c(5)) %>% 
layer_dense(units = 5, activation = 'relu', kernel_initializer = 'orthogonal',input_shape = c(10)) %>% 
layer_dense(units = 10, activation = 'relu', kernel_initializer = 'orthogonal',input_shape = c(5)) %>% 
layer_dense(units = 5, activation = 'relu', kernel_initializer = 'orthogonal',input_shape = c(10)) %>% 
layer_dense(units = 1, activation = 'sigmoid', kernel_initializer = 'orthogonal',input_shape = c(5))

model %>% compile(
loss = 'binary_crossentropy',
optimizer = optimizer_adam(lr = 0.0005),
metrics = 'accuracy'
)

model <- load_model_hdf5(paste0(model_dir,model_name))

## predict
pred_gang <- model %>% predict(data.matrix(pred_data[,select_list]))
colnames(pred_data)[32] = 'log10p'
observed = ifelse( as.numeric(pred_data$log10p) > -log10(5e-08) ,1,0);
pred_test_label = ifelse(pred_gang > 0.5,1,0);
table2 = table(observed,factor(pred_test_label,levels=0:1));

print("Enhanced results:")
print(table2)

#FN = intersect( which(pred_test_label == 0), which(oberserved_third == 1) )


date="2021-11-06"
output_dir=paste0("/proj/yunligrp/users/gangli/SCZ_pat_08172018/results/",date,"/")
print(output_dir)
#dir.create(output_dir)
setwd(output_dir)

pred_data$prob = pred_gang
save(pred_data,file=paste0(output_dir,"Enhanced_AD_Sch.RData"))
write.table(pred_data,"Enhanced_AD_Sch.txt",quote = F,sep="\t",col.names=T,row.names = F)


