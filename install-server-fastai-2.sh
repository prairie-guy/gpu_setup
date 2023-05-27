#!/usr/bin/env bash
# 05/27/2023

## Clean reinstall
## 1. install-server-mamba-1.sh
## 2. install-server-fastai-2.sh
## 3. install-server-julia-3.sh

## Fastai stuff
mamba install -c fastchan fastai
pip install -U fastbook
pip install nbdev
mamba install scikit-learn kaggle

## HuggingFace
mamba install datasets transformers protobuf

## OpenAi
mamba install openai python-dotenv

## Misc
mamba install tweepy emoji

## Jupyter Setup
mamba install notebook ipython

## Jupyter Extensions
mamba install -c conda-forge jupyter_contrib_nbextensions tmux
jupyter contrib nbextension install --user

## Julia (Installed from source using install-server-julia.sh)
# mamba install julia
# ln -s /etc/ssl/certs/ca-certificates.crt $CONDA_PREFIX/share/julia/cert.pem # Hack for IJulia: linking cert.pem.
# julia -e 'using Pkg; Pkg.add("IJulia")'
# julia -e 'using Pkg; Pkg.build("IJulia")'

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
echo "next: 3. install-server-julia-3.sh"

jupyter notebook password
