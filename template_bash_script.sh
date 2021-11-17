#!/bin/bash

BASENAME=$(echo $0 | sed "s=.*/==" | sed "s/\.sh//")
CPUS=1
MEMORY=4

while getopts 'o:c:m:' flag; do
  case "${flag}" in
    o) OUTPUT_DIR="${OPTARG}/subdir" ;;
    c) CPUS="${OPTARG}" ;;
    m) MEMORY="${OPTARG}" ;;
    *) echo "Usage: -c cpus -m memory -o output_dir"
       exit 1 ;;
  esac
done

echo cpus=$CPUS
echo mem=$MEMORY
echo out=$OUTPUT_DIR
