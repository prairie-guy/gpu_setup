#!/usr/bin/env bash

## Add Anaconda
cd ~
ANACONDA_VERSION='Anaconda3-2019.03-Linux-x86_64.sh'
sudo rm -fr ~/.cache # Hack. Not sure where this comes from, but it screws things up
cd ~/downloads/
wget https://repo.continuum.io/archive/$ANACONDA_VERSION
bash $ANACONDA_VERSION -b
cd
echo export PATH=~/anaconda3/bin:$PATH >> ~/.bashrc
export PATH=~/anaconda3/bin:$PATH
source ~/.bashrc
conda init bash

## Setup Jupyter Notebook Configuration
jupyter notebook --generate-config
jupass=`python -c "from notebook.auth import passwd; print(passwd())"`
echo "c.NotebookApp.password = u'"$jupass"'" >> ~/.jupyter/jupyter_notebook_config.py
echo "c.NotebookApp.ip = '*'" >> ~/.jupyter/jupyter_notebook_config.py
echo "c.NotebookApp.open_browser = False" >> ~/.jupyter/jupyter_notebook_config.py
echo "c.NotebookApp.allow_remote_access = True" >> ~/.jupyter/jupyter_notebook_config.py

# Add Jupyter Notebook Extensions, most importantly "Select CodeMirror Keymap" allows for emacs mode.
pip install ipywidgets
jupyter nbextension enable --py widgetsnbextension --sys-prefix

# Add Pip packages
# Great for functional program style
# I like: import funcy as fn
pip install funcy

# Create a conda env for fastai
# NOTE: THIS MUST BE SET BEFORE DOWNLOADING INTO fastai env
conda create -n fastai python=3.6
conda init bash
echo conda activate fastai >> .bashrc

echo Sever Installed.
echo *** LOGOUT OF SHELL ***
echo *** LOGOUT OF SHELL ***
echo *** Logout of shell for rest of of fastai install . . .
exit

# Set up google-cloud-sdk
# cd
# curl https://sdk.cloud.google.com | bash
# echo 'export GOOGLE_APPLICATION_CREDENTIALS=/home/cdaniels/google-cloud-sdk/cbd_auth.json'
# touch ~/google-cloud-sdk/cbd_auth.json
# echo 'NEED TO ADD JSON AUTHENTICATION TO THIS FILE'
# cd

######################################################################
## CRITICAL THAT WE RELOAD SHELL AFTER THIS FOR CONDA TO WORK       ## 
## Next Install fastai: fastai_setup.sh                             ##
######################################################################


echo "install-gpu.sh: complete"
