#!/bin/bash

submit_script="/project/ftdc_pipeline/ftdc-picsl/pmacsAntsnetct-0.3.0/bin/submit_antsnetct_parcellate.sh"

if [[ $# -lt 3 ]]; then
   echo "USAGE: wrap_submit_antsnetct_parcellate.sh <sub,ses.csv> <config> <atlas_label_config> <optional:queue>"
   echo "   wraps $submit_script for FTDC-ADRC harmonized ANTsNetCT parcellation pipeline"
   echo "---" 
   echo "   all images in antsnetct sub,ses directories get submitted for parcellation" 
   echo "  " 
   echo "   config specifies bids_in, t1pre_dir, and antsnetct_dir"
   echo " "
   echo "   atlas_label_config specifies atlases and labels"
   echo "       atlas_label_config must be absolute path for binding reasons. We use realpath inside to try even if you don't" 
   echo " "
   echo "   hardcoded inside here to do ANTs deep DKT and HO"
   echo "---"
   echo "   if queue specified, jobs are submitted to it. Default: ftdc_normal"
   echo "---"
   echo " "
   exit 1
fi

subseslist=$1
config=$2
atlas_label_config=$3
atlas_label_config=`realpath $atlas_label_config`

queue="ftdc_normal"
if [[ $# -eq 4 ]]; then
    queue=$4
fi

source $config

echo " -using antsnetct version ${antsnetct_version} "
echo ""
echo " i/o is ${antsnetct_dir} " 
echo ""

for i in `cat $subseslist`; do 
    sub=$(echo $i | cut -d ',' -f1)
    ses=$(echo $i | cut -d ',' -f2)

    ${submit_script} -b "bsub -q $queue -cwd . " \
        -B $atlas_label_config:$atlas_label_config \
        -i $antsnetct_dir \
        -m 16000 \
        -n 4 \
        -v $antsnetct_version \
        -- \
        --participant $sub \
        --session $ses \
        --dkt \
        --ho \
        --atlas-label-config $atlas_label_config

    sleep .1

done