#!/usr/bin/env bash
# 05/03/2022

## Clean reinstall
## 1. install-server-mamba-1.sh
## 2. install-server-fastai-2.sh


### Install fastai stuff
mamba install -c fastchan fastai

## Mamba installs
mamba install scikit-learn
mamba install datasets transformers protobuf
mamba install kaggle tweepy emoji

# pip installs
pip install -U fastbook
pip install nbdev

## Jupyter Setup
mamba install jupyter notebook ipython

## Jupyter Extensions
mamba install -c conda-forge jupyter_contrib_nbextensions tmux
jupyter contrib nbextension install --user

# Julia
mamba install julia

# Set up Julia in Juypter
julia -e 'using Pkg; Pkg.add("IJulia")'
julia -e 'using Pkg; Pkg.build("IJulia")'

## Notebook configurations
## New .json "jupyter_notebook_config.json" is replacing the ".py"
## ".py" are still here but will need to be migrated
## As this is new, the details weren't well documented
## Password needs to be configured manually "jupyter notebook password"
jupyter notebook --generate-config
echo "c.NotebookApp.ip = '*'" >> ~/.jupyter/jupyter_notebook_config.py
echo "c.NotebookApp.open_browser = False" >> ~/.jupyter/jupyter_notebook_config.py
echo "c.NotebookApp.allow_remote_access = True" >> ~/.jupyter/jupyter_notebook_config.py

## Password needs to be set at the commandline
echo "done: 2. install-server-fastai-2.sh"
echo "done: 3. reinstall-jupyter.sh"
echo "next: 4. jupyter notebook password"
jupyter notebook password

