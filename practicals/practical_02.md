# MMB8052 Practical 02 - Advanced Commmand Line Linux

# Introduction

In the first practical we introduced the basics of the Linux command line. This second practical builds on these fundamentals to introduce more advanced tools and processes using the command line, with a particular focus on tools which process and manipulate text-based data.

A large amount of bioinformatics data is based on standard text formats - we've already seen UniProt database entries which are made up of structured text, and the FASTA sequence format, in which individual sequences are delineated by header lines beginning with ">". Other common formats include the FASTQ format for high-throughput sequencing data, the SAM (Sequence Alignment Map) format for storing genomic alignments and the GFF (General Feature Format) which is used for recording the position of genomic features.

Linux tools for processing text have been around for the best part of 50 years, and as such are robust and perform well, even with the often very large files common in bioinformatics. This practical will explore a number of these tools and how they can be used to work with the type of files listed above.

# Tools for Text

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

Some useful options for `grep` include:

`-c` to count the number of lines containing the search phrase
`-i` to make the search case-insensitive
`-o` to select only matching strings (rather than the whole line)
`-w` to select only lines containing matches that form whole words
`-v` to select non-matching lines
`--color` to highlight matches in the selected line (on by default in most Linux distributions)

Remember that `man grep` will give a full list of the available options and their descriptions. 
