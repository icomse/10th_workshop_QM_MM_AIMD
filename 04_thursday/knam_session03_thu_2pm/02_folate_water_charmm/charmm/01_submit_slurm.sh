#!/bin/bash
#SBATCH --job-name=01_UMB_CHARMM_SQM_EQU_SWEEP
#SBATCH --partition=RM-shared
#SBATCH --ntasks=1
#SBATCH --time=00:30:00
#SBATCH --account=see220002p
#SBATCH --output=slurm_%j.out
#SBATCH --error=slurm_%j.err

# Run your umbrella sampling sweep script
bash 01_README_UMB_CHARMM_MNDO97_EQU_SWEEP.sh
