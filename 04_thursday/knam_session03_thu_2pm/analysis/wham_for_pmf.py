import os
import re
import subprocess
import matplotlib.pyplot as plt

# Settings
wham_exe = "/ocean/projects/see220002p/shared/10th/wham/wham/install/bin/wham"  # Change to your WHAM path
input_dir = "./"
output_metadata_file = "metadata.dat"
temp = 300.0
tolerance = 1e-5
wham_output_file = "result.dat"

# Regex to match files
filename_pattern = re.compile(
    r"rstcv_win_(\d+)_cnt_(\d+)_rc_([-+]?\d*\.?\d+)_k_([-+]?\d*\.?\d+)_([A-Za-z]+)\.cv"
)

rc_list = []

# Generate metadata.dat with each file
with open(output_metadata_file, "w") as meta_out:
    for filename in os.listdir(input_dir):
        match = filename_pattern.match(filename)
        if not match:
            continue
        win, cnt, rc, k, package = match.groups()
        path = os.path.join(input_dir, filename)
        rc = float(rc)
        k = float(k) * 2  # WHAM expects 2*k for Grossfield format coming from amber and charmm
        rc_list.append(rc)
        meta_out.write(f"{path} {rc} {k}\n")

# Sort and determine histogram range
rc_list = sorted(set(rc_list))
if len(rc_list) < 2:
    raise ValueError("Not enough distinct RC values to compute WHAM histogram.")
delta = min(j - i for i, j in zip(rc_list[:-1], rc_list[1:]))
hist_min = rc_list[0] - delta * 1.5
hist_max = rc_list[-1] + delta * 1.5
num_bins = len(rc_list) + 2

# Run WHAM
wham_cmd = [
    wham_exe,
    str(hist_min),
    str(hist_max),
    str(num_bins),
    str(tolerance),
    str(temp),
    str(0),  # No bootstrap
    output_metadata_file,
    wham_output_file
]

print("Running WHAM...")
result = subprocess.run(wham_cmd, capture_output=True, text=True)

if result.returncode == 0:
    print("WHAM finished successfully.")
    print(f"Output written to {wham_output_file}")
else:
    print("WHAM failed:")
    print(result.stderr)
    exit(1)

# Plot PMF
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
    plt.tight_layout()
    plt.savefig('wham_output.png', dpi=300)
    plt.close()
    print("Plot saved as wham_output.png")

except Exception as e:
    print(f"Could not generate plot: {e}")
