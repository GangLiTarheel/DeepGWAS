## 04.18.2022
# Gang Li

example_data <- read.table("data/Example_data.txt",header=T)

dim(example_data) # 47386    35
head(example_data)

select_list<-2:34

trainLabels_matrix <- example_data[,select_list];
trainLabels_matrix = data.matrix(trainLabels_matrix)
pred_labledata = trainLabels_matrix