#!/bin/bash
# --------- Create log directory if needed -----
mkdir -p logs
#SBATCH --job-name=02_UMB_CHARMM_MNDO97_SQM_BATCH
#SBATCH --partition=RM-shared
#SBATCH --ntasks=1
#SBATCH --time=00:15:00
#SBATCH --account=see220002p
#SBATCH --output=logs/%x_%j.out      # Main job log: logs/sqm_batch_<jobID>.out
#SBATCH --error=logs/%x_%j.err       # Error log: logs/sqm_batch_<jobID>.err

# --------- Window range configuration ---------
START=1 # Starting window number
#END=10 # Ending window number
END=$START # Ending window number

# --------- Run each window sequentially -------
for WIN in $(seq $START $END); do
    echo "=== Running window $WIN ==="
    bash 02_README_UMB_CHARMM_MNDO97.sh $WIN > logs/mndo97_win_${WIN}.out 2>&1
done
