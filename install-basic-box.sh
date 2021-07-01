#!/usr/bin/env bash
# 07/01/2021
#
######################################################
#
# CBD: basic-box Set Up
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
# USE:
#   1) apt-get install git openssh-server
#   2) mkdir .ssh; cd .ssh
#   3) ssh-keygen -t rsa -b 4096 -C cdaniels@nandor.net
#   4) In order to use ssh git@github, MUST do the following:
#       a) add id_rsa.pub to https://github.com/settings/keys
#       b) If NOT, search and replace 'git@github.com:' with 'https://github.com/' in script
#   5) git clone https://github.com/prairie-guy/gpu_setup.git |
#      git clone git@github.com:prairie-guy/gpu_setup.git
#   6) cd gpu_setup
#   7) ./install-basic-box.sh
#   8) Edit .bashrc file to remove unwanted stuff
#
######################################################
# UPDATE WITH MOST RECENT VERSIONS OF SOFTWARE
#
## Julia
JULIA_VERSION='julia-1.6.1-linux-x86_64.tar.gz'
JULIA_V='1.6'
#
## Clojure
CLOJURE_VERSION=linux-install-1.10.3.855.sh
#
## Anaconda
ANACONDA_VERSION='Anaconda3-2021.05-Linux-x86_64.sh'
#
######################################################


# Clean up in case this is a reinstall
cd ~
rm -fr anaconda3 julia downloads data bin tmp scratch projects junk
rm -fr .emacs.d .julia .ipython .conda .cache .keras .keras .mozilla .torch .cache .linuxbrew .bashrc .bash_profile
rm -fr ~/.local/share/jupyter
rm -fr ~/.local/bin/
rm -fr ~/.ipython/

# Install personal dotfiles for bash and ssh
cp -f gpu_setup/dot_files/.bashrc .
cp -f gpu_setup/dot_files/.bash_profile .

# Install key packages, including  openssh-server
sudo apt-get --assume-yes install openssh-server tmux build-essential gcc g++ make binutils git zip software-properties-common curl mosh ripgrep fd-find joe jpeginfo cmake libtool-bin xlcip libvterm-dev

# Set up Local file structure
cd
mkdir bin scratch junk

## Set up emacs
# emacs 26 is not part of Ubuntu 20.04, so need to add repository
sudo add-apt-repository ppa:kelleyk/emacs
sudo apt update
sudo apt install emacs26-nox
sudo apt install
export PATH="~/.emacs.d/bin:$PATH"
echo export PATH="~/.emacs.d/bin:$PATH" >> ~/.bashrc
cd
rm -fr ~/.emacs.d

## Add Doom Emacs
# Personal configuration
git clone git@github.com:prairie-guy/doom-emacs_dot_file.git .doom.d

# Download and setup doom emacs
git clone https://github.com/hlissner/doom-emacs ~/.emacs.d
~/.emacs.d/bin/doom install

## Install Julia 
wget https://julialang-s3.julialang.org/bin/linux/x64/$JULIA_V/$JULIA_VERSION
cd ~
mkdir tmp
tar xfv $JULIA_VERSION -C tmp
mv tmp/julia* julia
rm -fr tmp
echo 'export PATH="/home/cdaniels/julia/bin:$PATH"'  >> ~/.bashrc
export PATH="/home/cdaniels/julia/bin:$PATH"
julia -e 'using Pkg; Pkg.add("IJulia")'
cd

## Add Clojure
curl -O https://download.clojure.org/install/$CLOJURE_VERSION
chmod +x $CLOJURE_VERSION
sudo ./$CLOJURE_VERSION
rm -f $CLOJURE_VERSION

## Add Anaconda
cd ~
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

conda create -n scratch python=3.8
conda init bash
echo conda activate scratch >> .bashrc

echo Sever Installed.
echo *** LOGOUT OF SHELL ***
echo *** LOGOUT OF SHELL ***
echo *** Logout of shell for rest of of scratch install . . .
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
