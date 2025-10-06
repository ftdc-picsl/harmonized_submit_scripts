#!/bin/bash

submit_script="/project/ftdc_pipeline/ftdc-picsl/pmacsT1wPreprocessing-0.5.1/bin/submit_preproc.sh"

if [[ $# -lt 3 ]] ; then 
	echo "USAGE: ./submit_pmacsT1Preprocessing-0.5.1.sh <sub,seslist.txt,csv> <session or participant> <config>"
	echo "uses hd-bet to make a brain mask and then neck trim the T1w image" 
	echo " 		<sub,ses.csv> requires a subID,sesID per line if session"  
	echo " 		<sub.txt> requires a subID per line if participant"
	echo "		<config> is the config file used to define the base directories for bids_in, T1Preprocessing output: t1pre_dir, (and ANTsNetCT output: antsnetct_dir)"
	echo "" 
	echo "this script submits data in list to submit_preproc.sh in $scriptsdir "
	exit 1
fi

sublist=$1
listtype=$2
config=$3

if [[ $listtype != "session" && $listtype != "participant" ]] ; then
	echo "list type must be 'session' or 'participant'"
	exit 1
fi	

source ${config}

cmd="${submit_script} -i ${bids_in} -o ${t1pre_dir} ${sublist} ${listtype} --trim-neck" 
echo $cmd
$cmd
