#!/usr/bin/env bash

## Install ludwig library, course and conda requirements
## Make sure your have previously installed ludwig env with:
## ``conda create -n fastai python=3.6``
## SHOULD BE IN FASTAI ENV BEFORE RUNNING SCRIPT!!!
## conda activate ludwig

if  env|grep CONDA_DEFAULT|grep ludwig  ; 
then echo env=ludwig; 
else echo conda is not env=fastai, exiting...; exit;
fi

# Install gmp on Ubuntu
sudo apt-get install libgmp3-dev

# Default ludwig install with pip
pip install ludwig

# Install tensorflow-gpu with conda
pip uninstall tensorflow
conda install tensorflow tensorflow-gpu cudatoolkit

## Jupyter Setup
conda install jupyter notebook
conda install -c conda-forge jupyter_contrib_nbextensions

## Kaggle
pip install kaggle

echo "Sucess: install-ludwig.sh complete"

# Example Usage:
# ludwig experiment \
#   --data_csv text_classification.csv \
#   --model_definition_file model_definition.yaml
# With model_definition.yaml:


# input_features:
#     -
#         name: text
#         type: text
#         level: word
#         encoder: parallel_cnn

# output_features:
#     -
#         name: class
#         type: category
