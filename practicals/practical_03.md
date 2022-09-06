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

Additional directories which can be added include things like `extdata/` for storing data external to the project, but required for data processing (such as a reference genome file, for example) and `software/` for saving versions of external software used during the project (though this is often now replaced with a config file for a package management system like [Conda](https://docs.conda.io/en/latest/)).

## Shell Expansion

The `bash` shell you are using at the command line provides you with a number of tricks you can exploit to improve the efficiency of your work. Some of these which you may have already encountered include **tab-completion** (the pressing of the _tab_ key - usually above Caps Lock - leads to `bash` "guessing" the command or file path you want to type), and the **command history** (press the _up_ arrow to cycle back through your recent commands, press Ctrl+R to search your previous commands). Another such trick is shell expansion.

The simplest example of shell expansion is the tilde (`~`) shortcut for your home directory. When you type this character at the command prompt, `bash` expands it to the full path to your home directory. Another commonly seen example of shell expansion are wildcards, where (for example) the asterisk (`*`) is expanded to all matching files:

```bash
# list all files in the home directory which end ".txt"
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

Lots of complexity can hide in bioinformatics work - large numbers of similar files, vast numbers of program parameters, rapidly changing software and other factors besides. Our best defence against this complexity causing us problems down the line is to keep good documentation - what software version did we use? Paired with which parameters? Why did we make this decision?

## The README file

The most basic level of documentation is the so-called README file. Every project should contain a README in its base directory, which records a standard set of information (or _metadata_) about the experiments carried out in that project. This file is not intended as a complete record of our process (this is what the lab book is for - and even if all your experiments are _dry_, you should still keep a lab book).

| README Section | Description |
|----------------|-------------|
| Author         | Basic information about you and the project (affiliation, date etc). Useful for if the project is redistributed, and a good habit to get into. |
| Process        | Which scripts to run, and in which order. An outline of what each script does, and what it requires to run. |
| Data           | What's the source of the data? When did you download it? Where is it backed-up? What database version does it come from? |
| Software       | What software is required for the project? Which versions did you use? |

## Markdown

Markdown is a simple to write _markup language_ which is easy to convert into different document formats (particularly, but not exclusively, HTML). Since Markdown is a plain text format, it is easy to author using a command line text editor such as `nano` (which we have met in earlier practicals). There are a number of simple guides to the basic syntax of Markdown, [this is a representative example](https://www.markdownguide.org/basic-syntax/).

The simplicity of Markdown makes it an excellent choice for documentation. By way of example, all of the practical guides you have been following during this course have been authored in Markdown and then converted into the webpages you find embedded in Canvas. The raw Markdown for _this_ document can be found here: <https://raw.githubusercontent.com/sjcockell/mmb8852/main/practicals/practical_03.md>.

### Exercise 3.2 {: .exercise}

Estimated time: 5 minutes

 - Using `nano`, write a README file in the base directory of the project structure you created in exercise 3.1.
 - Add a level 1 heading with a document title
 - Add level 2 headings for the README sections detailed above
 - Add information in the Author section, using other Markdown elements as required.

# Software Management

Towards the end of Practical 2, we looked at software installation, particularly using the Linux package manager, APT. This is a robust way of managing software installation on a Linux computer, but suffers from a number of limitations:

- Software must be pre-packaged for APT, and accepted into centrally managed repositories for ease of distribution
- User must have administrator rights to install new software
- APT manages software system-wide, so only one version can be installed

In research computing, there are reasons why we are not able to assume all (or even any) of these things.

- Many scientific software projects do not have the resources to package software in multiple ways
- It is not a given that we will have admin rights on the machine where we want to carry out most of our compute - this is highly unlikely on a shared high-performance computing environment for example
- We often want to manage a number of parallel versions of the same software (for example, one project may be under review, and so need to be maintained on an older software release to ensure consistency, while newer projects make use of the latest version to ensure they are at the cutting edge)

There are a number of modern software management solutions which provide answers to these problems. Probably the best known and most widely used is [Conda](https://docs.conda.io/en/latest/).

## Conda

Anaconda, or Conda is an open source, cross-platform package and environment management system. Initially developed for the Python programming language (hence the "snakey" name), it has since been expanded to manage a wide range of software. Conda is able to help you find and install software packages, and can create, save and load _environments_, allowing us to maintain parallel installations of different software versions and their dependencies (more on this below). Conda is lightweight and doesn't require admin privileges to install or run, and software is relatively simple to package for distribution by a Conda repository (many of which are community-maintained, rather than having a centralised gatekeeper).

In addition to these helpful features which overcome the above limitations of APT, Conda has been widely adopted within the bioinformatics research community, meaning that many software packages produced for bioinformatics are available to install using Conda (a great many more than are available via APT). See the [Bioconda Project](https://bioconda.github.io/) for more information.

## Installing Conda

Conda is installed via a downloadable `bash` script. It is important to download the right script for our system, and to test that the code we've downloaded is what we expect it to be (running arbitrary code downloaded from the internet is a _bad idea_ <sup>TM</sup>). We're installing so-called "Miniconda", which is a minimal installation to save on disk space. The following commands have been tested on Ubuntu 20.04.

```bash
# Download the installer
$ wget https://repo.anaconda.com/miniconda/Miniconda3-py38_4.12.0-Linux-x86_64.sh
# Check it is what it says it is
$ sha256sum Miniconda3-py38_4.12.0-Linux-x86_64.sh
# Output should read:
3190da6626f86eee8abf1b2fd7a5af492994eb2667357ee4243975cdbb175d7a  Miniconda3-py38_4.12.0-Linux-x86_64.sh
# Run the installer
# if the above "hash" does not match exactly
# DO NOT take this next step
# ask a demonstrator if you're not sure
$ bash Miniconda3-py38_4.12.0-Linux-x86_64.sh
```

The `conda` installer will prompt you for some information. Firstly accept the license agreement (use the space bar to page through the agreement, and then type 'yes' when prompted). Accept the default installation location. Type 'yes' when asked if you want the installer to initialize Miniconda3.

In order to be able to use Conda, you will have to log out of your Linux machine and log back in again. You will know it has worked because `(base)` will appear at the beginning of your command prompt - this is the name of your current environment.

### Exercise 3.3 {: .exercise}

Estimated time: 10 minutes

- Install Conda as per the above instructions.

## Channels

A channel is a location where Conda packages are stored and made available for installation. Discovering reliable channels can be a challenge, so we will stick to three publicly available, widely used channels: bioconda, conda-forge and defaults.

Different channels can have the same package, so Conda must handle these channel collisions - it does this by maintaining a list of channel _priorities_. We will set Conda up to always use the three above channels (defaults is used by, well, _default_), and to always use them in the same order, to avoid any conflicts:

```bash
$ conda config --prepend channels conda-forge
$ conda config --prepend channels bioconda
$ conda config --set channel_priority strict
```

## Environments

A Conda environment is essentially a directory which contains a specific collection of Conda packages and all of their dependencies. This allows different environments to be maintained and run separately without interference from one another. The most important consequences of this, with respect to our management of software are the following:

- We can maintain separate installations of _different_ versions of the _same_ software
- By maintaining a list of the software in an environment, we can reinstall that environment using Conda on any computer, thus enabling process reproducibility.

It is good practise to set up and maintain a separate Conda environment for each project you work on, and to ensure you use Conda to manage all of the software in that project. It is then possible to create and maintain a _requirements_ file within that project, which can be used to re-install the environment if necessary.

### Exercise 3.4 {: .exercise}

Estimated time: 10 minutes

We're going to create an environment for the first module assessment, which will contain the software we need to complete the assessment, follow these steps:

- Add the conda-forge and bioconda channels to your Conda config by following the steps in the _Channels_ section, above
- Create a new, empty Conda environment called "assessment1":

```bash
$ conda create --name assessment1
```

- Activate your new environment:

```bash
$ conda activate assessment1
```

- Install the required software:

```bash
$ conda install blast emboss muscle
```

Finally, save the list of installed software so that we can reinstall the environment later if required:

```bash
$ conda list -e > requirements.txt
```

Move this file (`requirements.txt`) into the base directory of the project directories you created in Exercise 3.1.

# Version Control
