# MMB8052 Practical 02 - Advanced Commmand Line Linux

# Introduction

In the first practical we introduced the basics of the Linux command line. This second practical builds on these fundamentals to introduce more advanced tools and processes using the command line, with a particular focus on tools which process and manipulate text-based data.

A large amount of bioinformatics data is based on standard text formats - we've already seen UniProt database entries which are made up of structured text, and the FASTA sequence format, in which individual sequences are delineated by header lines beginning with ">". Other common formats include the FASTQ format for high-throughput sequencing data, the SAM (Sequence Alignment Map) format for storing genomic alignments and the GFF (General Feature Format) which is used for recording the position of genomic features.

Linux tools for processing text have been around for the best part of 50 years, and as such are robust and perform well, even with the often very large files common in bioinformatics. This practical will explore a number of these tools and how they can be used to work with the type of files listed above.

# Tools for Text

## Formats

### FASTA

The FASTA file format is a 40-year old standard for representing either nucleotide or amino acid sequences. The first line of a FASTA entry begins with the greater-than symbol (`>`), and is referred to as the description line. It should contain a unique identifier for the sequence. The lines following the description line contain the sequence data, which can be spread across multiple lines and are expected to be represented in the standard IUPAC single-letter codes. A single file can contain many sequence entries, each beginning with its own description line.

```
>sequence_1
CGATAGCAGATGCGATGGATAGAGATTAGATAGAGGCTCGCGCTGACGCCGCTCGATCGGCTGAGCTACGCTCGAGATCG
CGATGCGCTATCGCGCTAGCTCG
>sequence_2
ATGAGCTGAGCGTAGTCGCGCATCAGCAGACTACAGCAGCAGACTCAGAACAGCAGCAGCAGCAGCACTACGCAGACTAC
GCATACGCAGACTACGCAGACGACTCAGCAGACGACTACGA
```

### FASTQ

The FASTQ format was developed by the Wellcome Trust Sanger Institute to store nucleotide sequence data along with associated quality scores, which provide information about the confidence of sequencing accuracy. FASTQ has become the _de facto_ standard for storing the output of high-throughput sequencing instruments. An entry in a FASTQ file consists of 4 lines:

 1. Begins with an `@` character, and is followed by a sequence identifier (like the FASTA description line)
 1. The sequence data (A/C/G/T/N)
 1. Delimits the sequence data and the quality data - in modern files usually contains only a `+` character
 1. The quality data for the bases in line 2 - must contain the same number of characters as line 2

The quality scores are encoded as an ASCII value - that is a single character that can be translated into an integer numerical value, generally in the range 0 - 41. This quality score, or Phred score is related to the probability of the corresponding base call being an error (the higher the Phred score, the lower this probability).

```


```

### SAM

### GFF/GTF

### VCF

## wc

The `wc` command (word count) is a utility that given a file will list the number of lines, words and bytes in that file. The `-l` option restricts the output to just the number of lines in the file -this is particularly useful for file in which every line is a separate record, such as the case with tabular data.

Similarly, the `-w` option returns only the number of words in a file, and the `-c` option returns only the number of bytes (characters).

### Exercise 2.1 {: .exercise}

Estimated time: 1 min

Use `wc` to find the number of words, lines and bytes in the file of protein sequences you downloaded in Exercise 1.8.

## grep

Searching for specific text in large files can be a laborious process - `grep` is a useful and efficient utility which simplifies this task. `grep phrase file` is a command which will search for lines which contain `phrase` in a text file called `file`.

If your search phrase contains special characters which are usually interpreted by the bash shell (e.g. `>`, `<`, `|` or `*`), then it is necessary to enclose the phrase in single quotes - `grep 'phrase' file` - to prevent bash from interpreting these characters. For example, you would count the number of sequence entries in a FASTA file by counting the lines which contain the `>` character (which is used to start sequence header lines according to the FASTA specification). Since `>` is interpreted by bash as the redirection of `STDOUT`, the following command would actually overwrite the _input_ file, by redirecting the (non-existant) output of the `grep` command into the file:

```bash
$ grep > human.fa
```

To prevent this, you should ensure the search phrase is enclosed in single quotes:

```bash
$ grep '>' human.fa
```

This command will return all of the lines which contain a `>` character. You could then, for example, use `wc` to count them:

```bash
$ grep '>' human.fa | wc -l
```

This command makes use of the "pipe" character (`|`) we first encountered in practical 1 to use the output from `grep` as the input for `wc`.

Some useful options for `grep` include:

 - `-c` to count the number of lines containing the search phrase (this would give the same result as the piped command, above)
 - `-i` to make the search case-insensitive
 - `-o` to select only matching strings (rather than the whole line)
 - `-w` to select only lines containing matches that form whole words
 - `-v` to select non-matching lines
 - `--color` to highlight matches in the selected line (on by default in most Linux distributions)

Remember that `man grep` will give a full list of the available options and their descriptions.
