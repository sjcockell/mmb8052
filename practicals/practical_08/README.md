# Data Preparation for MMB8052 Practical 08

## Author

&copy; 2022, Simon J Cockell

School of Biomedical, Nutritional and Sport Sciences,  
Newcastle University

## Process

Data is downloaded and processed by the BASH code in the `scripts/` directory. A single script process is available (`00_run_all.sh`), or individual processes can be run/repeated via the separate scripts.

Run all scripts with the base directory (the one containing this README) as the current working directory - all file paths are relative to this directory. 

## Data

Reference transcriptome is downloaded from [Gencode](https://www.gencodegenes.org/) - mouse transcriptome rel M31 (October 2022).

RNA-Seq experiment is found on GEO: [GSE116583](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE116583) - references to the SRA sample IDs can be found therein (or documented below). FASTQ format data for the sequencing reads was downloaded using sra-tools (fastq-dump v2.8.0) on 2022-09-26.

Read data from SRA was quantified against the referennce transcriptome from Gencode using Salmon (v1.9.0). Salmon writes output to `results/counts/${sample}`.

### Sample Information

| Sample | SRA ID | Exp. Cond. | 
|--------|--------|------------|
| GSM3243460 | SRR7457559 | Naive |
| GSM3243461 | SRR7457560 | Naive |
| GSM3243462 | SRR7457557 | Naive |
| GSM3243463 | SRR7457558 | Naive |
| GSM3243464 | SRR7457555 | Allo2h |
| GSM3243465 | SRR7457556 | Allo2h |
| GSM3243466 | SRR7457553 | Allo2h |
| GSM3243467 | SRR7457554 | Allo2h |
| GSM3243468 | SRR7457551 | Allo24h |
| GSM3243469 | SRR7457552 | Allo24h |
| GSM3243470 | SRR7457561 | Allo24h |
| GSM3243471 | SRR7457562 | Allo24h |

## Software

See the included `requirements.txt` for the software and versioning information. 
