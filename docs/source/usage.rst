Usage
=====

.. _installation:

Installation
------------

Our DeepGWAS is tested with R 3.6.0 with keras package. See our session info [here](https://github.com/GangLiTarheel/DeepGWAS/blob/main/bin/00-SessionInfo.R).

+ R 3.6.0
+ [tensorflow](https://cran.r-project.org/web/packages/tensorflow/index.html)
+ [keras](https://cran.r-project.org/web/packages/keras/index.html)

.. code-block:: R
   (.venv) $ install.packages("tensorflow")


Enhancement
----------------
We provide our pretrained model for users to enhance GWAS signals. User can also use their own data to train a DeepGWAS network for prediction.

For example:
.. code-block:: console

   (.venv) $  R CMD BATCH --no-save --no-restore '--args input_data=enhance.Rdata model=DeepGWAS_SCZ.h5 output_file="enhance.txt"' bin/03-DeepGWAS-enhance.R   



Data Preparation
----------------
GWAS summary statistics are needed for enhancement. Functional annotations are also needed.

Training
----------------
.. code-block:: console
   R CMD BATCH --no-save --no-restore '--args input_data=train.Rdata output_file="DeepGWAS.model.h5"' bin/02-DeepGWAS-train.R


