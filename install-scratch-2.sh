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

## Jupyter Setup
conda install jupyter notebook

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

## conda-forge install tmux
conda install -c conda-forge tmux

## mosh install
conda install -c conda-forge mosh

# Install a script to launch mosh locally. This fix to allows emacs to work with Blink (over ssh) to use mosh (localhost).
# Simply use: 'msh_up' as ~/bin is in the $PATH
# NEED TO FIX passing $MOSH_UP to forward environments.
file=~/bin/msh_up
cat << EOF > $file
#!/usr/bin/env bash
if [ -z $MOSH_UP ]; then
    mosh --server=/export/home/cdanie40/anaconda3/envs/scratch/bin/mosh-server localhost;
    export MOSH_UP=UP
    echo MOSH_UP is $MOSH_UP
fi
EOF
chmod +x $file

# Emacs configuration
conda install -c conda-forge emacs
cd
rm -fr ~/.emacs.d
git clone https://github.com/prairie-guy/emacs_dotfile.git .emacs.d
cd .emacs.d
./setup.sh
cd

echo Homebrew NOT installed. Edit file if needed
exit

## Homebrew NOT installed. Edit file if needed
######################################################
## HomeBrew for linux
# Add Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

test -d ~/.linuxbrew && eval $(~/.linuxbrew/bin/brew shellenv)
test -d /home/linuxbrew/.linuxbrew && eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
test -r ~/.bash_profile && echo "eval \$($(brew --prefix)/bin/brew shellenv)" >>~/.bash_profile
echo "eval \$($(brew --prefix)/bin/brew shellenv)" >>~/.bash_profile
eval $(brew --prefix)/bin/brew shellenv

## Already installed by conda 
exit

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
######################################################
echo "Sucess: install-scratch-2.sh installed"
