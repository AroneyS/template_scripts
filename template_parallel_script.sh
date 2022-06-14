#!/bin/bash

source $(conda info --base)/etc/profile.d/conda.sh
conda activate base

BASENAME=$(echo $0 | sed "s=.*/==" | sed "s/\.sh//")
CPUS=1
MEMORY=4

while getopts 'i:o:c:m:' flag; do
  case "${flag}" in
    i) INPUT_FILE_LIST="${OPTARG}" ;;
    o) OUTPUT_DIR="${OPTARG}/subdir" ;;
    c) CPUS="${OPTARG}" ;;
    m) MEMORY="${OPTARG}" ;;
    *) echo "Usage: -i input_file_list -o output_dir [-c cpus -m memory]"
       exit 1 ;;
  esac
done

mkdir -p $OUTPUT_DIR/logs

cat $INPUT_FILE_LIST | parallel \
  mqsub --name $BASENAME --mem $MEMORY --cpus $CPUS --no-email -- \
  run_something \
    -output $OUTPUT_DIR/{/.}.out \
  '&>' $OUTPUT_DIR/logs/{/.}.log

