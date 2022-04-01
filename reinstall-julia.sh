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

# Clean Up
cd
rm -fr julia
# Keep old .julia pacakges for now
#rm -fr .julia


## Install Julia 
cd

## VERSION 1.4
# JULIA_VERSION='julia-1.4.1-linux-x86_64.tar.gz'
# JULIA_V='1.4'

## VERSION 1.6
# JULIA_VERSION='julia-1.6.0-linux-x86_64.tar.gz'
# JULIA_V='1.6'

## VERSION 1.7
# JULIA_VERSION='julia-1.7.0-linux-x86_64.tar.gz'
# JULIA_V='1.7'

## VERSION 1.7
JULIA_VERSION='julia-1.7.2-linux-x86_64.tar.gz'
JULIA_V='1.7'


# Download
wget https://julialang-s3.julialang.org/bin/linux/x64/$JULIA_V/$JULIA_VERSION
mkdir tmp
tar xfv $JULIA_VERSION -C tmp
mv tmp/julia* julia
rm -fr tmp
echo 'export PATH="/home/cdaniels/julia/bin:$PATH"'  >> ~/.bashrc
export PATH="/home/cdaniels/julia/bin:$PATH"
julia -e 'using Pkg; Pkg.add("IJulia")'
cd

