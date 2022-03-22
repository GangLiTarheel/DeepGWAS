# DeepGWAS
### DeepGWAS to Enhance GWAS Signals for Neuropsychiatric Disorders via Deep Neural Network 

In this work, we developed a 14-layer deep neural network, DeepGWAS, to enhance GWAS signals by leveraging GWAS summary statistics (p-value, odds ratio, minor allele frequency, linkage disequilibrium score), as well as brain related functional genomic and epigenomic information (FIRE, super FIRE, open chromatin, eQTL). 

DeepGWAS is maintained by Jia Wen [jia_wen@med.unc.edu] and Gang Li [gangliuw@uw.edu].

## News and Updates
03.15.2022
* Version 0.1.0
  + Gang uploaded the script for training and evaluation.


## Installation

can add later.

### Data Preparation

GWAS summary statistics are needed for enhancement. Functional annotations are also needed.

### Enhancement

We provide our pretrained model for users to enhance GWAS signals. User can also use their own data to train a DeepGWAS network for prediction.

```{R enhancement}
R CMD BATCH --no-save --no-restore '--args input_data=enhance.Rdata model=DeepGWAS_SCZ.h5 output_file="enhance.txt"' bin/03-DeepGWAS-enhance.R   

```

### Training

```{R Training}
R CMD BATCH --no-save --no-restore '--args input_data=train.Rdata output_file="DeepGWAS.model.h5"' bin/02-DeepGWAS-train.R

```

## Citation
XXX
