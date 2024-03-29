#/usr/bin/env bash
# 05/03/2022

## Clean reinstall
## 1. reinstall-anaconda.sh
## 2. reinstall-fastai.sh
## 3. reinstall-jupyter.sh

## 1. conplete: reinstall-anaconda.sh
## 2. compplet: reinstall-fastai.sh
## 3. next    : reinstall-jupyter.sh
##
## Only execute 'reinstall-fastai.sh' from conda env 'fastai'

## Clean up needed?
read -r -p "Clean up jupyter environment? If you just ran 'reinstall-fastai.sh' enter: 'n' [Y/n] " input
case $input in
      [yY][eE][sS]|[yY])
          mamba remove jupyter notebook ipython
          mamba remove -c conda-forge jupyter_contrib_nbextensions
          rm -fr ~/.jupyter/
          rm -fr ~/.local/share/jupyter
          rm -fr ~/.local/bin/
          rm -fr ~/.ipython/
          ;;
esac

## Jupyter Setup
mamba install jupyter notebook ipython

## Jupyter Extensions
mamba install -c conda-forge jupyter_contrib_nbextensions tmux
jupyter contrib nbextension install --user

# Set up Julia in Juypter
julia -e 'using Pkg; Pkg.add("IJulia")'
julia -e 'using Pkg; Pkg.build("IJulia")'

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
echo "done: 3. reinstall-jupyter.sh"
echo "next: 4. jupyter notebook password"
jupyter notebook password

# Fix/Add WebIO
#julia -e 'using Pkg; Pkg.build("WebIO")'
#julia -e 'using WebIO, IJulia; WebIO.install_jupyter_nbextension()'
