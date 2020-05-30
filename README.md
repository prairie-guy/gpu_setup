## gpu_setup
#### Used to setup a complete 16.04 Ubuntu Server for the fast.ai course.
Includes fresh install of Ubuntu software, GPU video drivers, CUDA frameworks and Anaconda. Julia and a number of other programs are installed. This setup assumes that the user has root access.

- `install-gpu.sh` sets up a working server 
- `install-fastai.sh` sets up fastai workspace

Be sure to install in this order. Anaconda is loaded in `install-gpu.sh` and sets up the `fastai` conda env. Before using `install-fastai.sh`, be sure that `conda activate fastai` has been executed so as to be in the correct environment.



