
odpal `.dev.py` (z `time`)  -> don't work & don't exist in repo o.O
`time sudo docker run -it --rm --name epivar -v "$PWD/":/project/ epi12 python3 /usr/local/bin/EpiNano/misc/Epinano_Variants.dev.py -r /project/ref.fa -b /project/reads.bam`

sprawdz `time`  `.py`

pocwicz wlaczanie/wylaczanie/usuwanie/dodawanie/laczenie sie z dockerowymi kontenerami

`minimap2`
	is `-F 2324` neccessary?
	is `-q 10` helpful

**n is NECCESSARY (but maybe it could be max nr of threads and kernel will take care of the rest?)**

epi-error
****
`.fa` -> `.fa.fai` (samtools) & `fa.dict` (picard)  - same for all human (unless newer genome release)
`.fq` -> `.bam`(minimap2&samtools), `.bam.bai` (samtools)
  
****
- `time command`
- `Epinano_Variants.py` szuka indeksow `ref` w oparciu o `ref.fa`, szuka indeksow `bam` w oparciu o `read.bam`
- `MasterOFPores` workflow uses `Epinano1.1`

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
echo "[+] Scirpt assume:
- human cDNA reference files (human_ref.fa, human_ref.fa.fai, human_ref.fa.dict) are in one dir and have exactly the same filename
- script is started in directory containing each patient directory which contain dirs with basecalled .fq.gz
(e.g. here_start_script/patient1/*fastq_pass/*fastq.gz)
- proper docker container (with Epinano_Variant.py dependencies) was build, and it's image name is epi12
- it has root privilege (for docker sake)"

read -p "[+] Path to dir with human_ref.fa, human_ref.fa.fai, human_ref.fa.dict: " REF_DIR
# echo '[+] In dir typed below - shouldn\'t have any other dirs than "patient dirs"'
# read -p "[+] Path to dir with patient dirs of basecalled .fq (e.g. /parent/fq_pass/fq.gz): " READ_DIR
PWD=$(pwd)
PARENT_DIRS=($(find "$PWD" -mindepth 1 -maxdepth 1 -type d -printf '%f\n'))  # store parent dirs in an array. '-printf '%f\n'' so not to store whole path
echo "[+] There are ${#PARENT_DIRS[@]} dirs in current dir"

# create bam&bai - invoke  INSIDE concatenate!
bambai () {
FQ.BAM="$PWD"/"$d"/"$dd"/"$d".fq.bam
echo "[+] control - bambai for $FQ.BAM started"
minimap2 -ax map-ont -L --split-prefix=tmp "$REF_DIR"/human_ref.fa "$FQ.GZ" | samtools view -bh | samtools sort -O bam > "$FQ.BAM"  # create reads.bam
samtools index "$FQ.BAM"  # create reads.bam.bai
}

# concatenate fastq.gz & invoke bambai func
concatenate () {
local FQ_DIR
FQ_DIR=($(find "$PWD/$d" -mindepth 1 -maxdepth 1 -type d -printf '%f\n'))  # store all dirs of a parent dir in an array
for dd in "${FQ_DIR[@]}"; do
# merging fast_pass with fast_fail needed !!!!!	

	if [[ "$dd" == *"fastq_pass" || "$dd" == *"fastq_fail" ]]; then  # [[]] enables '==' for expressions line in path. expansion or `=~` for regex matching
	FQ.GZ="$PWD"/"$d"/"$dd"/"$d".fastq.gz
	echo "[+] control - FQ.GZ: $FQ.GZ"
	FQ.GZ_DIR="$PWD/$d/$dd"
	echo "[+] control - FQ.GZ_DIR: $FQ.GZ_DIR"
	cat FQ.GZ_DIR/*.fastq.gz > "$FQ.GZ"
	bambai
	fi
done
}

# start docker containers with Epinano_Variants.py for every dir
# MUST run from concatenate
epivar12 () {
docker run -it -d --rm --name "$d" -v "$FQ.GZ_DIR/":/fq_dir/ -v "$REF_DIR/":ref_dir/ epi12 python3 /usr/local/bin/EpiNano/Epinano_Variants.py -R /ref_dir/human_ref.fa -b /fq_dir/"$d".fq.bam -s /usr/local/bin/EpiNano/misc/sam2tsv.jar -n 30  # n is NECCESSARY (but maybe it could be max nr of threads and kernel will take care of the rest?)
}


# invocation of functions
for d in "${PARENT_DIRS[@]}"; do
	echo "[+] Directory: $PWD/$d"
	concatenate
done


```