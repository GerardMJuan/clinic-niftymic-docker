#!/bin/bash

# Define directories
INPUT_DIR="/app/data/inputs"
OUTPUT_DIR="/app/data/outputs"

# Check if directories exist
if [ ! -d "$INPUT_DIR" ] || [ ! -d "$OUTPUT_DIR" ]; then
    echo "Error: Input or output directory does not exist"
    exit 1
fi

# Get all nii.gz files and create space-separated list
files=$(ls "$INPUT_DIR"/*.nii.gz | tr '\n' ' ' | sed 's/ $//')

# Run prepare_recon.py first
echo "Running prepare_recon.py..."
echo $files
python prepare_recon.py --subjects $files --output_dir "$OUTPUT_DIR" --apply_mask