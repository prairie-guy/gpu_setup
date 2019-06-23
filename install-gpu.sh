#!/usr/bin/env bash

# CBD: Basic Default setup. See: sodium:~/sysadmin/silver/setup_gpu/install-gpu.sh
# See: Modified from http://files.fast.ai/setup/paperspace
#
# Install a cuda, nvida gpu capable machine for use with fast.ai
# Install a generally useful environment
# This script is designed to work with ubuntu 16.04 LTS

# USE: 1) apt-get install git
#      2) git clone https://github.com/prairie-guy/gpu_setup.git
#      3) cd gpu_setup
#      4) ./install-gpu.sh

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
sudo apt-get --assume-yes install openssh-server tmux build-essential gcc g++ make binutils git zip software-properties-common curl mosh

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
# emacs 25 is not part of Ubuntu 16.04, so need to add repository
# edit .emacs.d/init.el to uncomment ess to speed up emacs if clojure or julia are not needed
sudo add-apt-repository ppa:kelleyk/emacs
sudo apt update
sudo apt install emacs25-nox
cd
rm -fr ~/.emacs.d
git clone https://github.com/prairie-guy/emacs_dotfile.git .emacs.d
cd .emacs.d
./setup.sh
cd

# Add other personal apt packages
sudo apt-get install joe jpeginfo

## Install Julia 
JULIA_VERSION='julia-1.1.1-linux-x86_64.tar.gz'
cd ~
wget https://julialang-s3.julialang.org/bin/linux/x64/1.1/$JULIA_VERSION
mkdir tmp
tar xfv $JULIA_VERSION -C tmp
mv tmp/julia* julia
rm -fr tmp
echo 'export PATH="/home/cdaniels/julia/bin:$PATH"'  >> ~/.bashrc
export PATH="/home/cdaniels/julia/bin:$PATH"
julia -e 'Pkg.update()'
julia -e 'Pkg.add("IJulia")'
cd

## Add Clojure
CLOJURE_VERSION=linux-install-1.10.0.442.sh
curl -O https://download.clojure.org/install/$CLOJURE_VERSION
chmod +x $CLOJURE_VERSION
sudo ./$CLOJURE_VERSION
rm -f $CLOJURE_VERSION

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
