#!/usr/bin/env bash

######################################################
#
# install-scratch-2.sh
# install-scratch-1.sh (Should previously been executed)
# MAKE SURE THIS IS BEING INSTALLED IN `scratch` environment
#
######################################################
#
# CBD: Basic Scratch Box Set Up
# Based upon install-gpu.sh
# https://github.com/prairie-guy/gpu_setup
# 
# Modified from http://files.fast.ai/setup/paperspace
#
# Install a generally client workspace without "root" privelage
# 
# This script is designed to work with Ubuntu, but should work with most linux systems
#
######################################################
#
# USE: O) Previously: ./install-scratch-1.sh 
#      1) ./install-scratch-2.sh 
#
######################################################


## Make sure your have previously installed fastai env with:
## ``conda create -n scratch python=3.7``
## SHOULD BE IN scratch ENV BEFORE RUNNING SCRIPT!!!

## Jupyter Setup
conda install jupyter notebook

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

## Late Installs
conda install ipython

## This was installed in gpu_install.sh
jupyter notebook --generate-config
jupass=`python -c "from notebook.auth import passwd; print(passwd())"`
echo "c.NotebookApp.password = u'"$jupass"'" >> ~/.jupyter/jupyter_notebook_config.py
echo "c.NotebookApp.ip = '*'" >> ~/.jupyter/jupyter_notebook_config.py
echo "c.NotebookApp.open_browser = False" >> ~/.jupyter/jupyter_notebook_config.py
echo "c.NotebookApp.allow_remote_access = True" >> ~/.jupyter/jupyter_notebook_config.py

## HomeBrew for linux
# Add Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

echo Need to automate the scripts required by brew, in mean time
echo run scripts manually, then add, emacs, tmux and mosh
exit

# Update .bash_profile
echo 'eval $(/home/cdaniels/.linuxbrew/bin/brew shellenv)' >> /home/cdaniels/.bash_profile
eval $(/home/cdaniels/.linuxbrew/bin/brew shellenv)

# Emacs
brew install emacs
# Set up emacs config file
cd
rm -fr ~/.emacs.d
git clone https://github.com/prairie-guy/emacs_dotfile.git .emacs.d
cd .emacs.d
./setup.sh
cd

# Brew Installs
brew install tmux
brew install mosh

echo "Sucess: install-scratch-2.sh installed"
