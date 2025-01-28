#!/bin/bash

if [ $# -eq 0 ]; then
    # Run default behavior
    ./run_recon.sh
else
    # Run whatever command was passed
    ./"$@"
fi