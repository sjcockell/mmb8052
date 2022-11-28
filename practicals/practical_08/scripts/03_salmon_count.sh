#!/bin/bash


for i in $(seq 51 62)
do
	echo "Experiment: SRR74575${i}"
	salmon quant -l A -r data/SRR74575${i}.fastq.gz -i extdata/gencode.vM31.transcripts.idx -p 20 -o results/counts/SRR74575${i}
done
