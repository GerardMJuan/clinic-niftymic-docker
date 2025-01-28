#!/bin/bash

# Hardcoded directories
INPUT_DIR="input"
OUTPUT_DIR="output"

# Get absolute paths
INPUT_DIR=$(realpath "$INPUT_DIR")
OUTPUT_DIR=$(realpath "$OUTPUT_DIR")

# Check if directories exist
if [ ! -d "$INPUT_DIR" ]; then
    echo "Error: Input directory $INPUT_DIR does not exist"
    exit 1
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
    -u $(id -u):$(id -g) \
    docker-niftymic-clinic

# Check if docker run was successful
if [ $? -eq 0 ]; then
    echo "Processing completed successfully"
    echo "Results are available in: $OUTPUT_DIR"
else
    echo "Error: Docker container exited with an error"
    exit 1
fi
