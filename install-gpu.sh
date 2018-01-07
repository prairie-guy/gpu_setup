# CBD: Basic Default setup. See: sodium:~/sysadmin/silver/setup_gpu/install-gpu.sh
# See: Modified from http://files.fast.ai/setup/paperspace
#
# Install a cuda, nvida gpu capable machine for use with fast.ai
# Install a generally useful environment
# This script is designed to work with ubuntu 16.04 LTS

# USE: git clone https://github.com/prairie-guy/gpu_setup.git
#     ./gpu_setup.sh

set -e
set -o xtrace
DEBIAN_FRONTEND=noninteractive

# Ensure system is updated and has basic build tools
sudo apt-get update
sudo apt install unzip -y
sudo apt -y upgrade --force-yes -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold"
sudo apt -y install --force-yes -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" qtdeclarative5-dev qml-module-qtquick-controls
sudo add-apt-repository ppa:graphics-drivers/ppa -y
sudo apt update
sudo apt-get --assume-yes upgrade
sudo apt -y autoremove

# Install openssh-server
sudo apt-get --assume-yes install openssh-server

# Add some key packages
sudo apt-get --assume-yes install tmux build-essential gcc g++ make binutils emacs24-nox git zip software-properties-common

# Create local download dir
mkdir downloads

# Install cuda and cudnn
cd ~/downloads/
wget http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/cuda-repo-ubuntu1604_9.0.176-1_amd64.deb
sudo dpkg -i cuda-repo-ubuntu1604_9.0.176-1_amd64.deb
sudo apt-key adv --fetch-keys http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/7fa2af80.pub
sudo apt update
sudo apt install cuda -y

wget http://files.fast.ai/files/cudnn-9.1-linux-x64-v7.tgz
tar xf cudnn-9.1-linux-x64-v7.tgz
sudo cp cuda/include/*.* /usr/local/cuda/include/
sudo cp cuda/lib64/*.* /usr/local/cuda/lib64/

sudo modprobe nvidia
nvidia-smi
cd

# Inatall Anaconda
cd ~/downloads/
wget https://repo.continuum.io/archive/Anaconda3-5.0.1-Linux-x86_64.sh
bash Anaconda3-5.0.1-Linux-x86_64.sh -b
echo 'export PATH=~/anaconda3/bin:$PATH' >> ~/.bashrc
export PATH=~/anaconda3/bin:$PATH
conda upgrade -y --all
cd

# Clone the fast.ai course repo
# Importantly, this creates a default conda environment by 'source activate fasti' which is added to .bashrc
# !!! USE conda vs. pip for package management !!!
git clone https://github.com/fastai/fastai.git
cd fastai/
conda env update
echo 'source activate fastai' >> ~/.bashrc
source activate fastai
source ~/.bashrc
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
pip install jupyter_contrib_nbextensions
conda install -c conda-forge jupyter_contrib_nbextensions
jupyter contrib nbextension install --user

# Install and Configure Julia
# EDIT FOR MOST RECENT VERSION OF JULIA
JULIA_VERSION=julia-0.6.2-linux-x86_64.tar.gz
cd ~/downloads/
wget https://julialang-s3.julialang.org/bin/linux/x64/0.6/$JULIA_VERSION
tar xfv $JULIA_VERSION
rm $JULIA_VERSION
mv julia* ~/.
echo 'export PATH="/home/cdaniels/julia/bin:$PATH"'  >> ~/.bashrc
cd

# Allow Julia to work on jupyter
# If upgrading julia, install new version of julia and remove prior install of IJulia: rm -fr /home/cdaniels/.julia/v0.6/IJulia/
julia -e 'Pkg.update()'
julia -e 'Pkg.add("IJulia")'

# Install Clojure for Juypter
git clone https://github.com/roryk/clojupyter
cd clojupyter
make
make install
cd

# Set up dotfile
mkdir ~/.ssh
cp authorized_keys ~/.ssh/.
cp -r dot_files/* ~/.

# Set up emacs
git clone git@github.com:prairie-guy/emacs_dotfile.git .emacs.d    
cd .emacs.d
./setup.sh
cd

# Kaggle 
pip install kaggle-cli

# Add specific fast.ai course files
cd
mkdir data
cd data
wget http://files.fast.ai/data/dogscats.zip
unzip -q dogscats.zip
cd ../fastai/courses/dl1/
ln -s ~/data ./
cd
