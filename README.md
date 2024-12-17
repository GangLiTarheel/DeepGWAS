# DeepGWAS
### DeepGWAS to Enhance GWAS Signals for Neuropsychiatric Disorders via Deep Neural Network 

In this work, we developed a 14-layer deep neural network, DeepGWAS, to enhance GWAS signals by leveraging GWAS summary statistics (p-value, odds ratio, minor allele frequency, linkage disequilibrium score), as well as brain-related functional genomic and epigenomic information (FIRE, super FIRE, open chromatin, eQTL). 

![image](https://github.com/GangLiTarheel/DeepGWAS/blob/main/DeepGWAS-structure.jpg)


DeepGWAS is maintained by Jia Wen [jia_wen@med.unc.edu] and Gang Li [gangliuw@uw.edu].



## News and Updates
All notable changes to this project will be documented in [this file](https://github.com/GangLiTarheel/DeepGWAS/blob/main/changelog.md).
  
## Installation

Our DeepGWAS is tested with R 3.6.0 with the keras package. See our session info [here](https://github.com/GangLiTarheel/DeepGWAS/blob/main/bin/00-SessionInfo.R).

+ R 3.6.0
+ [tensorflow](https://cran.r-project.org/web/packages/tensorflow/index.html)
+ [keras](https://cran.r-project.org/web/packages/keras/index.html)

### Data Preparation

GWAS summary statistics are needed for enhancement. Functional annotations are also needed.

### Enhancement

We provide our pre-trained model for users to enhance GWAS signals. Users can also use their own data to train a DeepGWAS network for prediction.

```{R enhancement}
R CMD BATCH --no-save --no-restore '--args input_data=enhance.Rdata model=DeepGWAS_SCZ.h5 output_file="enhance.txt"' bin/03-DeepGWAS-enhance.R   

```

### Training

```{R Training}
R CMD BATCH --no-save --no-restore '--args input_data=train.Rdata output_file="DeepGWAS.model.h5"' bin/02-DeepGWAS-train.R

```

## Citation

1. DeepGWAS ms
2. PMID: 35396580
