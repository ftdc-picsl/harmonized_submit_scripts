8/4/2025
This directory contains the 'harmonized' scripts for the ADRC and FTDC to submit T1 (and eventually hopefully other modalities) data for processing
We use the containers in /project/ftdc_pipeline/ftdc-picsl
For this version, we use 
    -pmacsT1wPreprocessing-0.5.1 for brain masking with the neck trim
    -pmacsAntsnetct-0.2.2 for the segmentation and cortical thickness estimate

Make a config in configs/ for your dataset. The config requires a 
bids_in="/path/to/bids"
t1pre_in="/path/to/output/of/T1wPreprocessing_051"
out_dir="path/to/output/of/antsnetct_054"

Once you make a config, don't delete it unless you delete your whole output directory for provenance or something probably.

