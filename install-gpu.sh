#!/usr/bin/env bash

# CBD: Basic Default setup. See: sodium:~/sysadmin/silver/setup_gpu/install-gpu.sh
# See: Modified from http://files.fast.ai/setup/paperspace
#
# Install a cuda, nvida gpu capable machine for use with fast.ai
# Install a generally useful environment
# This script is designed to work with ubuntu 16.04 LTS

# USE: 1) apt-get install git
#      2) git clone https://github.com/prairie-guy/gpu_setup.git
#      3) cd gpu_setup
#      4) ./install-gpu.sh

# Install
set -e
set -o xtrace
DEBIAN_FRONTEND=noninteractive

# Install personal dotfiles for bash and ssh
cd 
rm -fr anaconda3 google-cloud-sdk julia fastai ai_utilities downloads data bin tmp scratch projects
rm -fr .emacs.d .ssh .julia .ipython .conda .cache .keras .keras .mozilla .torch .cache
mkdir .ssh
cp -f gpu_setup/authorized_keys .ssh/.
cp -f gpu_setup/dot_files/.bashrc .
cp -f gpu_setup/dot_files/.bash_profile .
cd

# Ensure system is updated and has basic build tools
sudo rm -f /etc/apt/apt.conf.d/*.*
sudo apt-get update
sudo apt install unzip -y
sudo apt -y upgrade --force-yes -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold"
sudo apt -y install --force-yes -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" qtdeclarative5-dev qml-module-qtquick-controls
sudo add-apt-repository ppa:graphics-drivers/ppa -y
sudo apt update
sudo apt-get --assume-yes upgrade
sudo apt -y autoremove

# Install key packages openssh-server
sudo apt-get --assume-yes install openssh-server tmux build-essential gcc g++ make binutils git zip software-properties-common curl

cd
mkdir ~/downloads
# Install cuda and cudnn
cd ~/downloads/
wget http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/cuda-repo-ubuntu1604_9.0.176-1_amd64.deb
sudo dpkg -i cuda-repo-ubuntu1604_9.0.176-1_amd64.deb
sudo apt-key adv --fetch-keys http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/7fa2af80.pub
sudo apt update
sudo apt install cuda -y
wget http://files.fast.ai/files/cudnn-9.1-linux-x64-v7.tgz
tar xf cudnn-9.1-linux-x64-v7.tgz
sudo cp -f cuda/include/*.* /usr/local/cuda/include/
sudo cp -f cuda/lib64/*.* /usr/local/cuda/lib64/

# Install Anaconda and fastai
sudo rm -fr ~/.cache # Hack. Not sure where this comes from, but it screws things up
cd ~/downloads/
wget https://repo.continuum.io/archive/Anaconda3-5.0.1-Linux-x86_64.sh
bash Anaconda3-5.0.1-Linux-x86_64.sh -b
cd
git clone https://github.com/fastai/fastai.git
cd fastai/
echo 'export PATH=~/anaconda3/bin:$PATH' >> ~/.bashrc
export PATH=~/anaconda3/bin:$PATH
source ~/.bashrc
conda env update
echo 'source activate fastai' >> ~/.bashrc
source activate fastai
source ~/.bashrc
cd ..

# Add specific fast.ai course files
cd
mkdir data
cd data
wget http://files.fast.ai/data/dogscats.zip
unzip -q dogscats.zip
cd ../fastai/courses/dl1/
ln -s ~/data ./
cd

# Tweaks for fast.ai
echo 'export PYTHONPATH=$PYTHONPATH:~/fastai' >> ~/.bashrc
export PYTHONPATH=$PYTHONPATH:~/fastai
echo 'alias fastai-start="source deactivate; source activate fastai"' >> ~/.bashrc
echo alias fastai-stop=source deactivate >> ~/.bashrc

# Set up Local file structure
cd
mkdir bin scratch projects 
cd projects
ln -s ~/data/ .
ln -s ~/fastai/courses/dl1/images/ .

# Install Julia and setup to work with Juypter
# EDIT FOR MOST RECENT VERSION OF JULIA
JULIA_VERSION=julia-0.6.2-linux-x86_64.tar.gz
cd
wget https://julialang-s3.julialang.org/bin/linux/x64/0.6/$JULIA_VERSION
mkdir tmp
tar xfv $JULIA_VERSION -C tmp
mv tmp/julia* julia
rm -fr tmp
echo 'export PATH="/home/cdaniels/julia/bin:$PATH"'  >> ~/.bashrc
export PATH="/home/cdaniels/julia/bin:$PATH"
julia -e 'Pkg.update()'
julia -e 'Pkg.add("IJulia")'
cd

# Set up emacs
# emacs 25 is not part of Ubuntu 16.04, so need to add repository
# edit .emacs.d/init.el to uncomment ess to speed up emacs if clojure or julia are not needed
sudo add-apt-repository ppa:kelleyk/emacs
sudo apt update
sudo apt install emacs25-nox
cd
rm -fr ~/.emacs.d
git clone https://github.com/prairie-guy/emacs_dotfile.git .emacs.d
cd .emacs.d
./setup.sh
cd

# Add favorite pip packages
# Great for functional program style
# I like: import funcy as fn
pip install funcy

# Set up google-cloud-sdk
cd
curl https://sdk.cloud.google.com | bash
echo 'export GOOGLE_APPLICATION_CREDENTIALS=/home/cdaniels/google-cloud-sdk/cbd_auth.json'
touch ~/google-cloud-sdk/cbd_auth.json
echo 'NEED TO ADD JSON AUTHENTICATION TO THIS FILE'
cd

# Set up default CUDA gpus
echo '# Set up default CUDA gpus. Here we assume that gpu=0 is reserved for the display' >> ~/.bashrc
echo 'export CUDA_DEVICE_ORDER=PCI_BUS_ID' >> ~/.bashrc
echo 'export CUDA_VISIBLE_DEVICES=1,2' >> ~/.bashrc
echo 'nvidia-smi -pm ENABLED &> /dev/null' >> ~/.bashrc
echo 'nvidia-smi -ac 850,1912 &> /dev/null' >> ~/.bashrc
echo 'CUDA_VISIBLE_DEVICES=1,2'
echo 'CUDA 0 is being reserved for the display'
echo 'EDIT ~/.bashrc if this needs changing'

# Install Tensorflow and Keras
conda install tensorflow-gpu
conda install keras

# Kaggle
pip install kaggle

# Set up ai_utilities
cd
git clone https://github.com/prairie-guy/ai_utilities.git
cd ai_utilities
tar xfvz geckodriver-v0.19.1-linux64.tar.gz
cp -f geckodriver ~/bin/
pip install selenium
cd

## Jupyter Setup
jupyter notebook --generate-config
jupass=`python -c "from notebook.auth import passwd; print(passwd())"`
echo "c.NotebookApp.password = u'"$jupass"'" >> ~/.jupyter/jupyter_notebook_config.py
echo "c.NotebookApp.ip = '*'" >> ~/.jupyter/jupyter_notebook_config.py
echo "c.NotebookApp.open_browser = False" >> ~/.jupyter/jupyter_notebook_config.py

# Add Jupyter Notebook Extensions, most importantly "Select CodeMirror Keymap" allows for emacs mode.
pip install ipywidgets
jupyter nbextension enable --py widgetsnbextension --sys-prefix

echo "install-gpu.sh: complete"
