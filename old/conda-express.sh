#!/usr/bin/env bash

## Make sure your have previously installed fastai env with:
## ``conda create -n fastai python=3.6``
## SHOULD BE IN FASTAI ENV BEFORE RUNNING SCRIPT!!!


### Lighter Install of install-fastai.sh. Quicker

## Early Installs - To avoid problems with Pillow
conda install -c hellock icrawler
pip install python-magic

# Quick and Dirty fastai express install. NOT a replacment for: install-fastai.sh 
cd
conda install -c pytorch -c fastai fastai

## Optimize (libjpeg-turbo and pillow-simd will be installed)
## NOTE libtiff will not be reinstalled
conda uninstall --force jpeg libtiff -y
conda install -c conda-forge libjpeg-turbo
CC="cc -mavx2" pip install --no-cache-dir -U --force-reinstall --no-binary :all: --compile pillow-simd

conda uninstall -y --force pillow libjpeg-turbo
conda install -c fastai/label/test pillow-simd

## Jupyter Setup
conda install jupyter notebook

## Commented out for debugging
# conda install -c conda-forge jupyter_contrib_nbextensions

## Late Installs
conda install scikit-learn 
conda install ipython

## This was installed in gpu_install.sh
jupyter notebook --generate-config
jupass=`python -c "from notebook.auth import passwd; print(passwd())"`
echo "c.NotebookApp.password = u'"$jupass"'" >> ~/.jupyter/jupyter_notebook_config.py
echo "c.NotebookApp.ip = '*'" >> ~/.jupyter/jupyter_notebook_config.py
echo "c.NotebookApp.open_browser = False" >> ~/.jupyter/jupyter_notebook_config.py
echo "c.NotebookApp.allow_remote_access = True" >> ~/.jupyter/jupyter_notebook_config.py

## Kaggle
pip install kaggle

## Check Status of Optimizations
python -c "import fastai.utils; fastai.utils.check_perf()"
python -c "from PIL import Image; print(Image.PILLOW_VERSION)"
python -c "from PIL import features; print(features.check_feature('libjpeg_turbo'))"

#conda install -c conda-forge jupyter_contrib_nbextensions
python -c 'import fastai.utils; fastai.utils.show_install(1)'

## Might as well install R
# conda install -c r r-essentials

echo "Sucess: fastai_setup.sh installed"
