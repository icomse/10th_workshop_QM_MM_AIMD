import os
import re
import subprocess
import matplotlib.pyplot as plt
from collections import defaultdict

# Put this wham.py where cv files exist, change wham path, and just run.
# Settings
wham_exe = "/ocean/projects/see220002p/shared/10th/wham/wham/install/bin/wham"  # Change to own path
input_dir = "./"
output_metadata_file = "metadata.dat"
output_data_dir = "wham_data"
temp = 300.0  # Temperature in K
tolerance = 1e-5  # WHAM convergence criterion
wham_output_file = "result.dat"

# Regex to parse file names based on cv files that Raafik provided.
filename_pattern = re.compile(
    r"rstcv_win_(\d+)_cnt_(\d+)_rc_([-+]?\d*\.?\d+)_k_([-+]?\d*\.?\d+)_([A-Za-z]+)\.cv"
)

# Make output directory
os.makedirs(output_data_dir, exist_ok=True)

# Collect files by window
window_files = defaultdict(list)
rc_list = []

for filename in os.listdir(input_dir):
    match = filename_pattern.match(filename)
    if not match:
        continue
    win, cnt, rc, k, package = match.groups()
    key = (int(win), float(rc), float(k))
    window_files[key].append(filename)

# Sort keys by window number
sorted_keys = sorted(window_files.keys(), key=lambda x: x[0])

# Write combined files and metadata ; doubling k in metadata for Grossfield wham
with open(output_metadata_file, "w") as meta_out:
    for idx, (win, rc, k) in enumerate(sorted_keys):
        rc_list.append(rc)
        output_file = f"win{win:03d}.dat"
        output_path = os.path.join(output_data_dir, output_file)
        with open(output_path, "w") as out_f:
            for fname in sorted(window_files[(win, rc, k)]):
                with open(os.path.join(input_dir, fname)) as in_f:
                    for line in in_f:
                        if line.strip():
                            out_f.write(line.strip() + "\n")
        meta_out.write(f"{output_path} {rc} {k*2}\n")

# Compute hist_min, hist_max, num_bins as follows to make data points pretty
rc_floats = sorted(float(r) for r in rc_list)
delta = min([j - i for i, j in zip(rc_floats[:-1], rc_floats[1:])])  # spacing
hist_min = rc_floats[0] - delta*1.50
hist_max = rc_floats[-1] + delta*1.50
num_bins = len(rc_floats) + 2

# Run WHAM
wham_cmd = [
    wham_exe,
    str(hist_min),
    str(hist_max),
    str(num_bins),
    str(tolerance),
    str(temp),
    str(0),
    output_metadata_file,
    wham_output_file
]

print("Running WHAM...\n")
result = subprocess.run(wham_cmd, capture_output=True, text=True)

if result.returncode == 0:
    print("WHAM finished successfully.")
    print(f"Output written to {wham_output_file}")
else:
    print("WHAM failed to run.")
    print(result.stderr)

# Plot
try:
    x, y = [], []
    with open(wham_output_file) as f:
        for line in f:
            if line.strip() and not line.startswith('#'):
                parts = line.strip().split()
                if len(parts) >= 2:
                    x.append(float(parts[0]))
                    y.append(float(parts[1]))

    plt.figure(figsize=(6, 4))
    plt.plot(x, y, label='PMF', color='blue')
    plt.xlabel('Reaction Coordinate')
    plt.ylabel('Free Energy (kcal/mol)')
    plt.title('Potential of Mean Force (WHAM)')
    plt.grid(False)
    plt.tight_layout()
    plt.savefig('wham_output.png', dpi=300)
    plt.close()
    print("Plot saved as wham_output.png")

except Exception as e:
    print(f"Could not generate plot: {e}")
