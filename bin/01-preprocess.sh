# Jia
# prepare the RData for DeepGWAS training and enhancing.
# This script only combines all the predictors into RDS data used as input of deepGWAS
DS=23
set="B"
setwd("/proj/yunligrp/users/jwen/SCZ_Pat_12182018/022021_Trainings/")
library(vroom)
library(tidyverse)
library(qdapTools)
dir = paste0("/proj/yunligrp/users/jwen/SCZ_Pat_12182018/022021_Trainings/split",DS,"/set",set,"_GWAS_SNP/")
dir1 = paste0("/proj/yunligrp/users/jwen/SCZ_Pat_12182018/022021_Trainings/split",DS,"/set",set,"_GWAS_sigSNP/")
dir3="/proj/yunligrp/users/jwen/SCZ_Pat_12182018/022021_Trainings/sumstats/EUR/meta/"
dir4="/proj/yunligrp/users/jwen/SCZ_Pat_12182018/022021_Trainings/anno/density/"
dir5="/proj/yunligrp/users/jwen/SCZ_Pat_12182018/022021_Trainings/anno/CADD_Fathxmm_deepgwas_vars/"

lds_knownVars = vroom(paste0(dir1,"chrs_sigSNP_GWAS_posi_lds"),col_names=F,col_types=cols());
colnames(lds_knownVars) = c("SNPID","ldscore_knownVars");
# anno <- c("open_adult", "open_fetal", "superfire40kb_Fetal", "superfire40kb_Adult",
#          "fire40kb_Fetal", "fire40kb_Adult", "footprints", "tfbinding", "cCRE", "rad21",
#          "chiapet.loops", "dhs.peaks", "Adult_cortex_OC", "H3k27ac_Adult_and_enhancers",
#          "Adult_noncortex_OC", "H3k27ac_Fetal", "Fetal", "Organoid_and_iPSC","phylop","sweeps")

dat_chrs <- NULL
for(i in c(1:22)){
    cat("chr",i,"\n");
    # LD score and MAF
    dat1 <- vroom(paste0(dir,"chr",i,"_SNP_GWAS_posi_lds_MAF"),col_names=F,col_types=cols())
        
    # Gene density
    # dat2 <- vroom(paste0(dir4,"DS",DS,"_set",set,"_chr",i,"_geneDensity"),col_names=F,col_types=cols())

    # CADD and Fathxmm
    dat3 <- vroom(paste0(dir5,"split",DS,"_set",set,"/chr",i,".out.gz"),col_names=F,col_types=cols())

    # dat <- left_join(dat1,dat2,by=c("X1"="X3"))
    # dat_noNA = dat[!is.na(dat$X1),]
    
    dat_combine_dat3 <- left_join(dat1,dat3,by="X1")
    # dat_combine_dat3 %>% group_by(dat_combine_dat3$X1) %>% filter(n()>1)
    dat_combine_dat3.nona <- na.omit(dat_combine_dat3)
    # dat_combine_dat3.nona %>% group_by(dat_combine_dat3.nona$X1) %>% filter(n()>1)

    # annotation
    dat_anno_all <- vroom(paste0(dir,"chr",i,".anno.data_driven.features"),col_names = F,col_types=cols()) %>% select("X4","X5") %>% unique()
    x_mat = data.frame(matrix(unlist(table(dat_anno_all$X4,dat_anno_all$X5)),ncol=25,byrow=F))
    x_mat$SNPID = rownames(table(dat_anno_all$X4,dat_anno_all$X5))
    if (dim(x_mat)[[2]] == 26){
        colnames(x_mat) = c(colnames(table(dat_anno_all$X4,dat_anno_all$X5)),"SNPID")
        dat_combine_dat4.nona <- full_join(dat_combine_dat3.nona,x_mat,by=c("X1"="SNPID"))
        dat_combine_dat4.nona[,6:30][is.na(dat_combine_dat4.nona[,6:30])] = 0        
    }else{cat("Note!!!",i); break}

    colnames(dat_combine_dat4.nona) <- c("SNPID","LDscore","MAF_EUR","CADD","Fathxmm",colnames(x_mat)[-length(colnames(x_mat))])
    dat_chrs  <- rbind(dat_chrs,dat_combine_dat4.nona);

    rm(dat1,dat2,dat3,dat_combine_dat3,dat_combine_dat3.nona,dat_combine_dat4.nona)
}
# beta and pvalue
dat_meta <- vroom(paste0(dir3,"SCZ_EUR_set",set,"_DS",DS,"_1.tbl"),col_names=T,col_types=cols())
dat_meta <- dat_meta %>% mutate(OR=exp(Effect)) %>% mutate(log10P=-log10(`P-value`)) %>% select("MarkerName","OR","log10P")
dat_combine_meta <- full_join(dat_chrs,dat_meta,by=c("SNPID" = "MarkerName"))
dat_combine_meta_ldsKV <- full_join(dat_combine_meta,lds_knownVars,by="SNPID")

### Annotation - eQTL ###
eQTL <- vroom("/proj/yunligrp/users/jwen/SCZ_Pat_12182018/022021_Trainings/anno/eQTL/eQTL_hg19.bed",col_names=F,col_types=cols())
dat_combine_meta_ldsKV$eQTL = 0;
SNPID_list <- dat_combine_meta_ldsKV %>% mutate(chr=matrix(unlist(strsplit(as.matrix(dat_combine_meta_ldsKV$SNPID),"_")),ncol=3,byrow = T)[,1]) %>%
                mutate(hg19bp=matrix(unlist(strsplit(as.matrix(dat_combine_meta_ldsKV$SNPID),"_")),ncol=3,byrow = T)[,2])
dat_combine_meta_ldsKV$eQTL[paste0(SNPID_list$chr,"_",SNPID_list$hg19bp) %in% eQTL$X4] = 1
dat_combine_meta_ldsKV.nona = na.omit(dat_combine_meta_ldsKV)

dir_output=paste0("/proj/yunligrp/users/jwen/SCZ_Pat_12182018/022021_Trainings/split",DS,"/");
# print(dat_combine_meta_ldsKV.nona, n=5,width = Inf)
dim(dat_combine_meta_ldsKV.nona)
saveRDS(dat_combine_meta_ldsKV.nona, file = paste0(dir_output,"split",DS,"_set_",set,"_data_driven.rds"))
