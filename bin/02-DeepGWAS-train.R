####################
# 11.02.2022
# DeepGWAS training tutorial
# Gang Li

# unlink("~/.R/Makevars")
# unlink("~/.Renviron")

# Load packages
library(keras);
library(stringr);
library(pbapply);
library(tensorflow);
#install_tensorflow(version = "nightly-gpu")
#reticulate::py_config()
# #is_keras_available()
# tf_config()
#install_tensorflow()

example_data <- read.table("data/Example_data.txt",header=T)

dim(example_data) # 47386    35
head(example_data)

select_list<-2:34
trainLabels_matrix <- example_data[,select_list];
trainLabels_matrix = data.matrix(trainLabels_matrix)

dim(trainLabels_matrix);
head(trainLabels_matrix);

# model dir:
model_dir = "/model/"
#model_name = "Run20200806-1_DNN_diamond_baseline.h5"

validation_split = 0.2
batch_size = 250 
epoch = 10 

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
        optimizer = optimizer_adam(lr = 0.0005),
        metrics = 'accuracy'
      )
      
      history <- model %>% fit(
        trainLabels_matrix,
        as.numeric( example_data[,ncol(example_data)] > -log10(5e-8) ),
        epochs = epoch[e],
        batch_size = batch_size[b],
        validation_split = validation_split[v]
      )
      
      print(history);
      # save(history, file = paste0(output_dir,"DNN_diamond_TrainingHistory.RData"))
      summary(model)

      
      save_model_hdf5(model, file = paste0("DeepGWAS_Model.h5"))
      
      
    }
  }
}



## Ablation study
ablation = 0
if (ablation==1){
  final_res <- NULL;
  ablation = 1:33
  for (a in ablation){
    for (v in 1:length(validation_split)){
      for(b in 1:length(batch_size)){
        for(e in 1:length(epoch)){
          res <- NULL;
          use_session_with_seed(33);
          # use_session_with_seed(42, disable_gpu = FALSE, disable_parallel_cpu = FALSE);
          model <- keras_model_sequential();
          
          model %>% 
            layer_dense(units = 5, activation = 'relu', kernel_initializer = 'orthogonal',input_shape = c(dim(trainLabels_matrix)[2]-1)) %>% 
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
          
          history <- model %>% fit(
            trainLabels_matrix[,-a], 
            as.numeric( example_data[,ncol(example_data)] > -log10(5e-8) ),
            epochs = epoch[e],
            batch_size = batch_size[b],
            validation_split = validation_split[v]
          )
          
          print(history);
          save(history, file = paste0("DeepGWAS_Ablation_TrainingHistory_",a,".RData"))
          # summary(model)

          plot_history = 1
          if (plot_history==1){
              jpeg(paste0("DeepGWAS_Ablation_TrainingHistory_",a,".jpeg"))
              plot(history)
              dev.off()
          }
          
          save_model_hdf5(model, file = paste0("DeepGWAS_Ablation_Model_",a,".h5"))
        
        }
      }
    }
  }
}




### END