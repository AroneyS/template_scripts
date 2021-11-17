#!/bin/bash

BASENAME=$(echo $0 | sed "s=.*/==" | sed "s/\.sh//")
COMMAND_FILE=${BASENAME}_commands
CPUS=1
MEMORY=4
NCHUNKS=50

while getopts 'i:o:c:m:n:' flag; do
  case "${flag}" in
    i) INPUT_FILE_LIST="${OPTARG}" ;;
    o) OUTPUT_DIR="${OPTARG}/subdir" ;;
    c) CPUS="${OPTARG}" ;;
    m) MEMORY="${OPTARG}" ;;
    n) NCHUNKS="${OPTARG}" ;;
    *) echo "Usage: -i input_file_list -o output_dir [-c cpus -m memory -n num_chunks]"
       exit 1 ;;
  esac
done

mkdir -p $OUTPUT_DIR/logs

cat $INPUT_FILE_LIST | parallel --dryrun \
  run_something \
    -output $OUTPUT_DIR/{/.} \
  '&>' $OUTPUT_DIR/logs/{/.}.log \
  > $COMMAND_FILE

mqsub --name $BASENAME --command-file $COMMAND_FILE --chunk-num $NCHUNKS --mem $MEMORY --cpus $CPUS \
  &> $OUTPUT_DIR/logs/${BASENAME}.log

# find ./ -name "${BASENAME}*e*" | parallel cat
