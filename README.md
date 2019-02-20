# ggHMM

ggHMM is a shell wrapper script that scans protein sequences downloaded from ggKbase with a provided set of HMMs. Output is a table that is ready for upload into ggKbase or further analysis by the user.

ggKbase is avalible at
[ggKbase](https://ggkbase.berkeley.edu/)

Usage and HMM import instructions are avalible at
[ggKbase Help](https://ggkbase-help.berkeley.edu/site-functions/hmm-import/)

## Quick start

### Script Usage:
```
ggHMM.sh -i <input_fasta> -o <output> -m <HMM_Dir> [options]

	Given a ggKbase project protein download file and a scaffold2bin file this script
	will run HMMs, filter best hits, and parse the output for ggKbase upload.

	Options:
	-i: ggKbase project protein file (required)
	-o: Directory where output files will be written (required, will be created if absent)
	-m: Directory of HMM models (required)
	-t: Number of threads to use (Default: 6)
	-h: Display this message and exit
```

## Dependencies
* [R](https://www.r-project.org/)
* [HMMER](http://hmmer.org/)
