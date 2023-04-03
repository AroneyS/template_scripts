#!/bin/bash

source $(conda info --base)/etc/profile.d/conda.sh
conda activate base

BASENAME=$(echo $0 | sed "s=.*/==" | sed "s/\.sh//")
CPUS=1
MEMORY=8
NCHUNKS=1
HOURS=168
QUEUE=microbiome
SUBMIT=true

while getopts 'i:o:c:m:n:s:t:q:l' flag; do
  case "${flag}" in
    i) INPUT_FILE_LIST="${OPTARG}" ;;
    o) OUTPUT_DIR="results/subdir/${OPTARG}" ;;
    c) CPUS="${OPTARG}" ;;
    m) MEMORY="${OPTARG}" ;;
    n) NCHUNKS="${OPTARG}" ;;
    s) SUFFIX="${OPTARG}" ;;
    t) HOURS="${OPTARG}" ;;
    q) QUEUE="${OPTARG}" ;;
    l) SUBMIT="" ;;
    *) echo "Usage: -i input_file_list -o output_dir [-c cpus -m memory -n num_chunks -s suffix -t time_hours -q queue -l (local run)]"
       exit 1 ;;
  esac
done

BASENAME=${BASENAME}$SUFFIX
mkdir -p $OUTPUT_DIR/logs
COMMAND_FILE=$OUTPUT_DIR/logs/${BASENAME}_commands.sh

cat $INPUT_FILE_LIST | parallel --dryrun --plus --col-sep "\t" \
  run_something \
    -output $OUTPUT_DIR/{/.} \
  '&>' $OUTPUT_DIR/logs/{/.}.log \
  > $COMMAND_FILE

if [ -z "$SUBMIT" ]
then
  echo "Run commands using `parallel -j64 :::: $COMMAND_FILE`"
else
  mqsub -q $QUEUE --name $BASENAME --command-file $COMMAND_FILE --chunk-num $NCHUNKS --mem $MEMORY --cpus $CPUS --hours $HOURS \
    &> $OUTPUT_DIR/logs/${BASENAME}.log
fi

# find ./ -maxdepth 1 -name "${BASENAME}*e*" | parallel cat
