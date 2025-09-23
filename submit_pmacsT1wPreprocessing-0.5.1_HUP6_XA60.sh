#!/bin/bash

#bids_in="/project/ftdc_volumetric/fw_bids"
bids_in="/project/ftdc_volumetric/hup6_xa60/bids"
t1pre_out="/project/ftdc_pipeline/data/T1wPreprocessing_051"

submit_script="/project/ftdc_pipeline/ftdc-picsl/pmacsT1wPreprocessing-0.5.1/bin/submit_preproc.sh"


if [[ $# -lt 2 ]] ; then 
	echo "USAGE: ./submit_pmacsT1Preprocessing-0.5.1.sh <sub,seslist.txt,csv> <session or participant>"
	echo "uses hd-bet to make a brain mask and then neck trim the T1w image" 
	echo " 		<sub,ses.csv> requires a subID,sesID per line if session"  
	echo " 		<sub.txt> requires a subID per line if participant"
	echo "" 
	echo "this script submits data in list to submit_preproc.sh in $scriptsdir "
	echo " images are looked for in BIDS format in $bids_in "
	echo " output in BIDS-ish format goes to $t1pre_out"
	exit 1
fi

sublist=$1
listtype=$2


if [[ $listtype != "session" && $listtype != "participant" ]] ; then
	echo "list type must be 'session' or 'participant'"
	exit 1
fi	


${submit_script} -i ${bids_in} -o ${t1pre_out} ${sublist} ${listtype}
