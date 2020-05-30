## gpu_setup
#### Used to setup a complete 16.04 Ubuntu Server for the fast.ai course.
Includes fresh install of Ubuntu software, GPU video drivers, CUDA frameworks and Anaconda. Julia and a number of other programs are installed. This setup assumes that the user has root access.

- `install-gpu.sh` sets up a working server 
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


