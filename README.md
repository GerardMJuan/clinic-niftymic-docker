# Docker NiftyMIC Clinical Pipeline

A Docker-based implementation of the NiftyMIC super-resolution reconstruction pipeline for clinical use, with ease of use and added preprocessing. This implementation provides a streamlined way to reconstruct fetal MRI using the NiftyMIC algorithm.

## Features

- Automated brain extraction and masking
- Super-resolution reconstruction
- Simplified clinical workflow
- Containerized environment for consistent results

## Prerequisites

- Docker
- NVIDIA GPU with CUDA support
- NVIDIA Container Toolkit

## Installation

1. Clone this repository:
```bash
git clone https://github.com/your-username/DockerNiftyMICClinic.git
cd DockerNiftyMICClinic
```

2. Build the Docker image:
```bash
docker build -t docker-niftymic-clinic .
```

3. Also available in dockerhub already built:

[`docker pull gerardmartijuan/docker-niftymic-clinic`](https://hub.docker.com/r/gerardmartijuan/docker-niftymic-clinic)

## Usage

1. Create input and output directories:
```bash
mkdir input output
```

2. Place your NIfTI files (*.nii.gz) in the input directory

3. Run the pipeline:
```bash
./scripts_to_run/run_docker_niftymic.sh
```

The script will:
- Mount your input and output directories
- Process all NIfTI files in the input directory
- Save results in the output directory

### Output Structure

```
output/
├── masks/          # Brain masks
├── preproc/        # Preprocessed images
└── recon.nii.gz    # Final reconstruction
```

## Advanced Usage

### Preprocessing Only

To run only the preprocessing steps:

```bash
./scripts_to_run/run_docker_niftymic.sh run_preproc.sh
```

### Custom Parameters

The pipeline uses default parameters optimized for clinical use. For advanced configuration, modify the scripts in the repository.


## License

This project is built upon NiftyMIC. Please see their license for terms of use.

https://github.com/gift-surg/NiftyMIC

## Citation

If you use this pipeline in your research, please cite the original NesVoR paper:

```latex
@article{10015091,
    author={Xu, Junshen and Moyer, Daniel and Gagoski, Borjan and Iglesias, Juan Eugenio and Ellen Grant, P. and Golland, Polina and Adalsteinsson, Elfar},
    journal={IEEE Transactions on Medical Imaging}, 
    title={NeSVoR: Implicit Neural Representation for Slice-to-Volume Reconstruction in MRI}, 
    year={2023},
    volume={},
    number={},
    pages={1-1},
    doi={10.1109/TMI.2023.3236216}
}
```
