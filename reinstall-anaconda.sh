#!/usr/bin/env bash
# 05/03/2022
##
## Clean  reinstall
## 1. reinstall-anaconda.sh
## 2. reinstall-fastai.sh
## 3. reinstall-jupyter.sh


## Update Version to the most recent
ANACONDA_VERSION='Anaconda3-2021.11-Linux-x86_64.sh'

## Clearn up
cd
rm -fr anaconda3
sudo rm -fr ~/.cache # Hack. Not sure where this comes from, but it screws things up
cd ~/downloads/
wget https://repo.continuum.io/archive/$ANACONDA_VERSION
bash $ANACONDA_VERSION -b
cd
echo export PATH=~/anaconda3/bin:$PATH >> ~/.bashrc
export PATH=~/anaconda3/bin:$PATH
source ~/.bashrc

# create conda fastai env
conda init bash

conda create -n fastai python=3.9
conda init bash
echo conda activate fastai >> .bashrc
exit

######################################################################
## CRITICAL THAT WE RELOAD SHELL AFTER THIS FOR CONDA TO WORK       ## 
## Next Install fastai: fastai_setup.sh                             ##
######################################################################

echo "done: reinstall-anaconda.sh"
echo "next: exit/reload shell"
echo "next: reinstall-fastai.sh"
