
odpal `.dev.py` (z `time`)
`time sudo docker run -it --rm --name epivar -v "$PWD/":/project/ epi12 python3 /usr/local/bin/EpiNano/misc/Epinano_Variants.dev.py -r /project/ref.fa -b /project/reads.bam`

sprawdz `time`  `.py`

pocwicz wlaczanie/wylaczanie/usuwanie/dodawanie/laczenie sie z dockerowymi kontenerami

epi-error
****
`.fa` -> `.fa.fai` (samtools) & `fa.dict` (picard)  - same for all human (unless newer genome release)
`.fq` -> `.bam`(minimap2&samtools), `.bam.bai` (samtools)

****
- `time command`
- `Epinano_Variants.py` szuka indeksow `ref` w oparciu o `ref.fa`, szuka indeksow `bam` w oparciu o `read.bam`


```bash
#! /usr/bin/env bash
# assume fa, fa.fai and fa.dict exist in /path/to/ref
# let's we've got dirs of patients containing i.a. fastq_pass & fastq_fail dirs

# I want this script to concatenate fastq files of patients -> create bam -> create bai -> create .csv | than repeat for the next patient

# I will create a functions that will - concatenate, create bam&bai, create csv
# I will use a loop iterating through dirs of patients
# It doesn't matter if thats WT or KO :D 

# arguments needed at start: ref dir, reads dir (dir with patient dirs)
# read -p 'Username: ' uservar
# read -sp 'Password: ' passvar
# ----------------------------------------------------------------------------
read -p "[+] Path to dir with .fa, .fa.fai, .fa.dict: " REF_DIR
echo '[+] In dir typed below - shouldn\'t have any other dirs than "parent dirs"'
read -p "[+] Path to dir with parent dirs (e.g. parent/fq_pass/fq.gz): " READ_DIR
PWD=$(pwd)
PARENT_DIRS=($(find "$PWD" -mindepth 1 -maxdepth 1 -type d -printf '%f\n'))  # store parent dirs in an array. '-printf '%f\n'' so not to store whole path
echo "[+] There are ${#PARENT_DIRS[@]} dirs in current dir"

# concatenate function
concatenate () {
local FQ_DIR
FQ_DIR=($(find "$PWD/$d" -mindepth 1 -maxdepth 1 -type d -printf '%f\n'))  # store all dirs of a parent dir in an array
for dd in "${FQ_DIR[@]}"; do
	if [[ "$dd" == *"fastq_pass" || "$dd" == *"fastq_fail" ]]  # [[]] enables '==' for expressions line in path. expansion or `=~` for regex matching
	cat "$PWD"/"$d"/"$dd"/*.fastq > "$PWD"/"$d"/"$dd"/"$d".fastq
	fi
done
}

# 


for d in "${PARENT_DIRS[@]}"; do
	echo "[+] Directory: $PWD/$d"
	concatenate
done


```