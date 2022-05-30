#!/usr/bin/env bash
# 05/03/2022
##
## Clean  reinstall
## 1. reinstall-anaconda.sh
## 2. reinstall-fastai.sh
## 3. reinstall-jupyter.sh


## Update Version to the most recent
ANACONDA_VERSION='Anaconda3-2022.05-Linux-x86_64.sh'


## Clearn up
cd
rm -fr anaconda3
rm -fr mambaforge*
sudo rm -fr ~/.cache # Hack. Not sure where this comes from, but it screws things up


## Anaconda
# cd ~/downloads/
# wget https://repo.continuum.io/archive/$ANACONDA_VERSION
# bash $ANACONDA_VERSION -b
# cd
# conda init bash
# conda create -n fastai python=3.9
#echo conda activate fastai >> .bashrc

## Mamba
wget https://github.com/conda-forge/miniforge/releases/latest/download/Mambaforge-Linux-x86_64.sh
bash Mambaforge-*.sh -b
rm Mambaforge-Linux*
~/mambaforge/bin/conda init bash
mamba create -n fastai python=3.9
mamba activate fastai

######################################################################
## CRITICAL THAT WE RELOAD SHELL AFTER THIS FOR CONDA TO WORK       ## 
## Next Install fastai: fastai_setup.sh                             ##
######################################################################

echo "done: reinstall-anaconda.sh"
echo "next: exit/reload shell"
echo "next: reinstall-fastai.sh"
exit
