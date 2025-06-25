#!/bin/bash
#SBATCH -N 1
#SBATCH -p RM-shared
#SBATCH -t 00:15:00
#SBATCH --ntasks-per-node=4
cd $SLURM_SUBMIT_DIR

module purge
ml intel-oneapi

echo $PWD 

mpirun -np $SLURM_NTASKS sparc -name O2