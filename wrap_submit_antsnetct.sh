#!/bin/bash

submit_script="/project/ftdc_pipeline/ftdc-picsl/pmacsAntsnetct-0.4.0/bin/submit_antsnetct_batch.sh"

if [[ $# -lt 2 ]]; then
   echo "USAGE: wrap_submit_antsnetct.sh <sub,ses.csv> <config> <optional:queue>"
   echo "   wraps $submit_script for FTDC-ADRC harmonized ANTsNetCT pipeline"
   echo "---" 
   echo "   each sub,ses gets submitted" 
   echo "   assumes T1-weighted images in bids_in have been brain masked with neck trim using " 
   echo "       T1wPreprocessing done for brain masking with neck trimming completed in t1pre_dir"
   echo "  " 
   echo "   config specifies bids_in , t1pre_dir, antsnetct_version, and antsnetct_dir"
   echo "---"
   echo "   if queue specified, jobs are submitted to it. Default: ftdc_normal"
   echo "---"
   echo "Notes: "
   echo " -uses ADNINormalAgingANTs as template (TEMPLATEFLOW_HOME set inside submit_antsnetct.sh)"
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

echo ""
echo " -neck-trimmed and padded t1preproc BIDS data from ${t1pre_dir} "
echo ""
echo " -using brain masks from ${t1pre_dir} "
echo ""
echo " -using antsnetct version ${antsnetct_version} "
echo ""
echo " output goes to ${antsnetct_dir} " 
echo ""


    ${submit_script} -b "bsub -q $queue -cwd . " \
        -B $t1pre_dir:$t1pre_dir \
        -i $t1pre_dir \
        -o $antsnetct_dir \
        -v $antsnetct_version \
        antsnetct \
        $subseslist \
        -- \
        --brain-mask-dataset $t1pre_dir \
        --do-ants-atropos-n4 \
        --template-name ADNINormalAgingANTs \
        --pad-mm 0 --no-neck-trim --skip-bids-validation  # we neck trimmed and padded during T1preproc and we are using derived inputs

