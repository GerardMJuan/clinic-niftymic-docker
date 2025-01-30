#!/bin/bash

# Define directories
DICOM_DIR="/app/data/dicoms" # This is the directory where the DICOM files are stored
INPUT_DIR="/app/data/nifti"
OUTPUT_DIR="/app/data/outputs"

# Check if directories exist
if [ ! -d "$INPUT_DIR" ] || [ ! -d "$OUTPUT_DIR" ] || [ ! -d "$DICOM_DIR" ]; then
    echo "Error: Input or output or dicom directory does not exist"
    exit 1
fi

# create new directory in dicoms directory named "nifti"
mkdir -p "$DICOM_DIR/nifti"

# Run dcm2niix to convert DICOM files to NIfTI
echo "Running dcm2niix..."
dcm2niix -o "$DICOM_DIR/nifti" -f "%d_%p_%t_%s" -z y -w 0 "$DICOM_DIR"

# Check if INPUT_DIR is empty
if [ -z "$(ls -A $INPUT_DIR)" ]; then
    # move all the nifti files to the input directory, but only those that have either T2 or t2 in their name, and either HASTE or haste 
    find "$DICOM_DIR/nifti" -type f \( -name "*[Tt]2*[Hh][Aa][Ss][Tt][Ee]*.nii.gz" -o -name "*[Hh][Aa][Ss][Tt][Ee]*[Tt]2*.nii.gz" \) -exec mv {} "$INPUT_DIR" \;
else
    echo "Input directory is not empty; will use the files there for the reconstruction."
fi

# Get all nii.gz files and create space-separated list
files=$(ls "$INPUT_DIR"/*.nii.gz | tr '\n' ' ' | sed 's/ $//')

# Run prepare_recon.py first
echo "Running prepare_recon.py..."
echo $files
python prepare_recon.py --subjects $files --output_dir "$OUTPUT_DIR"

# Enable nullglob to prevent issues if no files match pattern
shopt -s nullglob

# Get list of mask files directly
list_of_masks=("$OUTPUT_DIR"/preproc/*_mask.nii.gz)
list_of_files=()

# Find corresponding input files for each mask
for mask in "${list_of_masks[@]}"; do
    file="${mask%_mask.nii.gz}.nii.gz"
    if [ -f "$file" ]; then
        list_of_files+=("$file")
    else
        echo "Warning: Input file not found for mask $mask"
        exit 1
    fi
done

# Check if we found any files
if [ ${#list_of_files[@]} -eq 0 ]; then
    echo "Error: No .nii.gz files found in input directory"
    exit 1
fi

# Create recon directory in output directory
mkdir -p "$OUTPUT_DIR/recon"

# Run reconstruction pipeline
echo "Running reconstruction pipeline..."
niftymic_run_reconstruction_pipeline \
    --filenames "${list_of_files[@]}" \
    --filenames-masks "${list_of_masks[@]}" \
    --dir-output "$OUTPUT_DIR/recon" \
    --isotropic-resolution 0.8 \
    --suffix-mask _mask \
    --alpha 0.01 \
    --automatic-target-stack 1 \
    --run-bias-field-correction 1

# check if the subject space reconstruction is successful
if [ ! -f "$OUTPUT_DIR/recon/recon_subject_space/srr_subject.nii.gz" ]; then
    echo "An error has happened during reconstruction, no subject space reconstruction found"
    exit 1
fi

# If we get here, the output exists, so move it
mv "$OUTPUT_DIR/recon/recon_subject_space/srr_subject.nii.gz" "$OUTPUT_DIR/recon_subject.nii.gz"

# Check for output files and logs
if [ ! -f "$OUTPUT_DIR/recon/recon_template_space/srr_template.nii.gz" ]; then
    echo "An error has happened during reconstruction, no template space reconstruction found"
    exit 1
fi

# If we get here, the output exists, so move it
mv "$OUTPUT_DIR/recon/recon_template_space/srr_template.nii.gz" "$OUTPUT_DIR/recon.nii.gz"
