#!/bin/bash

usage(){
      echo -e "\nUsage:  ggHMM.sh -i <input_fasta> -o <output> -m <HMM_Dir> [options]"
      echo -e "\n\tGiven a ggKbase project protein download file and a scaffold2bin file this script"
      echo -e "\twill run HMMs, filter best hits, and parse the output for ggKbase upload."
      echo -e "\n\tOptions:"
      echo -e "\t-i: ggKbase project protein file (required)"
      echo -e "\t-o: Directory where output files will be written (required, will be created if absent)"
      echo -e "\t-m: Directory of HMM models (required)"
      echo -e "\t-t: Number of threads to use (Default: 6)"
      echo -e "\t-h: Display this message and exit"
      echo -e "\nby: Spencer Diamond February 6, 2019  ggHMM v1.1"
}

### TO DO ##
## 1. Move to Centralized Biotite Location
## 2.
##


### Default Arguments and Directories ###
threads=6
run_dir=$PWD
hmm_count=1
parser_dir="/home/sdiamond/bin/shared_scripts/"

### For Testing
#parser_dir="/Users/Spencer/Dropbox/Informatics/Scripts/ggHMM/scripts/" #change this to location in biotite


### Options Setup
while getopts ":hi:o:m:t:" opt; do
  case $opt in
    h)
      usage
      exit 1
      ;;
    i)
      input_prot=${OPTARG}
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      exit 1
      ;;
    o)
      output_dir=${OPTARG}
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      exit 1
      ;;
    m)
      hmm_dir=${OPTARG}
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      exit 1
      ;;
    t)
      threads=${OPTARG}
      ;;
    :) if [[ $OPTARG == "t" ]]; then
       :
       fi
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
  esac
done

if [ "$#" -lt 1 ]
	then
	usage
	exit 1
fi



### Make Output Directory
mkdir -p ${output_dir}
mkdir -p ${output_dir}/hmm_hit_tables/
mkdir -p ${output_dir}/hmm_hit_aln/



### Code chunk for performing Metabolic HMM annotation
echo -e "Beginning Metabolic HMM annotation of proteins"

for hmm in $(ls -1 ${hmm_dir}); do
  hmmsearch --cut_nc --cpu $threads --tblout ${output_dir}/hmm_hit_tables/${hmm}.txt ${hmm_dir}/${hmm} ${input_prot} > ${output_dir}/hmm_hit_aln/${hmm}.aln
  echo -en "\r${hmm_count} HMMs Analyzed"
  (( hmm_count++ ))
done


### Combine and parse HMM Output Files
echo -e "\nCombining and Parsing HMM Output"

cd ${output_dir}/hmm_hit_tables/

for i in $(ls -1 *.txt); do
  grep -v "#" $i >> all_hits.txt
done

Rscript ${parser_dir}/hmm_parser.R #change this to location in biotite

mv Hits_Filtered_Out.txt ../
# cd ${run_dir}
# mv ${run_dir}/${output_dir}/hmm_hit_tables/
