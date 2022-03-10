#!/bin/bash
#environment: 

BASENAME=$(echo $0 | sed "s=.*/==" | sed "s/\.sh//")
CPUS=1
MEMORY=4
NCHUNKS=1
HOURS=168

while getopts 'i:o:c:m:n:s:t:' flag; do
  case "${flag}" in
    i) INPUT_FILE_LIST="${OPTARG}" ;;
    o) OUTPUT_DIR="results/subdir/${OPTARG}" ;;
    c) CPUS="${OPTARG}" ;;
    m) MEMORY="${OPTARG}" ;;
    n) NCHUNKS="${OPTARG}" ;;
    s) SUFFIX="${OPTARG}" ;;
    t) HOURS="${OPTARG}" ;;
    *) echo "Usage: -i input_file_list -o output_dir [-c cpus -m memory -n num_chunks -s suffix -t time_hours]"
       exit 1 ;;
  esac
done

BASENAME=${BASENAME}$SUFFIX
mkdir -p $OUTPUT_DIR/logs
COMMAND_FILE=$OUTPUT_DIR/logs/${BASENAME}_complete

cat $INPUT_FILE_LIST | parallel --dryrun \
  run_something \
    -output $OUTPUT_DIR/{/.} \
  '&>' $OUTPUT_DIR/logs/{/.}.log \
  > $COMMAND_FILE

mqsub --name $BASENAME --command-file $COMMAND_FILE --chunk-num $NCHUNKS --mem $MEMORY --cpus $CPUS --hours $HOURS \
  &> $OUTPUT_DIR/logs/${BASENAME}.log

# find ./ -maxdepth 1 -name "${BASENAME}*e*" | parallel cat
