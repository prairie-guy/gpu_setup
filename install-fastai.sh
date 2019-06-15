#!/usr/bin/env bash

## 2nd Part of gpu_setup
## Install fastai library, course and conda requirements
## Make sure your have previously installed fastai env with:
## ``conda create -n fastai python=3.6``
## SHOULD BE IN FASTAI ENV BEFORE RUNNING SCRIPT!!!

if [ `env|grep CONDA_DEFAULT|grep fastai` ] ; 
	then echo env=fastai; 
	else echo conda is not env=fastai, exiting...; exit;
fi

cd
rm -fr fastai course-v3 ai_utilities

## Add fastai to PATH
cd
echo export PYTHONPATH=$PYTHONPATH:~/fastai >> ~/.bashrc
export PYTHONPATH=$PYTHONPATH:~/fastai

## Install fast.ai
# Install fast.ai (cuda90 module is tied to version of Linux version of cuda-repo-ubuntu1604_9.0.176-1_amd64.deb)
cd
git clone https://github.com/fastai/fastai.git
conda install -c pytorch -c fastai fastai pytorch torchvision cudatoolkit=10.0

## Optimize (Note pillow-simd is testing)
conda uninstall -y --force pillow libjpeg-turbo
conda install -c fastai/label/test pillow-simd

## Install course-v3
cd
git clone https://github.com/fastai/course-v3.git

## Jupyter Setup
conda install jupyter notebook
conda install -c conda-forge jupyter_contrib_nbextensions

## This was installed in gpu_install.sh
# jupyter notebook --generate-config
# jupass=`python -c "from notebook.auth import passwd; print(passwd())"`
# echo "c.NotebookApp.password = u'"$jupass"'" >> ~/.jupyter/jupyter_notebook_config.py
# echo "c.NotebookApp.ip = '*'" >> ~/.jupyter/jupyter_notebook_config.py
# echo "c.NotebookApp.open_browser = False" >> ~/.jupyter/jupyter_notebook_config.py
# echo "c.NotebookApp.allow_remote_access = True" >> ~/.jupyter/jupyter_notebook_config.py

## Kaggle
pip install kaggle

## Set up ai_utilities
cd
conda install selenium
git clone https://github.com/prairie-guy/ai_utilities.git
cd ai_utilities
tar xfvz geckodriver-v0.24.0-linux64.tar.gz
cp -f geckodriver ~/bin/
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
