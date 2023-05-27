#!/usr/bin/env bash
# 05/27/2023
##
## Clean  install
## 1. install-server-mamba-1.sh
## 2. install-server-fastai-2.sh
## 3. install-server-julia-3.sh


## Clearn up
cd
rm -fr mambaforge* Mambaforge*
rm -fr .conda
rm -fr .local/share/jupyter/
rm -fr .local/etc/jupyter
rm -fr .jupyter
rm -fr .julia


## Mamba
curl -L -O "https://github.com/conda-forge/miniforge/releases/latest/download/Mambaforge-$(uname)-$(uname -m).sh"
bash Mambaforge-$(uname)-$(uname -m).sh
rm Mambaforge-Linux*

## Activate fastai enviromnent
mambaforge/bin/mamba activate base
mambaforge/bin/mamba remove --name fastai --all
mambaforge/bin/mamba create -n fastai python=3.11
mambaforge/bin/mamba init bash
mambaforge/bin/mamba activate fastai

mambaforge/bin/mamba init bash

######################################################################
## CRITICAL THAT WE RELOAD SHELL AFTER THIS FOR CONDA TO WORK       ## 
## Next Install fastai: install-server-fastai-2.sh                  ##
######################################################################

echo "done: install-server-mamba-1.sh"
echo "next: exit/reload shell"
echo "next: install-server-fastai-2.sh"
echo "next: install-server-julia-3.sh"
exit
