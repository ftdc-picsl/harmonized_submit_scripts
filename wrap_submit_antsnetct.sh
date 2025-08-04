#!/bin/bash

bids_in="/project/ftdc_volumetric/fw_bids"
t1pre_in="/project/ftdc_pipeline/data/T1wPreprocessing_051"
out_dir="/project/ftdc_pipeline/data/antsnetct_054"

submit_script="/project/ftdc_pipeline/ftdc-picsl/pmacsAntsnetct-0.2.2/bin/submit_antsnetct.sh"

if [[ $# -lt 1 ]]; then
   echo "USAGE: wrap_submit_antsnetct.sh <sub,ses.csv> <optional:queue>"
   echo "   wraps $submit_script for FTDC cross sectional pipeline"
   echo "---" 
   echo "   each sub,ses gets submitted" 
   echo "   assumes T1-weighted images in $bids_in have been brain masked with neck trim using " 
   echo "       T1wPreprocessing done for brain masking with neck trimming completed in ${t1pre_in}"
   echo "  " 
   echo "   output goes to ${out_dir}"
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
queue="ftdc_normal"
if [[ $# -eq 2 ]]; then
    queue=$2
fi

for i in `cat $subseslist`; do 
    sub=$(echo $i | cut -d ',' -f1)
    ses=$(echo $i | cut -d ',' -f2)

    ${submit_script} -b "bsub -q $queue -cwd . " \
        -B $t1pre_in:/data/masks \
        -i $bids_in \
        -m 16000 \
        -n 4 \
        -o $out_dir \
        -v 0.5.4 \
        -- \
        --participant $sub \
        --session $ses \
        --brain-mask-dataset /data/masks \
        --do-ants-atropos-n4 \
        --template-name ADNINormalAgingANTs \
        --no-neck-trim --skip-bids-validation  # we neck trimmed during T1preproc and we are using derived inputs

    # echo $cmd
    #$cmd
    sleep .1

done