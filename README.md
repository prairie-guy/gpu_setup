## gpu_setup
#### Used to setup a complete 20.04 Ubuntu Server (originally for fastai)
Includes fresh install of Ubuntu software, GPU video drivers, CUDA frameworks and Anaconda. Julia and a number of other programs are installed. This 
setup assumes that the user has root access.

- `install-gpu.sh` sets up a working server
0. Do a fresh install of Ubuntu 
1. apt install git openssh-server
2. mkdir .ssh; 
3. ssh-keygen -t rsa -b 4096 -C cdaniels@nandor.net
4. In order to use ssh git@github, need to:
 a. add id_rsa.pub to https://github.com/settings/keys
 b. search and replace 'https://github.com/' with 'git@github.com:'
5. git clone https://github.com/prairie-guy/gpu_setup.git | git clone git@github.com:prairie-guy/gpu_setup.git
6. cd gpu_setup
7. ./install-basic-box.sh
8. Edit .bashrc file to remove unwanted stuff

- `install-fastai.sh` sets up fastai workspace

Be sure to install in this order. Anaconda is loaded in `install-gpu.sh` and sets up the `fastai` conda env. Before using `install-fastai.sh`, be sure that `conda activate fastai` has been executed so as to be in the correct environment.


## scratch_setup
#### Used to setup a client on a third-party server without root access
Includes installation of Anaconda, Juypter and Julia. A conda user environment is created. Homebrew for linux is also available for installation, but the script needs to be modified to allow it to proceed. (This is to avoid potential collision between conda and homebrew)

conda-forge is used to install emacs, tmux and mosh. emacs.d is then configured with a configuration by prairie-guy.

- `install-scratch-1.sh` sets up a Anaconda, Julia and creates the conda environment, `scratch`
- `install-scratch-2.sh` installs Jupyter and the remaining programs. Modify the script to allow homebrew to be installed.
- `msh_up` is a simple script to launch a mosh-server locally. This is a hack to allow emacs to work properly when using the excellent Blink app to access a server in which the UDP ports have not been opened up in the firewall.

Be sure to install in this order. Anaconda is loaded in `install-scratch-1.sh` and sets up the `scratch` conda env. Before using `install-scratch-2.sh`, be sure that `conda activate fastai` has been executed so as to be in the correct environment.

## install-server-mamba-1.sh and install-server-fastai-2.sh
Two scripts to set up a fully capable machine learning server. Uses cases would be setting up servers on `AWS`, `Codespaces` or `Paperspaces`.

1. `install-server-mamba-1.sh` sets up a user based mamba environment. This can be done as follows:
  - wget https://raw.githubusercontent.com/prairie-guy/gpu_setup/master/install-server-mamba-1.sh 
  - chmod +x install-server-mamba-1.sh
  - ./install-server-mamba-1.sh
2. Exit shell (ctr-d)
3. `install-server-fastai-2.sh` sets up `fastai`, `Transformers` ipython, jupyter, julia and many other machine learning packages.
  - wget https://raw.githubusercontent.com/prairie-guy/gpu_setup/master/install-server-fastai-2.sh
  - chmod +x install-server-fastai-2.sh
  - ./install-server-fastai-2.sh
