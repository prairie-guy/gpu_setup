#!/usr/bin/env bash

# CBD: Basic Default setup. See: sodium:~/sysadmin/silver/setup_gpu/install-gpu.sh
# See: Modified from http://files.fast.ai/setup/paperspace
#
# Install a cuda, nvida gpu capable machine for use with fast.ai
# Install a generally useful environment
# This script is designed to work with ubuntu 20.04 LTS
#
# USE:
# 1) apt-get install git openssh-server
# 2) cd .ssh
# 3) ssh-keygen -t rsa -b 4096 -C cdaniels@nandor.net
# 4) In order to use ssh git@github, need to:
#   a) add id_rsa.pub to https://github.com/settings/keys
#   b) Search and replace 'https://github.com/' with 'git@github.com:'
# 5) git clone https://github.com/prairie-guy/gpu_setup.git
# 6) cd gpu_setup
# 7) ./install-gpu.sh

# Install
set -e
set -o xtrace
DEBIAN_FRONTEND=noninteractive

# Install personal dotfiles for bash and ssh
cd
rm -fr anaconda3 google-cloud-sdk julia fastai ai_utilities downloads data bin tmp scratch projects
rm -fr .emacs.d .ssh .julia .ipython .conda .cache .keras .keras .mozilla .torch .cache
mkdir .ssh
cp -f gpu_setup/authorized_keys .ssh/.
cp -f gpu_setup/dot_files/.bashrc .
cp -f gpu_setup/dot_files/.bash_profile .
cd

# Update basic build tools
sudo rm -f /etc/apt/apt.conf.d/*.*
sudo apt-get update
sudo apt install unzip -y
sudo apt -y upgrade --force-yes -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold"
sudo apt -y install --force-yes -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::=--force-confold qtdeclarative5-dev qml-module-qtquick-controls
sudo add-apt-repository ppa:graphics-drivers/ppa -y
sudo apt update
sudo apt-get --assume-yes upgrade
sudo apt -y autoremove

# Install key packages, including  openssh-server
sudo apt-get --assume-yes install openssh-server tmux build-essential gcc g++ make binutils git zip software-properties-common curl mosh ripgrep fd-find joe jpeginfo

# Set up Local file structure
cd
mkdir bin scratch downloads

# Install cuda and cudnn
cd ~/downloads/
wget http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/cuda-repo-ubuntu1604_9.0.176-1_amd64.deb
sudo dpkg -i cuda-repo-ubuntu1604_9.0.176-1_amd64.deb
sudo apt-key adv --fetch-keys http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/7fa2af80.pub
sudo apt update
sudo apt install cuda -y
## cudnn is now loaded with conda cudatookkit=10.0
## cudnn at system level is probably not needed.
## If so, do the following;
# wget http://files.fast.ai/files/cudnn-9.1-linux-x64-v7.tgz
# tar xf cudnn-9.1-linux-x64-v7.tgz
# sudo cp -f cuda/include/*.* /usr/local/cuda/include/
# sudo cp -f cuda/lib64/*.* /usr/local/cuda/lib64/

# Set up default CUDA gpus
echo '# Set up default CUDA gpus. Here we assume that gpu=0 is reserved for the display' >> ~/.bashrc
echo 'export CUDA_DEVICE_ORDER=PCI_BUS_ID' >> ~/.bashrc
echo 'export CUDA_VISIBLE_DEVICES=1,2' >> ~/.bashrc
echo 'nvidia-smi -pm ENABLED &> /dev/null' >> ~/.bashrc
echo 'nvidia-smi -ac 850,1912 &> /dev/null' >> ~/.bashrc
echo 'CUDA_VISIBLE_DEVICES=1,2'
echo 'CUDA 0 is being reserved for the display'
echo 'EDIT ~/.bashrc if this needs changing'

# Set up emacs
# emacs 26 is not part of Ubuntu 20.04, so need to add repository
sudo add-apt-repository ppa:kelleyk/emacs
sudo apt update
sudo apt install emacs26-nox
sudo apt install
export PATH="~/.emacs.d/bin:$PATH"
echo export PATH="~/.emacs.d/bin:$PATH" >> ~/.bashrc
cd
rm -fr ~/.emacs.d

# Install Doom Emacs
# Personal configuration
git clone https://github.com/prairie-guy/doom-emacs_dot_file.git .doom.d

# Download and setup doom emacs
git clone https://github.com/hlissner/doom-emacs ~/.emacs.d
~/.emacs.d/bin/doom install

## Install Julia 
JULIA_VERSION='julia-1.6.1-linux-x86_64.tar.gz'
JULIA_V='1.6'
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
CLOJURE_VERSION=linux-install-1.10.3.855.sh
curl -O https://download.clojure.org/install/$CLOJURE_VERSION
chmod +x $CLOJURE_VERSION
sudo ./$CLOJURE_VERSION
rm -f $CLOJURE_VERSION

## Add Anaconda
cd ~
ANACONDA_VERSION='Anaconda3-2021.05-Linux-x86_64.sh'
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
# NOTE: CHANGED TO pythone=3.7 (MAY NOT WORK WITH FASTAI CODE)
#conda create -n fastai python=3.6
conda create -n scratch python=3.7
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
