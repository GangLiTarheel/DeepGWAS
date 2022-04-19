####################
# 11.06.2021
# SCZ model with pure EUR population!
# Wave 2: 108 -> wave 2c: 145


# Load packages
library(keras);
library(stringr);
library(pbapply);
library(tensorflow);

# # Set output directory
# date="2021-11-06"
# output_dir=paste0("/proj/yunligrp/users/gangli/SCZ_pat_08172018/results/",date,"/")
# print(output_dir)
# dir.create(output_dir)
# setwd(output_dir)

## prepare the data
# load("/proj/yunligrp/users/gangli/SCZ_pat_08172018/code/2021-11-06-SCZ-EUR/Wave_2_2c_train.Rdata")
# head(train_data)
# dim(train_data)

# load("/proj/yunligrp/users/gangli/SCZ_pat_08172018/code/2021-11-06-SCZ-EUR/Wave_2c_3_pred.Rdata")
# pred_data$Fathxmm = as.numeric(pred_data$Fathxmm)
# dim(pred_data) # 9958786      34    
# head(pred_data)

# diamond_list <- c(2:34)
# select_list <- diamond_list


# ## Generate the train data format used for DNN
# # subset: train data p < threshold
# threshold1 = 1e-8 #0.0005 # 0.01 # 0.008 #5e-8
# subset_id1 = which( as.numeric(as.matrix(train_data$'log10(p)') ) > -log10(threshold1))
# length(subset_id1) # 8693 #15603 for 7e-8 # 14132 for 3e-8 # 12669 1e-8 #  1571

# # Yun's recommendation
# threshold2 = 0.1
# subset_id2= which( as.numeric(as.matrix(train_data$'log10(p)') ) < -log10(threshold2))
# length(subset_id2) # 5631432
# set.seed(1314)
# subset_id2 = sample(subset_id2,30000)


# subset_id = c(rep(subset_id1,2),subset_id2) #subset_id1 #c(subset_id1,subset_id2) #50 for split
# length(subset_id)
# train_data_sub = train_data[sample(subset_id) ,];


# colnames(train_data)
# diamond_list <- c(2:34)
# select_list <- diamond_list
# # 1 SNPID
# # 4 chr
# # 5 hg19bp
# # 6 geneDnesity
# # 35 log10P # log10P.y
# print("selected:")
# colnames(train_data)[select_list]
# colnames(pred_data)[select_list]

# trainLabels_matrix <- train_data_sub[,select_list];
# trainLabels_matrix = data.matrix(trainLabels_matrix);
# pred_labledata = data.matrix(pred_data[,select_list])
# # Warning NAs introduced by coercion

example_data <- read.table("data/Example_data.txt",header=T)

dim(example_data) # 47386    35
head(example_data)

select_list<-2:34
trainLabels_matrix <- example_data[,select_list];
trainLabels_matrix = data.matrix(trainLabels_matrix)

dim(trainLabels_matrix);
head(trainLabels_matrix);

# Tune DNN methods:
model_dir = "/model/"
#model_name = "Run20200806-1_DNN_diamond_baseline.h5"

validation_split = 0.2
batch_size = 250 #250
epoch = 10 # 30 is fine

