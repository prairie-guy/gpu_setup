#!/usr/bin/env bash
# 05/03/2022


## Update Version to most recent

## Version 1.7
JULIA_VERSION='julia-1.7.2-linux-x86_64.tar.gz'
JULIA_V='1.7'

## Clean Up
cd
rm -fr julia
# Keep old .julia pacakges for now
#rm -fr .julia

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
cd

echo "done: reinstall-julia.sh "
