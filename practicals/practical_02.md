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
@NB501177:26:HF3Y2BGX2:1:11101:23339:1070 1:N:0:CGGCTATG+GTCAGTAC
GTGGCACCATGGTTGTCAGACGTCAGTGCANACANNNCTAGATGTGGGCTACAGCGCATATACTCAGGGCCATGGT
+
AAAAAEEEEEEEEEEEEAE6AEEEEEEEEE#EEE###EEEEEEEEEEEEEEEEEEEEEEEEEEEAAEEEEEEEEEE
@NB501177:26:HF3Y2BGX2:1:11101:14507:1071 1:N:0:CGGCTATG+GTCAGTAC
GCCACAGTCAGCCAGCCAAACGTATGTTAGNATTNNNCAGGTGATCACAAAACTCAGGGCCATATATAAGAACA
+
AAAAAEEEEEEEEEEEEEEEEEEEEEEEEE#EEE###EEEEEEEEEEEEEEEEEEEEEEEEEEEEAEAAEEEEE
```

The ASCII quality characters used for Illumina sequencing, from left-to-right in increasing order of quality:

```
!"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJ
```

Most modern Illumina sequencers use quality "bins", a small set of discrete values which means that FASTQ files can be compressed more easily. For example, bases sequenced on the NovaSeq 6000 can take one of four possible quality values 2 (`#`), 12 (`-`), 23 (`8`) and 37 (`F`). The sequences in the example above come from a NextSeq 500, which uses six bins (`#`, `/`, `6`, `<`, `A`, `E`).

### SAM

SAM stands for _Sequence Alignment/Map_ format. It is a text-based table used to record the alignment of sequence reads to a reference sequence. Each individual alignment is recorded in a single line with 11 mandatory fields separated by tab characters.

#### The header

The header is an optional section of the SAM file that can describe things about the experiment as a whole. Each header line begins with the “@” character followed by a two-letter record type code. Each line is then tab-delimited.

```
@HD   VN:1.0     SO:unsorted
@SQ   SN:chr1    LN:197195432
@PG   ID:bowtie2 PN:bowtie2 VN:2.3.5.1
```

The `@HD` line is information about the SAM file itself (version, whether or not it is sorted). `@SQ` is information about the reference sequence (there would be one line per chromosome, if we were aligning to a whole multi-chromosome genome). `@PG` is about the program that generated the SAM file.


#### Mandatory alignment fields

