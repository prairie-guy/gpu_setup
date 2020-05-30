#!/usr/bin/env bash

######################################################
#
# install-scratch-1.sh 
# install-scratch-2.sh should be installed next
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
# USE: 1) apt-get install git
#      2) git clone https://github.com/prairie-guy/gpu_setup.git
#      3) cd install_gpu
#      4) ./install-scratch-1.sh 
#
######################################################
# UPDATE WITH MOST RECENT VERSIONS OF SOFTWARE
#
## Julia
JULIA_VERSION='julia-1.4.1-linux-x86_64.tar.gz'
JULIA_V='1.4'
#
## Anaconda
ANACONDA_VERSION='Anaconda3-2020.02-Linux-x86_64.sh'
#
######################################################

# Clean up in case this is a reinstall
cd ~
rm -fr anaconda3 julia downloads data bin tmp scratch projects
rm -fr .emacs.d .ssh .julia .ipython .conda .cache .keras .keras .mozilla .torch .cache .linuxbrew
rm -fr ~/.local/share/jupyter
rm -fr ~/.local/bin/
rm -fr ~/.ipython/

# Install personal dotfiles for bash and ssh
mkdir .ssh
cp -f gpu_setup/authorized_keys .ssh/.
cp -f gpu_setup/dot_files/.bashrc .
cp -f gpu_setup/dot_files/.bash_profile .

# Set up Local file structure
cd
mkdir bin scratch downloads

## Install Julia
wget https://julialang-s3.julialang.org/bin/linux/x64/$JULIA_V/$JULIA_VERSION
mkdir tmp
tar xfv $JULIA_VERSION -C tmp
mv tmp/julia* julia
rm -fr tmp
echo 'export PATH="/home/cdaniels/julia/bin:$PATH"'  >> ~/.bashrc
export PATH="/home/cdaniels/julia/bin:$PATH"
julia -e 'using Pkg; Pkg.add("IJulia")'
cd
echo julia installed...

## Add Anaconda
cd ~
# sudo rm -fr ~/.cache # Hack. Not sure where this comes from, but it screws things up
cd ~/downloads/
wget https://repo.continuum.io/archive/$ANACONDA_VERSION
bash $ANACONDA_VERSION -b
cd
echo export PATH=~/anaconda3/bin:$PATH >> ~/.bashrc
export PATH=~/anaconda3/bin:$PATH

#source ~/.bashrc
#conda init bash

## Create conda env
conda create -n scratch python=3.7
conda init bash
echo conda activate scratch >> .bashrc

##
echo conda installed...
echo *** install-scratch-1.sh: complete ***
echo *** LOGOUT OF SHELL ***
echo *** LOGOUT OF SHELL ***
echo *** install-scratch-2.sh to complete setup. . .

exit


