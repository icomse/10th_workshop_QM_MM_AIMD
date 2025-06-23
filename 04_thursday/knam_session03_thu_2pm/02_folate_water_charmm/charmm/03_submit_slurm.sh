#!/bin/bash
#SBATCH --job-name=03_UMB_CHARMM_DFTB_BATCH
#SBATCH --partition=RM-shared
#SBATCH --ntasks=8
#SBATCH --cpus-per-task=2
#SBATCH --time=24:00:00
#SBATCH --account=see220002p
#SBATCH --output=logs/%x_%j.out      # Main job log: logs/sqm_batch_<jobID>.out
#SBATCH --error=logs/%x_%j.err       # Error log: logs/sqm_batch_<jobID>.err

# --------- Window range configuration ---------
START=1 # Starting window number
END=10 # Ending window number

# --------- Create log directory if needed -----
mkdir -p logs

# --------- Run each window sequentially -------
for WIN in $(seq $START $END); do
    echo "=== Running window $WIN ==="
    bash 03_README_UMB_CHARMM_DFTB.sh $WIN > logs/dftb_win_${WIN}.out 2>&1
done
