For example, base R contains functions for basic statistics calculated with vectors, but only rudimentary functions for working with matrices (base functions include `rowSums` and `rowMeans`, and the equivalent functions for columns). The installable package `matrixStats`, however, adds a range of other functions which can be applied to a matrix to further understand the data therein:

```r
> install.packages("matrixStats")
> x = matrix(rnorm(200), nrow=20)
> rowSums(x)
> rowMeans(x)
> rowSds(x)
Error in rowSds(x) : could not find function "rowSds"
> library(matrixStats)
> rowSds(x)
```

In this code block, we first make a matrix of some normally distributed data. Although we've installed the `matrixStats` package in the first line, the function `rowSds`, which calculates the row-wise standard deviations, is not available to us until we _attach_ it to our R session, which we accomplish with the `library()` function. After this line, we can use `rowSds()` to calculate the standard deviation of the rows of our matrix.

# Tidyverse

The [_Tidyverse_](https://www.tidyverse.org/) is set of packages available through CRAN. It describes itself as “an opinionated collection of R packages designed for data science”. Components of the Tidyverse provide convenient methods for reading, writing, visualising and organising data. The core Tidyverse consists of eight packages: `ggplot2`, `tibble`, `tidyr`, `readr`, `purrr`, `stringr`, `forcats` and `dplyr`. These packages can be installed via a conventient _metapackage_ called `tidyverse`:

```r
> install.packages("tidyverse")
```

## Tidy Data

While we're not going to spend a lot of time on the satellite packages of the Tidyverse, we are going to take a detailed look at visualising data with `ggplot2`, so it can be helpful to understand what the authors of the Tidyverse mean when they talk about _tidy data_. For a simple dataset to be considered tidy, it needs to be arranged in a particular way, so that every row in the dataset contains a single observation, with any additional data required to qualify or understand that observation recorded alongside it in the same row. This is often described as _long format_ data. We are often more used to _wide format_ data, the difference is shown in the tables below.

First, the more familiar wide format:

|            | Sample 1 | Sample 2 | Sample 3 | Sample 4 | Sample 5 | Sample 6
|------------|----------|----------|----------|----------|----------|---------
| **Gene A** | 0.718    | 1.221    | 0.086    | 0.079    | 1.136    | 0.914
| **Gene B** | 0.483    | 0.524    | 0.523    | 0.083    | -0.527   | -1.208
| **Gene C** | -0.444   | 0.641    | -1.432   | -0.266   | -0.049   | 1.372
| **Gene D** | 1.058    | -1.087   | 0.091    | 1.731    | -0.699   | -0.756
| **Gene E** | -0.103   | -1.309   | 2.212    | -0.731   | 0.719    | -0.289
| **Gene F** | -0.074   | -1.511   | -0.319   | 0.373    | -0.760   | -0.984

Here, each observation occupies a cell in the table, and any _metadata_ is restricted to the row and column names.

The same data, encoded in long format:

| Sample | Gene | Value |
|--------|------|-------|
| 1 | A | 0.718   |
| 1 | B | 0.483   |
| 1 | C | -0.444  |
| 1 | D | 1.058   |
| 1 | E | -0.103  |
| 1 | F | -0.074  |
| 2 | A | 1.221   |
| 2 | B | 0.524   |
| 2 | C | 0.641   |
| 2 | D | -1.087  |
| 2 | E | -1.309  |
| 2 | F | -1.511  |
| 3 | A | 0.086   |
| 3 | B | 0.523   |
| 3 | C | -1.432  |
| 3 | D | 0.091   |
| 3 | E | 2.212   |
| 3 | F | -0.319  |
| 4 | A | 0.079   |
| 4 | B | 0.083   |
| 4 | C | -0.266  |
| 4 | D | 1.731   |
| 4 | E | -0.731  |
| 4 | F | 0.373   |
| 5 | A | 1.136   |
| 5 | B | -0.527  |
| 5 | C | -0.049  |
| 5 | D | -0.699  |
| 5 | E | 0.719   |
| 5 | F | -0.760  |
| 6 | A | 0.914   |
| 6 | B | -1.208  |
| 6 | C | 1.372   |
| 6 | D | -0.756  |
| 6 | E | -0.289  |
| 6 | F | -0.984  |

The advantage of having the data arranged in this way is that we can trivially add extra information to each observation and maintain the same format. For example, if samples 1-3 were "wild-type" and samples 4-6 were "mutant" we could add an additional _genotype_ column to the long data to store this information. In the case of wide data, you would typically have to create a second data frame which contained this information about the columns (and likewise for the rows).

It is possible to turn a wide matrix into a long data frame using the `tidyr` package, which contains a function called `pivot_longer()`. Note that for this to work properly, the rownames of our matrix must be a column in their own right, meaning that the conversion becomes a bit of a shuffle.

```r
> library(tidyverse)
# make some data first:
> dat = matrix(rnorm(36), nrow=6)
# now name the rows and columns:
> colnames(dat) = paste0('sample_', 1:6)
> rownames(dat) = paste0('gene_', LETTERS[1:6])
# turn it into a data.frame:
> dat = as.data.frame(dat)
# add the row.names as a column:
> dat = rownames_to_column(dat, var="Gene")
# now pivot_longer:
> dat_long = pivot_longer(dat, cols=starts_with("sample"))
```

This is a realistic set of operations in R, and it is common to have to perform these kind of rearrangements in any real data analysis. Collectively this is known as data _munging_ or _wrangling_.

Another thing to note here: the output of `pivot_longer()` is a `tibble`. This is a special type of `data.frame` introduced in the Tidyverse. Tibbles have some features added for convenience, but can mostly be treated like a data frame. In instances where they can't, you can turn a tibble back into a data frame using the `as.data.frame()` function (which, as demonstrated above, also works with a matrix).

## readr

## dplyr

## ggplot2
