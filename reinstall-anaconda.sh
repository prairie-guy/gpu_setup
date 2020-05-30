#!/usr/bin/env bash

## Add Anaconda
cd ~
#ANACONDA_VERSION='Anaconda3-2019.03-Linux-x86_64.sh'
ANACONDA_VERSION='Anaconda3-2020.02-Linux-x86_64.sh'
sudo rm -fr ~/.cache # Hack. Not sure where this comes from, but it screws things up
cd ~/downloads/
wget https://repo.continuum.io/archive/$ANACONDA_VERSION
bash $ANACONDA_VERSION -b
cd
echo export PATH=~/anaconda3/bin:$PATH >> ~/.bashrc
export PATH=~/anaconda3/bin:$PATH
source ~/.bashrc
conda init bash

conda create -n fastai python=3.6

conda init bash
echo conda activate fastai >> .bashrc

echo Sever Installed.
echo *** LOGOUT OF SHELL ***
echo *** LOGOUT OF SHELL ***
echo *** Logout of shell for rest of of fastai install . . .
exit

######################################################################
## CRITICAL THAT WE RELOAD SHELL AFTER THIS FOR CONDA TO WORK       ## 
## Next Install fastai: fastai_setup.sh                             ##
######################################################################
echo "reinstall-anaconda.sh: complete"
