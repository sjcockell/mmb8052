# MMB8052 Practical 03 - Project Management and Version Control

# Introduction

The life of a laboratory scientist is improved by a well organised lab, and lab book. Similarly, the computational scientist's lot is made better by well-organised and well-documented electronic files. It doesn't really matter how big or small the bioinformatics project you're working on is, you will make things easier on yourself by having a project directory laid out in a consistent and easy to understand fashion.

Processing hundreds of sequence files becomes trivial with scripting if these files are consistently named and are organised in a logical directory structure. If the structure and naming conventions are shared between projects, then the scripts written for one project become reusable for the next.

In this practical, we will look at some of the best practices surrounding the organisation and documentation of bioinformatics projects. In addition we will take a look at a modern _version control_ system (VCS), called `git`. Version control is important for managing the process of writing computer code (or other 'plain text' file types) - a VCS is a piece of software which records the changes made to a file or set of files over time, and allows the user to share those changes with others, to work on parallel versions of the same code base, and to rollback changes made to the project at any time.

A good document management process, coupled with robust version control are critical in enabling reproducible computational science. This benefits both the researcher who uses this process, and the wider community who want to re-use the products of their research. This includes (and indeed is primarily aimed at) members of their own lab.

In the exercises below, we will look at one example of project organisation and documentation. I have found that this system works well for me, but you may wish to adapt it for your own way of working. There is no real _correct_ way to organise your files, but I would advocate that _any_ system is better than _no_ system.

# Directory Organisation

Each project should be organised into its own directory, under which should be a common set of sub-directories. All directory names should be meaningful - both to you and to any potential third party. In most projects, you will have at least 3 sub-directories:

 1. `data/` - for storing the raw data associated with the project
 1. `results/` - for storing the output of computational experiments
 1. `scripts/` - for storing the process which takes (1) as input and produces (2) as output.

Additional directories which can be added include things like `extdata/` for storing data external to the project, but required for data processing (such as reference genome file, for example) and `software/` for saving versions of external software used during the project (though this is often now replaced with a config file for a package management system like [Conda](https://docs.conda.io/en/latest/)).

## Shell Expansion

The `bash` shell you are using at the command line provides you with a number of tricks you can exploit to improve the efficiency of your work. Some of these which you may have already encountered include **tab-completion** (the pressing of the _tab_ key - usually above Caps Lock - leads to `bash` "guessing" the command you want to type), and the **command history** (press the _up_ arrow to cycle back through your recent commands, press Ctrl+R to search your previous commands). Another such trick is shell expansion.

The simplest example of shell expansion is the tilde (`~`) shortcut for your home directory. When you type this character at the command prompt, `bash` expands it to the full path to your home directory. Another commonly seen example of shell expansion are wildcards, where (for example) the asterisk (`*`) is expanded to all matching files:

```bash
list all files in the home directory which end ".txt"
$ ls ~/*.txt
```

A useful expansion, called _brace expansion_ can be handy when setting up nested directory structures. Brace expansion creates strings by expanding the comma-separated values inside a pair of _curly braces_ (`{}`). See this trivial example:

```bash
$ echo self-{aware,esteem,confident}
self-aware self-esteem self-confident
```

### Exercise 3.1 {: .exercise}

Estimated time: 2 mins

 - Work out a single command which uses brace expansion to create the project directory structure for Assessment 1, bear in mind the following factors:

 1. Directory and file names should not contain spaces (it is good practice to replaces spaces with underscores - `_`)
 1. Your project directory should contain the sub-directories described above
 1. Your project directory should be a direct sub-directory of your home directory
 1. `mkdir` has an option which allows it to create nested directories in a single command - use `man mkdir` to figure out what this option is

# Documentation

Organising your files well is just one part of effective management of your computational research. Our bioinformatics projects also require good _documentation_. Much like a well-kept lab notebook, the major beneficiary of a well-documented project is future you. Poor documentation can lead to irreproducibility and be a source of potential error.

Lots of complexity can hide in bioinformatics work - large numbers of similar files, vast numbers of program parameters, rapidly changing software and other factors besides. Our best defense against this complexity causing us problems down the line is to keep good documentation - what software version did we use? Paired with which parameters? Why did we make this decision?

The most basic level of documentation is the so-called README file. Every project should contain a README in its base directory, which records a standard set of information (or _metadata_) about the experiments carried out in that project.

## The README file
