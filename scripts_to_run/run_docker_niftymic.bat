@echo off
setlocal enabledelayedexpansion

:: Hardcoded directories
set "INPUT_DIR=nifti"
set "OUTPUT_DIR=output"
set "DICOM_DIR=dicom"

:: Get absolute paths
for %%i in ("%INPUT_DIR%") do set "INPUT_DIR=%%~fi"
for %%i in ("%OUTPUT_DIR%") do set "OUTPUT_DIR=%%~fi"
for %%i in ("%DICOM_DIR%") do set "DICOM_DIR=%%~fi"

:: Check if DICOM directory exists
if not exist "%DICOM_DIR%\" (
    echo Error: DICOM input directory %DICOM_DIR% does not exist
    pause
    exit /b 1
)

:: Create input directory if it doesn't exist
if not exist "%INPUT_DIR%\" (
    echo Creating input directory %INPUT_DIR%
    mkdir "%INPUT_DIR%"
)

:: Create output directory if it doesn't exist
if not exist "%OUTPUT_DIR%\" (
    echo Creating output directory %OUTPUT_DIR%
    mkdir "%OUTPUT_DIR%"
)


:: Run the docker container with NVIDIA GPU support
docker run ^
    --rm ^
    --ipc=host ^
    -v "%INPUT_DIR%":/app/data/nifti ^
    -v "%OUTPUT_DIR%":/app/data/outputs ^
    -v "%DICOM_DIR%":/app/data/dicoms ^
    gerardmartijuan/docker-niftymic-clinic:latest

:: Check if docker run was successful
if %ERRORLEVEL% equ 0 (
    echo Processing completed successfully
    echo Results are available in: %OUTPUT_DIR%
) else (
    echo Error: Docker container exited with an error
    pause
    exit /b 1
)

:: Add pause at the end to keep window open
pause