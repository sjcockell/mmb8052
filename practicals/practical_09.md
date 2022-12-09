# MMB8052 Practical 09 - Case Study IV: Downstream Gene List Analysis

# Introduction

Lists of genes that change expression are of limited value taken on their own. Functional context is important for interpreting these findings, and can be added to lists of genes in a number of ways. We can look at expression patterns and group genes that vary in similar ways across our experiment. Clustering algorithms will find groups of genes that fulfil these criteria, and heatmaps give us a popular and usable way to visualize this kind of data. We can also exploit functional annotation that has been added to the gene databases of many organisms by both manual and automatic curation procedures. Examining gene lists for classes of annotation that are statistically overrepresented is a common way of ascribing functional importance to an otherwise hard to interpret list of genes.

It should be noted that this type of analysis is not restricted to the results of a transcriptomics experiment - overrepresentation analysis in particular can be applied in any analysis scenario where the end product is a list of genes identified by some selective process. 

For the purposes of this practical, we will be picking up from where we left off in practical 8 - with the results of a `DESeq2` analysis of GSE116583 - an experiment looking at the gene expression changes associated with reperfusion in donor alveolar macrophages following murine lung transplant. 

# Clustering and Heatmaps

## Clustering Algorithms

The goal of cluster analysis with RNA-Seq data is to group genes into clusters with similar profiles. The genes are assigned into clusters based on a dissimilarity measure (usually correlation or distance based). There are a number of algorithms for achieving this aim, they vary in their approach to the problem, but knowing which algorithm is best for the data being analysed is rarely simple.

## Hierarchical Clustering

Hierarchical clustering is an agglomerative (“bottom-up”) approach where each gene starts in its own cluster (n genes, n clusters). The most similar genes according to a similarity metric (such as Euclidian distance) are merged (n genes, n-1 clusters), then the similarity metric is recalculated between the genes and this new cluster. This process is repeated iteratively until all genes are in a single cluster (1 cluster, of size n). Hierarchical clustering is implemented by the `hclust` function of the `stats` package in R and uses the output produced by the `dist` function.

To cluster all genes in the count matrix (over 36000) would take a lot of computational resources and time because `dist` and `hclust` will cluster by the rows of a matrix. However, we can cluster by the columns to obtain a clustering by samples by transposing the expression matrix using the `t()` function, an operation which flips a matrix about its diagonal so that the columns become rows and the rows become columns.

## Heatmaps

Heatmaps are a particularly useful post-analysis tool for visualising clusters in the genes that we know to be differentially expressed. The CRAN package `pheatmap` has a function `pheatmap()` that takes a numeric matrix as input. `pheatmap` applies hclust to cluster the rows and/or columns of the matrix, then displays a false colour image with dendrograms added to the left side and/or the top.

# Enrichment Analysis

There are a number of reasons why we may want to consider the function of the genes in a gene list over and above the simple identification of the genes. Amongst these is the tendency for people to focus on those genes they recognize, and already suspect are interesting, at the expense of other unknown genes on the list that may be equally or more important.

Also, genes do not function in isolation - and the context of the genes on a list, both functional and physical, is equally important. The ways in which ‘function’ can be defined for genes are diverse, however it is generally accepted that we can use some common annotation that defines an arbitrary notion of function, and look for over-representation of that annotation among our list of differentially expressed genes.