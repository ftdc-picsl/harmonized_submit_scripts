#!/bin/bash

submit_script="/project/ftdc_pipeline/ftdc-picsl/pmacsAntsnetct-0.4.1/bin/submit_antsnetct_batch.sh"

if [[ $# -lt 2 ]]; then
   echo "USAGE: wrap_submit_antsnetct_parc.sh <sub,ses.csv> <config> <optional:queue>"
   echo "   wraps $submit_script for FTDC-ADRC harmonized ANTsNetCT parcellation pipeline"
   echo "---"
   echo "   all images in antsnetct sub,ses directories get submitted for parcellation"
   echo "  "
   echo "   config specifies bids_in, t1pre_dir, and antsnetct_dir"
   echo " "
   echo "   hardcoded inside here to do ANTs deep DKT and HOA"
   echo "---"
   echo "   if queue specified, jobs are submitted to it. Default: ftdc_normal"
   echo "---"
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

echo " -using antsnetct version ${antsnetct_version} "
echo ""
echo " i/o is ${antsnetct_dir} "
echo ""

    ${submit_script} -b "bsub -q $queue -cwd . " \
        -i $antsnetct_dir \
        -m 16000 \
        -n 2 \
        -N 8 \
        -v $antsnetct_version \
        antsnetct_parcellate \
        $subseslist \
        -- \
        --dkt31-masked \
        --dkt31-propagated \
        --hoa-masked \
        --cerebellum-masked
