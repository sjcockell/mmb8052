#!/bin/bash

GENCODE_RELEASE=M31
INDEX=extdata/gencode.v${GENCODE_RELEASE}.transcripts
TRUNK=SRR74575
RESULTS=results/counts/${TRUNK}

wget -O ${INDEX}.fa.gz "https://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_mouse/release_${GENCODE_RELEASE}/${INDEX}.fa.gz"
salmon index -t ${INDEX}.fa.gz -i ${INDEX}

for i in $(seq 51 62)
do
	echo "Experiment: SRR74575${i}"
	fastq-dump -O data --gzip --defline-qual '+' ${TRUNK}${i}
	salmon quant -l A -r data/${TRUNK}${i}.fastq.gz -i ${INDEX} -p 20 -o ${RESULTS}${i}
done

