#!/bin/bash

# Hardcoded directories
INPUT_DIR="nifti"
OUTPUT_DIR="output"
DICOM_DIR="dicom"

# Get absolute paths
INPUT_DIR=$(realpath "$INPUT_DIR")
OUTPUT_DIR=$(realpath "$OUTPUT_DIR")
DICOM_DIR=$(realpath "$DICOM_DIR")

# Check if directories exist
if [ ! -d "$DICOM_DIR" ]; then
    echo "Error: Dicom input directory $DICOM_DIR does not exist"
    exit 1
fi

# Create input directory
if [ ! -d "$INPUT_DIR" ]; then
    echo "Creating input directory $INPUT_DIR"
    mkdir -p "$INPUT_DIR"
fi

if [ ! -d "$OUTPUT_DIR" ]; then
    echo "Creating output directory $OUTPUT_DIR"
    mkdir -p "$OUTPUT_DIR"
fi

# Run the docker container with NVIDIA GPU support
docker run \
    --rm \
    --gpus all \
    -v "$INPUT_DIR":/app/data/inputs \
    -v "$OUTPUT_DIR":/app/data/outputs \
    -v "$DICOM_DIR":/app/data/dicoms \
    -u $(id -u):$(id -g) \
    gerardmartijuan/docker-niftymic-clinic:latest

# Check if docker run was successful
if [ $? -eq 0 ]; then
    echo "Processing completed successfully"
    echo "Results are available in: $OUTPUT_DIR"
else
    echo "Error: Docker container exited with an error"
    exit 1
fi
