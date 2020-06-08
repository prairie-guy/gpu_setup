## MAKE SURE IN fastai environment

## Clean up
conda remove jupyter notebook ipython
conda remove -c conda-forge jupyter_contrib_nbextensions
rm -fr ~/.jupyter/
julia -e 'using Pkg; Pkg.rm("IJulia")'
rm -fr ~/.local/share/jupyter
rm -fr ~/.local/bin/
rm -fr ~/.ipython/


## Jupyter Setup
conda install jupyter notebook ipython
#conda install -c conda-forge jupyter_contrib_nbextensions
julia -e 'using Pkg; Pkg.add("IJulia")'
julia -e 'using Pkg; Pkg.build("IJulia")'

## Reinstall Notebook
jupyter notebook --generate-config
jupass=`python -c "from notebook.auth import passwd; print(passwd())"`
echo "c.NotebookApp.password = u'"$jupass"'" >> ~/.jupyter/jupyter_notebook_config.py
echo "c.NotebookApp.ip = '*'" >> ~/.jupyter/jupyter_notebook_config.py
echo "c.NotebookApp.open_browser = False" >> ~/.jupyter/jupyter_notebook_config.py
echo "c.NotebookApp.allow_remote_access = True" >> ~/.jupyter/jupyter_notebook_config.py

# Fix/Add WebIO
julia -e 'using Pkg; Pkg.build("WebIO")'
julia -e 'using WebIO, IJulia; WebIO.install_jupyter_nbextension()'

echo "Done"
