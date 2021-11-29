#!/bin/bash
# envionment: 

BASENAME=$(echo $0 | sed "s=.*/==" | sed "s/\.sh//")
CPUS=1
MEMORY=4
NCHUNKS=50

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
COMMAND_FILE=${BASENAME}_commands
mkdir -p $OUTPUT_DIR/logs

cat $INPUT_FILE_LIST | parallel --dryrun \
  run_something \
    -output $OUTPUT_DIR/{/.} \
  '&>' $OUTPUT_DIR/logs/{/.}.log \
  > $COMMAND_FILE

mqsub --name $BASENAME --command-file $COMMAND_FILE --chunk-num $NCHUNKS --mem $MEMORY --cpus $CPUS --hours $HOURS \
  &> $OUTPUT_DIR/logs/${BASENAME}.log

# find ./ -name "${BASENAME}*e*" | parallel cat
