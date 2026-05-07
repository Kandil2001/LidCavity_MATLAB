#!/bin/bash
set -e
cd "$(dirname "$0")"
mkdir -p results/data results/figures
matlab -nodisplay -nosplash -r "main; exit"
