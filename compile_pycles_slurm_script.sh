#!/bin/bash

## run as > sbatch compile.sh
## always compiles from scratch!

## requires the PYCLES_PATH.txt stored in this directory
## containing where to find pycles, e.g.
## PYCLES_PATH=/cluster/work/climate/dgrund/git/pressel/pycles/

## JOB SETTINGS
#SBATCH -n 2 # for test
#SBATCH --time=01:30:00
#SBATCH --mem-per-cpu=4G
#SBATCH -A es_math
## SBATCH -A es_schemm
#SBATCH --job-name=c-SP
#SBATCH --output=compile_pycles_%A.out
#SBATCH --error=compile_pycles_%A.err
##SBATCH --mail-type=END,FAIL
#SBATCH --constraint=ibfabric6 # *
## * submit compilation as job on oldest hardware on Euler to ensure compatibility on all nodes

THIS_DIR=$(pwd)

echo "Compiling PyCLES."
echo Versions used for compilation:
which python
mpiexec --version

# where to find PyCLES
PYCLES_PATH=/cluster/work/climate/dgrund/git/dana-grund/pycles_worktree/SullivanPatton/
echo Looking for PyCLES at PYCLES_PATH=$PYCLES_PATH.

# # clean (from scratch)
# echo "Compiling PyCLES from scratch!"
# cd $PYCLES_PATH
# git clean -f -d -X # discard all changes in the .gitignore (compiled files)
# python generate_parameters.py

# compile
cd $PYCLES_PATH
CC=mpicc python setup.py build_ext --inplace

# test
TEST_PATH=$PYCLES_PATH/test_installation
mkdir $TEST_PATH
cd $TEST_PATH

echo TEST W/ MPI
mpirun -np 2 python $PYCLES_PATH/main.py $TEST_PATH/Straka93_test_nproc2.in
# mpirun -np 2 python $PYCLES_PATH/main.py $TEST_PATH/SullivanPatton_test_nproc2.in

cd $THIS_DIR