final_res <- NULL;
for (v in 1:length(validation_split)){
  for(b in 1:length(batch_size)){
    for(e in 1:length(epoch)){
      res <- NULL;
      use_session_with_seed(33);
      # use_session_with_seed(42, disable_gpu = FALSE, disable_parallel_cpu = FALSE);
      model <- keras_model_sequential();
      
      model %>% 
        layer_dense(units = 5, activation = 'relu', kernel_initializer = 'orthogonal',input_shape = c(dim(trainLabels_matrix)[2])) %>% 
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
        optimizer = optimizer_adam(lr = 0.0005),# 0.0005 #0.000005 # 0.01
        metrics = 'accuracy'
      )
      
      history <- model %>% fit(
        trainLabels_matrix, #data.matrix(train_data[,-c(1,4,5,ncol(train_data))]),#trainLabels_matrix,
        as.numeric( train_data_sub[,ncol(train_data)] > -log10(5e-8) ),
        epochs = epoch[e],
        batch_size = batch_size[b],
        validation_split = validation_split[v]
      )
      
      print(history);
      # save(history, file = paste0(output_dir,"DNN_diamond_TrainingHistory.RData"))
      summary(model)

    #   plot_history = 0
    #   if (plot_history==1){
    #       jpeg(paste0(output_dir,"TrainingHistory-3.jpeg"))
    #       plot(history)
    #       dev.off()
    #   }


    #   additional_output = 0
    #   if (additional_output ==1){
    #     jpeg(paste0(output_dir,"TrainingHistory-1.jpeg"))
    #     plot(history$metrics$acc, main="Model Accuracy", xlab = "epoch", ylab="accuracy", col="blue", type="l")
    #     # 
    #     # # Plot the accuracy of the validation data
    #     lines(history$metrics$val_acc, col="green")
    #     # 
    #     # # Add Legend
    #     legend("bottomright", c("train","test"), col=c("blue", "green"), lty=c(1,1))
    #     dev.off()
    #     # set.seed(1);
    #     score0 <- model %>% evaluate(trainLabels_matrix, as.numeric( train_data_sub[,ncol(train_data_sub)] > -log10(5e-8) ), batch_size = batch_size[b]);
    #     print(score0);
    #     classes <- model %>% predict_classes(trainLabels_matrix,batch_size = batch_size[b]);
    #     # Table 2:
    #     table2_0 = table(trainLabels_matrix[,ncol(trainLabels_matrix)], factor(classes,levels=0:1));
      
    #     #score <- model %>% evaluate(train_data[,select_list], as.numeric(train_data[,ncol(train_data)] > -log10(5e-8) ), batch_size = batch_size[b]);
    #     #print(score);
        
    #     pred <- model %>% predict(pred_labledata,batch_size = batch_size[b]);
    #     classes <- model %>% predict_classes(pred_labledata,batch_size = batch_size[b]);
    #     table(classes)
    #     # Table 2:
    #     #table2 = table(pred_data$log10P > -log10( 5e-8) , factor(classes,levels=0:1));
    #     # Table 1:
    #     observed_pre = ifelse(as.numeric(as.character(pred_data$'log10(p)')) > -log10(5e-8),1,0);
    #     table(observed_pre)
    #     #table1 = table(observed_pre,train_data[,1]);
        
    #     # Table 3:
    #     table3 = table(observed_pre,factor(classes,levels=0:1));
        
    #     print("Training results:")
    #     print("Compare enhancement with wave 3:")
    #     print(table3)
       
    #   }
      
    #   save_model = 0
    #   if (save_model==1){
    #     round = "Run-2021-11-06-1"
    #     # if (length(select_list) == length(gold_list))
    #     #   save_model_hdf5(model, file = paste0(output_dir,round,"_DNN_gold.h5"));
          
    #     # if (length(select_list) == length(silver_list))
    #     #   save_model_hdf5(model, file = paste0(output_dir,round,"_DNN_silver.h5"));
    #     if (length(select_list) == length(diamond_list))
    #       save_model_hdf5(model, file = paste0(output_dir,round,"_DNN_diamond_baseline.h5"));
    #     # Load the optimal model back:
    #     # model <- load_model_hdf5("DNN_1s_2_opt.h5");
    #   }

    #    # Predict the third wave:
    #   pred_results=0
    #   if (pred_results==1){
    #     pred_gang <- model %>% predict(data.matrix(pred_data[,select_list]))
    #   #classes_third_wave <- model %>% predict_classes( data.matrix(pred_data)[,select_list],batch_size = batch_size[b]);
    #   # Table 2:
    #   #oberserved_third = ifelse( as.numeric(pred_data$P.value) < 5e-08 ,1,0);
    #   #pred_mat = data.frame(pred_data$SNPID,oberserved_third);
    #   #write.table(pred_mat,"pred_mat_2c_01202020",col.names = T,row.names = F,sep="\t",quote = F);
      
    #   pred_test_label = ifelse(pred_gang > 0.5,1,0);
    #   #table2_next = table(oberserved_third,factor(pred_test_label,levels=0:1));
      
      
    #   # Table 1:
    #   #oberserved_second = ifelse(as.numeric(as.character(sub_data_noNAs_2_2c$p2)) < 5e-08,1,0);
    #   #table1_next = table(oberserved_second,oberserved_third);
      
    #   # Table 3:
    #   #table3_next = table(oberserved_second, factor(classes_third_wave,levels=0:1));
      
    #   #acc = (table2_next[1,1] + table2_next[2,2])/(sum(table2_next[1,]) + sum(table2_next[2,]));
    #   #print(acc);
      
    #   #res = c(validation_split[v],batch_size[b],epoch[e],table2[1,],table2[2,],table2_next[1,],table2_next[2,])
    #   #,table1[1,],table1[2,],
    #          # table2[1,],table2[2,],table3[1,],table3[2,],
    #     #      table1_next[1,],table1_next[2,],table2_next[1,],table2_next[2,],table3_next[1,],table3_next[2,],acc);
    #   #inal_res = rbind(final_res,res);
      
    #   #rm("model");
    #   #rm("res");
    #  # rm("acc");

    #   print("Enhanced results:")
    # #print(table2_next)
      
      }
      
    }
  }
}

# ## save enhancement results
# p_pred_prob = pred_gang
# cc = 0.5
# p_pred_label = as.numeric(p_pred_prob > cc)
# sum(is.na(p_pred_label))
# sum(p_pred_label[!is.na(p_pred_label)])

# ind = which(is.na(p_pred_label))
# pred_data$prob = p_pred_prob
# enhance3 = data.frame(pred_data)
# enhance3 =  enhance3[-ind,]
# save(enhance3, file="Wave3_enhanced.Rdata")
# write.table(enhance3,"Wave3_enhanced.txt",quote = F,sep="\t",col.names=T,row.names = F)


