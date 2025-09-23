#!/bin/bash

submit_script="/project/ftdc_pipeline/ftdc-picsl/pmacsAntsnetct-0.2.2/bin/submit_antsnetct.sh"

if [[ $# -lt 2 ]]; then
   echo "USAGE: wrap_submit_antsnetct.sh <sub,ses.csv> <config> <optional:queue>"
   echo "   wraps $submit_script for FTDC-ADRC harmonized ANTsNetCT pipeline"
   echo "---" 
   echo "   each sub,ses gets submitted" 
   echo "   assumes T1-weighted images in bids_in have been brain masked with neck trim using " 
   echo "       T1wPreprocessing done for brain masking with neck trimming completed in t1pre_dir"
   echo "  " 
   echo "   config specifies bids_in, t1pre_dir, and antsnetct_dir"
   echo "---"
   echo "   if queue specified, jobs are submitted to it. Default: ftdc_normal"
   echo "---"
   echo "Notes: "
   echo " -uses ADNINormalAgingANTs as template (TEMPLATEFLOW_HOME set inside submit_antsnetct.sh)"
   echo " -uses antsnetct version 0.5.4 "
   echo " -uses do-ants-atropos-n4 option "
   echo " "
   exit 1
fi

subseslist=$1
config=$2

queue="ftdc_normal"
if [[ $# -eq 3 ]]; then
    queue=$3
fi

source $config

for i in `cat $subseslist`; do 
    sub=$(echo $i | cut -d ',' -f1)
    ses=$(echo $i | cut -d ',' -f2)

    ${submit_script} -b "bsub -q $queue -cwd . " \
        -B $t1pre_dir:/data/masks \
        -i $bids_in \
        -m 16000 \
        -n 4 \
        -o $antsnetct_dir \
        -v 0.5.4 \
        -- \
        --participant $sub \
        --session $ses \
        --brain-mask-dataset /data/masks \
        --do-ants-atropos-n4 \
        --template-name ADNINormalAgingANTs \
        --no-neck-trim --skip-bids-validation  # we neck trimmed during T1preproc and we are using derived inputs

    sleep .1

done