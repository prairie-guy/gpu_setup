#!/usr/bin/env bash
# 05/03/2022
##
## Clean  install
## 1. install-server-mamba-1.sh
## 2. install-server-fastai-2.sh



## Clearn up
cd
rm -fr mambaforge*

## Mamba
curl -L -O "https://github.com/conda-forge/miniforge/releases/latest/download/Mambaforge-$(uname)-$(uname -m).sh"
bash Mambaforge-$(uname)-$(uname -m).sh
rm Mambaforge-Linux*
~/mambaforge/bin/conda init bash


######################################################################
## CRITICAL THAT WE RELOAD SHELL AFTER THIS FOR CONDA TO WORK       ## 
## Next Install fastai: fastai_setup.sh                             ##
######################################################################

echo "done: install-server-mamba-1.sh"
echo "next: exit/reload shell"
echo "next: install-server-fastai-2.sh"
exit
