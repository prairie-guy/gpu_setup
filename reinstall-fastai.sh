#!/usr/bin/env bash
# 05/03/2022

## Clean reinstall
## 1. reinstall-anaconda.sh
## 2. reinstall-fastai.sh
## 3. reinstall-jupyter.sh

## Only execute 'reinstall-fastai.sh' from conda env 'fastai'
## 1. completed: 1. reinstall-anaconda.sh (creates conda env 'fastai')
## 2. next     : 2. reinstall-fastai.sh
## OR
## 0. conda info --envs # list all envs
## 1. conda activate base
## 2. conda remove --name fastai --all
## 3. conda create -n fastai python=3.9
## 4. conda init bash
## 5. conda activate fastai
## 6. reinstall-fastai.sh

### Install fastai stuff
mamba install -c fastchan fastai

## Mamba installs
mamba install torchaudio -c pytorch
mamba install scikit-learn
mamba install datasets transformers
mamba install kaggle

# pip installs
pip install -U fastbook
pip install nbdev

## Faster image processing
## `libjpeg-turbo` (2-6x) and `Pillow-SIMD ` (4-6)
## No TIFF support; if required (https://docs.fast.ai/dev/performance.html#faster-image-processing)
## Uncomment to include
# conda uninstall -y --force pillow pil jpeg libtiff libjpeg-turbo
# pip   uninstall -y  pillow pil jpeg libtiff libjpeg-turbo
# conda install -yc conda-forge libjpeg-turbo
# CFLAGS="${CFLAGS} -mavx2" pip -v install --upgrade --no-cache-dir --force-reinstall --no-binary :all: --compile pillow-simd
# conda install -y jpeg libtiff


## To add jupyter:
## run reinstall-jupyter.sh

echo "done: 2. reinstall-fastai.sh"
echo "next: 3. reinstall-jupyter.sh"
