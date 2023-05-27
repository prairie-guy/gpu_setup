#!/usr/bin/env bash
# 05/03/2022
##
## Clean  install
## 1. install-server-mamba-1.sh
## 2. install-server-fastai-2.sh



## Clearn up
cd
rm -fr mambaforge* Mambaforge*
rm -fr .conda
rm -fr .local/share/jupyter/
rm -fr .local/etc/jupyter
rm -fr .local/share/julia
rm -fr .julia


## Mamba
curl -L -O "https://github.com/conda-forge/miniforge/releases/latest/download/Mambaforge-$(uname)-$(uname -m).sh"
bash Mambaforge-$(uname)-$(uname -m).sh
rm Mambaforge-Linux*
~/mambaforge/bin/conda init bash

## Activate fastai enviromnent
conda activate base
conda remove --name fastai --all
conda create -n fastai python=3.11 # python=3.10
conda init bash
conda activate fastai

######################################################################
## CRITICAL THAT WE RELOAD SHELL AFTER THIS FOR CONDA TO WORK       ## 
## Next Install fastai: install-server-fastai-2.sh                  ##
######################################################################

echo "done: install-server-mamba-1.sh"
echo "next: exit/reload shell"
echo "next: install-server-fastai-2.sh"
exit
