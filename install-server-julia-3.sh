#!/usr/bin/env bash
# 05/27/2023

## Clean reinstall
## 1. install-server-mamba-1.sh
## 2. install-server-fastai-2.sh
## 3. install-server-julia-3.sh


## Update Version to most recent

## Version 1.9
JULIA_V='1.9'
JULIA_VERSION='julia-1.9.0-linux-x86_64.tar.gz'

## Clean Up
cd
rm -fr julia
rm -fr .julia

## Download and install Julia
cd
wget https://julialang-s3.julialang.org/bin/linux/x64/$JULIA_V/$JULIA_VERSION
mkdir tmp
tar xfv $JULIA_VERSION -C tmp
mv tmp/julia* julia
rm -fr tmp
echo 'export PATH="/home/cdaniels/julia/bin:$PATH"'  >> ~/.bashrc
export PATH="/home/cdaniels/julia/bin:$PATH"
julia -e 'using Pkg; Pkg.add("IJulia")'
julia -e 'using Pkg; Pkg.build("IJulia")'
cd

echo "done: 3. install-server-julia-3.sh"
