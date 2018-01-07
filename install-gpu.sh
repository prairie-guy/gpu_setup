# CBD: Basic Default setup. See: sodium:~/sysadmin/silver/setup_gpu/install-gpu.sh
#
# Install a cuda, nvida gpu capable machine
# This script is designed to work with ubuntu 16.04 LTS

# Ensure system is updated and has basic build tools
sudo apt-get update
sudo apt-get --assume-yes upgrade
sudo apt-get --assume-yes install tmux build-essential gcc g++ make binutils emacs24-nox git zip software-properties-common

# Install Anaconda for current user
mkdir downloads
cd downloads
wget "https://repo.continuum.io/archive/Anaconda2-4.3.1-Linux-x86_64.sh" -O "Anaconda2-4.3.1-Linux-x86_64.sh"
bash "Anaconda2-4.3.1-Linux-x86_64.sh" -b
echo "export PATH=\"$HOME/anaconda2/bin:\$PATH\"" >> ~/.bashrc
export PATH="$HOME/anaconda2/bin:$PATH"
conda install -y bcolz
conda upgrade -y --all

# Set Up nvida and cuda
wget http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/cuda-repo-ubuntu1604_8.0.44-1_amd64.deb -O cuda-repo-ubuntu1604_8.0.44-1_amd64.deb
sudo dpkg -i cuda-repo-ubuntu1604_8.0.44-1_amd64.deb
sudo apt-get update
sudo apt-get -y install cuda
sudo apt-get update
sudo modprobe nvidia
nvidia-smi

# Install cudnn libraries
wget "http://files.fast.ai/files/cudnn.tgz" -O "cudnn.tgz"
tar -zxf cudnn.tgz
cd cuda
sudo cp lib64/* /usr/local/cuda-8.0/lib64/
sudo cp include/* /usr/local/cuda-8.0/include/
rm -fr cuda

# Install and configure theano
pip install theano
echo "[global]
device = gpu
floatX = float32

[cuda]
root = /usr/local/cuda" > ~/.theanorc

# Install and configure keras
pip install keras # Oringially: pip install keras==1.2.2 (LOOK AT THIS TO SEE IF ANYTHING BREAKS)
mkdir ~/.keras
echo '{
    "image_dim_ordering": "th",
    "epsilon": 1e-07,
    "floatx": "float32",
    "backend": "theano"
}' > ~/.keras/keras.json

# Clone the fast.ai course repo and prompt to start notebook
cd ~
git clone https://github.com/fastai/courses.git
echo "\"jupyter notebook\" will start Jupyter on port 8888"
echo "If you get an error instead, try restarting your session so your $PATH is updated"
ls

# Kaggle 
pip install kaggle-cli

# Set up dotfile
mkdir ~/.ssh
cp authorized_keys ~/.ssh/.
cp -r dot_files/* ~/.

# Set up emacs
git clone git@github.com:prairie-guy/emacs_dotfile.git .emacs.d    
cd .emacs.d
./setup.sh
cd ..

## Jupyter Setup
# Configure jupyter and prompt for password
jupyter notebook --generate-config
jupass=`python -c "from notebook.auth import passwd; print(passwd())"`
echo "c.NotebookApp.password = u'"$jupass"'" >> $HOME/.jupyter/jupyter_notebook_config.py
echo "c.NotebookApp.ip = '*'
c.NotebookApp.open_browser = False" >> $HOME/.jupyter/jupyter_notebook_config.py

# Add Jupyter Notebook Extensions, most importantly "Select CodeMirror Keymap" allows for emacs mode.
pip install jupyter_contrib_nbextensions
conda install -c conda-forge jupyter_contrib_nbextensions
jupyter contrib nbextension install --user


# Install and Configure Julia
# EDIT FOR MOST RECENT VERSION OF JULIA
JULIA_VERSION=julia-0.6.2-linux-x86_64.tar.gz

wget https://julialang-s3.julialang.org/bin/linux/x64/0.6/$JULIA_VERSION
mkdir tmp
tar xfv $JULIA_VERSION -C tmp
mv tmp/julia* julia
rm -fr tmp

# Allow Julia to work on jupyter
# If upgrading julia, install new version of julia and remove prior install of IJulia: rm -fr /home/cdaniels/.julia/v0.6/IJulia/
julia -e 'Pkg.update()'
julia -e 'Pkg.add("IJulia")'

# Export Julia to PATH
echo 'export PATH="/home/cdaniels/julia/bin:$PATH"'  >> ~/.bashrc

# Install Clojure for Juypter
git clone https://github.com/roryk/clojupyter
cd clojupyter
make
make install


