#!/bin/bash

for i in $(seq 51 62)
do
	echo "Experiment: SRR74575${i}"
	fastq-dump -O data --gzip --defline-qual '+' SRR74575${i}
done
