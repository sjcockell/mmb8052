#!/bin/bash

wget -O extdata/gencode.vM31.transcripts.fa.gz 'https://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_mouse/release_M31/gencode.vM31.transcripts.fa.gz'
salmon index --gencode -t extdata/gencode.vM31.transcripts.fa.gz -i extdata/gencode.vM31.transcripts.idx