| Column | Description | Notes |
|--------|-------------|-------|
| 1 | Query Template Name           | Read name in the FASTQ file being mapped            |
| 2 | Bitwise Flag                  | There’s a good description of bitwise flags here:   |
|   |                               | <https://davetang.org/muse/2014/03/06/understanding-bam-flags/>, and a decoder |
|   |                               | for the values in this column here:                     |
|   |                               | <http://broadinstitute.github.io/picard/explain-flags.html>  |
| 3 | Reference Sequence Name       | Sequence in the reference genome mapped to          |
|   |                               | (usually a chromosome)                              |
| 4 | 1-based left most mapping     | Beginning position of the mapping                   |
|   | position                      |                                                     |
| 5 | Mapping Quality               | −10log<sub>10</sub> P(mapping is wrong). A value of 255        |
|   |                               | indicates that the mapping quality is not available |
| 6 | CIGAR string                  | CIGAR = Concise Idiosyncratic Gapped Alignment Report  |
|   |                               | [More information](https://genome.sph.umich.edu/wiki/SAM#What_is_a_CIGAR.3F)  |
| 7 | Reference name of the         | Relevant to paired-end data                         |
|   | mate/next segment             |                                                     |
| 8 | Position of the mate/next     | Relevant to paired-end data                         |
|   | segment                       |                                                     |
| 9 | Observed template length      | Relevant to paired-end data                         |
| 10 | Segment Sequence             | The sequence of the read (not the reference)        |
| 11 | ASCII of Phred-scaled base   | Same as the quality in Sanger-encoded FASTQ         |
|    | base Quality+33              |                                                     |  

#### Additional alignment fields

All additional fields in an alignment line consist of 3 values, separated by colons, in the form TAG:TYPE:VALUE. There are a number of predefined tag types that can provide additional information about the alignment.

SAM alignment of the reads shown in the FASTQ example, above (generated by the alignment software [HISAT2](http://daehwankimlab.github.io/hisat2/)):

```
NB501177:26:HF3Y2BGX2:1:11101:23339:1070        0       11      6437060 60      76M     *       0       0       GTGGCACCATGGTTGTCAGACGTCAGTGCANACANNNCTAGATGTGGGCTACAGCGCATATACTCAGGGCCATGGT    AAAAAEEEEEEEEEEEEAE6AEEEEEEEEE#EEE###EEEEEEEEEEEEEEEEEEEEEEEEEEEAAEEEEEEEEEE    AS:i:-4 XN:i:0  XM:i:4  XO:i:0  XG:i:0  NM:i:4  MD:Z:30G3A0G0A39        YT:Z:UU NH:i:1
NB501177:26:HF3Y2BGX2:1:11101:14507:1071        16      1       153641443       60      73M1S   *       0       0      TGTTCTTATATATGGCCCTGAGTTTTGTGATCACCTGNNNAATNCTAACATACGTTTGGCTGGCTGACTGTGGC       EEEEEAAEAEEEEEEEEEEEEEEEEEEEEEEEEEEEE###EEE#EEEEEEEEEEEEEEEEEEEEEEEEEAAAAA      AS:i:-5 XN:i:0  XM:i:4  XO:i:0  XG:i:0  NM:i:4  MD:Z:37A0A0T3T29        YT:Z:UUNH:i:1
```

### GFF/GTF

The General Feature Format (GFF) is a standard table-based format for encoding genomic features. Each feature is encoded on one line, and each line consists of 9 columns of data. There have been 3 major versions of GFF, and the GTF (Gene Transfer Format) is very similar to GFF version 2. GFF3 is the most recent, and the preferred version of this format.

| Column | Description | Notes |
|--------|-------------|-------|
| 1 | seqid           | Identifier of the genomic sequence the current feature is found on.            |
| 2 | source           | Software or database feature comes from.            |
| 3 | type           | The type of feature, taken from the "lite" sequence ontology ([SOFA](http://www.sequenceontology.org/resources/intro.html)).            |
| 4 | start           | 1-indexed start location of the feature.            |
| 5 | end           | 1-indexed end location of the feature.            |
| 6 | score           | The score is usually derived by gene prediction software, and is likely an E-value or P-value. Can be left blank (".").            |
| 7 | strand           | + for positive strand, - for negative strand (relative to genomic sequence in 1).            |
| 8 | phase           | For features of type "CDS", the phase indicates where the feature begins with reference to the reading frame. The phase is one of the integers 0, 1, or 2, indicating the number of bases that should be removed from the beginning of this feature to reach the first base of the next codon.            |
| 9 | attributes           | A list of feature attributes in the format tag=value. Multiple tag=value pairs are separated by semicolons.            |

The flexible format of the 9th column makes this format problematic, and a GFF file needs to be examined carefully to understand what fields are found in column 9. A number of tags with pre-defined meaning are available see the [format specification](http://gmod.org/wiki/GFF3) for more information. The GFF format is often used for defining gene structures.

```
##gff-version 3
ctg123 . mRNA            1300  9000  .  +  .  ID=mrna0001;Name=sonichedgehog
ctg123 . exon            1300  1500  .  +  .  ID=exon00001;Parent=mrna0001
ctg123 . exon            1050  1500  .  +  .  ID=exon00002;Parent=mrna0001
ctg123 . exon            3000  3902  .  +  .  ID=exon00003;Parent=mrna0001
ctg123 . exon            5000  5500  .  +  .  ID=exon00004;Parent=mrna0001
ctg123 . exon            7000  9000  .  +  .  ID=exon00005;Parent=mrna0001
```

## wc

The `wc` command (word count) is a utility that given a file will list the number of lines, words and bytes in that file. The `-l` option restricts the output to just the number of lines in the file - this is particularly useful for file in which every line is a separate record, such as the case with tabular data.

Similarly, the `-w` option returns only the number of words in a file, and the `-c` option returns only the number of bytes (characters).

### Exercise 2.1 {: .exercise}

Estimated time: 1 min

Use `wc` to find the number of words, lines and bytes in the file of protein sequences you downloaded in Exercise 1.8.

## grep

Searching for specific text in large files can be a laborious process - `grep` is a useful and efficient utility which simplifies this task. `grep phrase file` is a command which will search for lines which contain `phrase` in a text file called `file`.

If our search phrase contains special characters which are usually interpreted by the bash shell (e.g. `>`, `<`, `|` or `*`), then it is necessary to enclose the phrase in single quotes - `grep 'phrase' file` - to prevent bash from interpreting these characters. For example, we would count the number of sequence entries in a FASTA file by counting the lines which contain the `>` character (which is used to start sequence header lines according to the FASTA specification). Since `>` is interpreted by bash as the redirection of `STDOUT`, the following command would actually overwrite the _input_ file, by redirecting the (non-existant) output of the `grep` command into the file:

```bash
$ grep > human.fa
```

To prevent this, we should ensure the search phrase is enclosed in single quotes:

```bash
$ grep '>' human.fa
```

This command will return all of the lines which contain a `>` character. We could then, for example, use `wc` to count them:

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

We can also use the special characters `^` and `$` to match phrases at the start and end of a line, for example:

```bash
$ grep '^>' human.fa
```

Will ensure that we only match `>` characters found at the _beginning_ of a line (this character is a _qualifier_ for the search phrase - it is not included as part of the phrase to be matched).

### Exercise 2.2 {: .exercise}

Estimated time: 3-4 min

- If you don't still have it saved from practical 1, use `wget` to download the Retinoblastoma UniProt entry (<https://rest.uniprot.org/uniprotkb/P06400.txt>)
- The lines of a UniProt file begin with 2 characters which denote the _type_ of line (documented in the user manual: <https://web.expasy.org/docs/userman.html>). Use `grep`, and this information to retrieve a list of publication identifiers relevant to the Rb protein (encoded in the `RX` lines)
- Narrow this list down to only those references which have a Digital Object Identifier (DOI). (Hint: you'll need to use a pipe (`|`) here)

Consider the following:

- Does your first search find anything other than publication identifier lines?
    - How could you make the search more specific to prevent this, if it is a problem?
- How many publications with a DOI are associated with the Rb protein?
- How about those with a PubMed ID?

## Regular Expressions

Searching for exact text matches is rather limited in scope - the true power of tools like `grep` becomes apparent when we can define search _patterns_ which can match variable text results. Regular expressions allow us to define these types of pattern.

`grep` actually provides the user with a number of ways of defining search patterns, the most powerful of these are Perl regular expressions (Perl is a programming language which is extremely good at text processing). These regular expressions can be "switched on" in `grep` by using the `-P` option.

A Perl regular expression is defined as a string of characters where each entity is either a regular character, which takes its literal meaning, or a _metacharacter_, which has a special meaning. Some metacharacter examples:

 - `.` - match _any_ character
 - `\w` - match any "word" character (alphanumerics and underscores)
 - `\s` - match any "whitespace" character
 - `\d` - match digit character (i.e. the numbers 0-9)
 - `\D` - match non-digit character (i.e. anything _other than_ the numbers 0-9)
 - `\t` - match the tab character
 - `\n` - match the newline character (i.e. what proceeds this character must be at the end of the line)
 - `*` - match the preceding character (or metacharacter) zero or more times
 - `+` - match the preceding character (or metacharacter) one or more times
 - `{n}` - match the preceeding character (or metacharacter) exactly `n` times (where `n` is replaced by a positive whole number)
 - `{n,}` - match the preceeding character at least `n` times
 - `{m,n}` - match the preceeding character (or metacharacter) between `m` and `n` times (inclusive)

If we want to match the actual characters (`.`, `+`, `*` etc) rather than imply their programmatic meaning as metacharacters, we will need to "escape" the character with a backslash (`\`). So if our pattern contains `+`, we need to express this so: `\+`.

By way of example, we will search the UniProt entry of another protein (ATM, Q13315) for the Ensembl Gene ID of the protein's parent gene. Human Ensembl Gene IDs start with ENSG, so we can use that to make a regular search of the UniProt entry:

```bash
$ wget 'https://rest.uniprot.org/uniprotkb/Q13315.txt'
$ grep 'ENSG' Q13315.txt
DR   Ensembl; ENST00000278616.9; ENSP00000278616.4; ENSG00000149311.20.
DR   Ensembl; ENST00000452508.6; ENSP00000388058.2; ENSG00000149311.20.
DR   Ensembl; ENST00000675843.1; ENSP00000501606.1; ENSG00000149311.20.
DR   HPA; ENSG00000149311; Low tissue specificity.
DR   OpenTargets; ENSG00000149311; -.
DR   VEuPathDB; HostDB:ENSG00000149311; -.
DR   GeneTree; ENSGT00670000098061; -.
DR   Bgee; ENSG00000149311; Expressed in corpus callosum and 239 other tissues.
     RFLCKAVENY INCLLSGEEH DMWVFRLCSL WLENSGVSEV NGMMKRDGMK IPTYKFLPLM
```

This search retrieves the expected database reference (DR) lines for Ensembl (among a few others), but also returns a line of the protein sequence, which contains the amino acid sequence Glu-Asn-Ser-Gly (ENSG). In this simple example we could figure out the "right" result from this simple list, but in a more complicated example, this may not be the case. To narrow down the results of our search to those line which contain genuine Ensembl Gene IDs, we will define a pattern which generally describes these identifiers. Human Ensembl Gene IDs all start with ENSG, which is then followed by 11 numbers, so a regular expression which will match _any_ human Ensembl Gene ID is: `'ENSG\d{11}'` - that is the exact letters `ENSG` followed by a sequence of exactly 11 digits (`\d`):

```bash
$ grep -P 'ENSG\d{11}' Q13315.txt
DR   Ensembl; ENST00000278616.9; ENSP00000278616.4; ENSG00000149311.20.
DR   Ensembl; ENST00000452508.6; ENSP00000388058.2; ENSG00000149311.20.
DR   Ensembl; ENST00000675843.1; ENSP00000501606.1; ENSG00000149311.20.
DR   HPA; ENSG00000149311; Low tissue specificity.
DR   OpenTargets; ENSG00000149311; -.
DR   VEuPathDB; HostDB:ENSG00000149311; -.
DR   Bgee; ENSG00000149311; Expressed in corpus callosum and 239 other tissues.
```

This more refined search removes the line of protein sequence information from the results, as well as the GeneTree database reference (which uses an identifier which looks a bit like the Ensembl Gene ID, but doesn't match it perfectly).

Now, if we want _just_ the identifier, without any extraneous text, we can use the `grep` option `-o` which makes `grep` return only the text that matches the pattern:

```bash
$ grep -P -o 'ENSG\d{11}' Q13315.txt
ENSG00000149311
ENSG00000149311
ENSG00000149311
ENSG00000149311
ENSG00000149311
ENSG00000149311
ENSG00000149311
```

The result here repeats the Ensembl Gene ID several times, because it is found on several lines. If we just want to get it once, we can pipe these results into the `sort` command, which has an option (`-u`) to give only the unique entries in a list (the tool `uniq` does something similar, but requires the input to be sorted anyway, so we may as well just use a single tool):

```bash
$ grep -Po 'ENSG\d{11}' Q13315.txt | sort -u
ENSG00000149311
```

### Exercise 2.3 {: .exercise}

Estimated time: 10 min

 - Repeat the above procedure to retrieve the Ensembl Gene ID for the Rb protein
 - Can you modify this procedure to retrieve the PubMed IDs associated with the RX lines we retrieved in exercise 2.2?
 - (More difficult) How about the DOIs? What are the common features of DOIs which can be used to build a regular expression?

## Other Text Processing Tools

As we've seen, much can be accomplished with `grep`, and the ability to not only search text but to effectively edit it and remove only the required sections make it a powerful tool, but Linux provides us with a well stocked armoury of such tools, allowing us to do so much more. We don't have space or scope to cover everything here, but included below are some selected highlights.

### sort

The `sort` command takes a file and sorts its lines according to some natural order. By default this ordering is alphanumeric - it is possible to change this using options. With delimited text (e.g. tab- or comma-separated values) it is possible to choose the _field_ you which to sort on (i.e. which column of the table). The field separator is defined using the `-t` option, and the column number to sort on is defined with the `-k` option.

### uniq

The `uniq` command prints a file with repeated lines omitted. As mentioned above, in order for `uniq` to find repeated lines, the file must be sorted such that these lines are next to one another. The `-d` option will print _only_ the repeated lines (i.e. the duplicates), and the `-n` option will include a count for each line (i.e. how many times it was found in the file).

### cut

`cut` is used to select sections from each line of a file. This selection can be specified in terms of bytes, characters or fields, where fields can be thought of as the columns of a table. This makes `cut` particularly useful for selecting columns from a table.

The `-f` option is used to select particular fields (a comma-separated list can be used to retrieve multiple columns). By default, `cut` will expect fields to be separated by the tab character. This can be changed using the `-d` option (for delimiter).

### Exercise 2.4 {: .exercise}

Estimated time: 10 min

- Download the example data table: <>
- `sort` the file by the corrected p-value (the column name is `adj.P.Val`), and redirect the output to a file
    - Are the results as you would expect?
    - Where do the column headings end up?
    - Can you figure out how to `sort` the column more correctly (read the `man` page - look for the "general numeric sort", which deals with scientific notation)
- Use a combination of `tail`, `sort`, `cut` and `head` to remove the column headers, find and return the names of the 10 genes with the largest positive log fold-change (`logFC`)
