# Install and run pycles

## Instructions for conda on euler at ETHZ (Dana Grund, 2024-07)
The euler OS got updated form CentOS to Ubuntu in 2024/07, 
requiring module updates that are incorporated here.
Conda is not recommended by the cluster support, so try to use modules and pip.

```bash
git clone git@github.com:dana-grund/pycles.git -b py3-euler
cd pycles

module load stack/2024-04 # includes gcc/8.5.0 
module load openmpi/4.1.6
module load python/3.9.18
module load hdf5/1.14.3
module load netcdf-c/4.9.2

VENV_ACT=.venv/pycles/bin/activate
python -m venv --system-site-packages $VENV_DIR
source $VENV_ACT
pip install --upgrade pip
pip install -r requirements_euler_ubuntu_pip.txt 
pip freeze > environment_euler_ubuntu_pip.txt 

python setup.py build_ext --inplace
python generate_namelist.py StableBubble
python main.py StableBubble.in
```

As an alternative, the cluster support suggests to use [Singularity containers](https://scicomp.ethz.ch/wiki/Singularity)
that should not break down when the OS and modules are updated, in contrast to 
both conda and modules+pip.


## Collected observations when compiling on the new OS Ubuntu (Dana Grund, 2024-07)
There was an update of cython from 0.29.xx to 3.xx. Using cython3 lead to this error,
hence pinning the previous cython==0.29.33 in the requirements:
```bash
Forcing.pyx:1924:61: Cannot assign type 'double (*)(double, double) except * nogil' 
to 'double (*)(double, double) noexcept'. Exception values are incompatible. 
Suggest adding 'noexcept' to the type of 'L_fp'.
```
There was an update of openmpi to openmpi/5.x, leading to the error, which is avoided 
by using the older env module:
```bash
shmem: mmap: an error occurred while determining whether or not 
/scratch/tmp.854464.dgrund/ompi.eu-g1-039-2.533325/jf.0/118620160/shared_mem_cuda_pool.eu-g1-039-2 
could be created.
```
Newer python/3.11.6 and gcc/12.0 leads to an error, reported but not fixed also 
[here](https://github.com/pressel/pycles/issues/42),
hence using the oldest available environment modules. 
Following the issue [here](https://github.com/pyccel/pyccel/issues/933), 
it was tried to avoid the error with newer python and gcc versions by adding the 
flag -lm to both the gcc (mpicc) and gfortran compilers, with no success:
```bash
import time
ImportError: /cluster/work/climate/dgrund/git/pressel/pycles/Radiation.cpython-311-x86_64-linux-gnu.so: undefined symbol: _ZGVbN2v_exp
```


## Instructions for conda on ch4 at IAC-ETHZ (Stefan Ruedisuehli, 2023-01)

```bash
git clone git@github.com:ruestefa/pycles.git -b py3-conda
cd pycles
mamba env create -f environment.yml  # or requirements.yml
conda activate pycles
python generate_parameters.py
python setup.py build_ext --inplace
python generate_namelist.py StableBubble
python main.py StableBubble.in
```
