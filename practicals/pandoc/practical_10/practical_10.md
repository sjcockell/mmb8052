---
title: "MMB8052 - Practical 10"
author: "Simon J Cockell"
subject: "Bioinformatics Practical"
keywords: [Bioinformatics, Linux]
subtitle: ""
lang: "en"
titlepage: "true"
titlepage-text-color: "218ed0"
titlepage-rule-color: "218ed0"
titlepage-rule-height: 4
titlepage-background: "media/background.pdf"
toc: true
toc-own-page: "true"
...

# Heading 1

## Heading 2

Paragraph, with **bold** and _italics_. Code block rendered below.

```r
library(tidyverse)
dat <- read_tsv('file')
ggplot(dat, aes(x, y) + 
    geom_point(aes(color=col))
```

Another paragraph. Remember, single line
breaks don't produce carriage returns. A test for a footnote[^1] 

### Heading 3

Paragraph in a new section. Includes a link:
[rursus](https://sjcockell.me). Need to make these more obvious in the template.

A numbered list:

1. Item the first
2. Item the second
3. Iten the third

Similarly a bullet list:

- one
- two
- three

Math mode. Bit of raw latex. Might not be all that useful.

\begin{equation}\label{eq:neighbor-propability}
    p_{ij}(t) = \frac{\ell_j(t) - \ell_i(t)}{\sum_{k \in N_i(t)}^{} \ell_k(t) - \ell_i(t)}
\end{equation}

Now a blockquote. Quite nicely styled:

> Block quote until paragraph end. Can feature stuff like inline maths $\pi r^2$ 
and links.

  [^1]: This is a footnote...
