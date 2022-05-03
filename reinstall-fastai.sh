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
## 5. reinstall-fastai.sh

### Install fastai stuff
conda install -c fastchan fastai anaconda
pip install -U fastbook

## Late Installs
conda install scikit-learn

## Kaggle
pip install kaggle

## To add jupyter:
## run reinstall-jupyter.sh

echo "done: 2. reinstall-fastai.sh"
echo "next: 3. reinstall-jupyter.sh"
