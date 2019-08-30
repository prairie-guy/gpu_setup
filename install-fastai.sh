#!/usr/bin/env bash

## 2nd Part of gpu_setup
## Install fastai library, course and conda requirements
## To delete previous fastai, use:
## `conda remove --name fastai --all`
## Make sure your have previously installed fastai env with:
## `conda create -n fastai python=3.6`
## SHOULD BE IN FASTAI ENV BEFORE RUNNING SCRIPT!!!

if  env|grep CONDA_DEFAULT|grep fastai  ; 
then echo env=fastai; 
else echo conda is not env=fastai, exiting...; exit;
fi

cd
rm -fr fastai course-v3 ai_utilities

## Add fastai to PATH
cd
echo export PYTHONPATH=$PYTHONPATH:~/fastai >> ~/.bashrc
export PYTHONPATH=$PYTHONPATH:~/fastai

## Early Installs - To avoid problems with Pillow
conda install -c hellock icrawler
pip install python-magic

## Install fast.ai
# Install fast.ai cuda90 module is tied to version of Linux version of cuda-repo-ubuntu1604_9.0.176-1_amd64.deb
cd
git clone https://github.com/fastai/fastai.git
conda install -c pytorch -c fastai fastai

## Optimize (libjpeg-turbo and pillow-simd will be installed)
## NOTE libtiff will not be reinstalled
conda uninstall --force jpeg libtiff -y
conda install -c conda-forge libjpeg-turbo
CC="cc -mavx2" pip install --no-cache-dir -U --force-reinstall --no-binary :all: --compile pillow-simd

conda uninstall -y --force pillow libjpeg-turbo
conda install -c fastai/label/test pillow-simd

## Late Installs
conda install scikit-learn 
conda install ipython

## Install course-v3
cd
git clone https://github.com/fastai/course-v3.git

## Jupyter Setup
conda install jupyter notebook
conda install -c conda-forge jupyter_contrib_nbextensions

## This was installed in gpu_install.sh and is not necesarily needed
jupyter notebook --generate-config
jupass=`python -c "from notebook.auth import passwd; print(passwd())"`
echo "c.NotebookApp.password = u'"$jupass"'" >> ~/.jupyter/jupyter_notebook_config.py
echo "c.NotebookApp.ip = '*'" >> ~/.jupyter/jupyter_notebook_config.py
echo "c.NotebookApp.open_browser = False" >> ~/.jupyter/jupyter_notebook_config.py
echo "c.NotebookApp.allow_remote_access = True" >> ~/.jupyter/jupyter_notebook_config.py

## Kaggle
pip install kaggle

## Set up ai_utilities
cd
git clone https://github.com/prairie-guy/ai_utilities.git
cd ai_utilities
cd

## Check Status of Optimizations
python -c "import fastai.utils; fastai.utils.check_perf()"
python -c "from PIL import Image; print(Image.PILLOW_VERSION)"
python -c "from PIL import features; print(features.check_feature('libjpeg_turbo'))"

#conda install -c conda-forge jupyter_contrib_nbextensions
python -c 'import fastai.utils; fastai.utils.show_install(1)'

## Might as well install R
conda install -c r r-essentials

echo "Sucess: fastai_setup.sh installed"
