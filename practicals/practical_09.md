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

Also, genes do not function in isolation - and the context of the genes on a list, both functional and physical, is equally important. The ways in which 'function' can be defined for genes are diverse, however it is generally accepted that we can use some common annotation that defines an arbitrary notion of function, and look for over-representation of that annotation among our list of differentially expressed genes.

## The Hypergeometric Distribution

Suppose we have two lists of genes:

1. Genes differentially expressed in our experiment (N=200)
2. Genes found in organism of interest (N=20,000)

If we consider genes involved in the function "transcription activation" (for instance), we find the following:

1. 20 genes in list 1 have this annotation
2. 650 genes in list 2 have this annotation

What is the probability that we picked 20 genes with this annotation in list 1, given that list 2 contains 650 genes with this annotation?

The answer to this question is given by the hypergeometric distribution, a discrete probability distribution which describes the number of successes in a series of draws from a finite population without replacement (compare this with the binomial distribution, which describes the same but with replacement so that the probability of success at each draw is the same).

The hypergeometric distribution is often described in terms of an ‘urn model’ describing the number of white balls drawn without replacement from an urn which contains white and black balls. The R help page for the hypergeometric distribution uses this conceptualisation (see `?dhyper`). We can use a test against the hypergeometric distribution to determine whether the above annotation is statistically over-represented:

```r
# Urn contains m white balls and n black balls
# k balls are drawn without replacement , x of these are white
> dhyper(x = 20, m = 650, n = 19350, k = 200)
[1] 6.38656e-06
```

## The Gene Ontology (GO)

The Gene Ontology is a controlled vocabulary (CV) of terms for describing gene product characteristics and gene product annotation data. Actually, GO provides three controlled vocabularies, one each for _biological process_, _molecular function_ and _cellular component_ annotation. The terms from these CVs are attached to gene products by several mechanisms,
including expert annotation and inference from sequence similarity. If you work with a standard model organism, the chances are that the state of GO annotation is pretty good, so a lot of value can be had from over-representation analysis using the hyper-geometric test and the Gene Ontology.

## The Kyoto Encyclopaedia of Genes and Genomes (KEGG)

In many ways, the annotation available from the Kyoto Encyclopaedia of Genes and Genomes (KEGG) is similar to that in GO – functional annotation attached to genes. The KEGG database attempts to organize genes into biochemical pathways, rather than
the somewhat broader functional classifications found in GO. The data can be used in exactly the same way in conjunction with the hypergeometric test.

## The Molecular Signatures Database (MSigDB)

MSigDB is developed and distributed by the Broad Institute for use with their tool for analysing functional enrichment (called Gene Set Enrichment Analysis, or GSEA - more on this later). MSigDB is extremely extensive, cataloging 10s of 1000s of annotated gene sets, and it includes sets matching the databases already described above (particularly GO). In addition to these though, MSigDB contains gene sets which describe cell signatures and oncogenic processes, among others. A particularly useful group of gene sets is the so-called _hallmark_ gene sets, which are designed to describe well-defined biological states or processes. 

# clusterProfiler

The enrichment analysis described above is a generic strategy which is relatively easy to apply, and could be achieved using the base R hypergeometric functions (like `dhyper()`, as shown above). Why then, should we use a specialist package for this type of analysis? There are two main reasons for this, 1) the convenience of access to appropriate annotation; 2) good quality visualisations. The `clusterProfiler` Bioconductor package provides both of these things. 

## Gene Ontology Enrichment Analysis

`clusterProfiler` has a function for carrying out Gene Ontology enrichment analysis, `enrichGO()`. The inputs for this function are a list of differentially expressed genes, and an annotation database which enables the mapping of genes to GO terms. For our mouse experiment, we can use the Bioconductor annotation package `org.Mm.eg.db`:

```r
> install(c('clusterProfiler', 'org.Mm.eg.db'))
> library(clusterProfiler)
> library(org.Mm.eg.db)
> ego = enrichGO(enrichGO(gene=ens_gene_list,
                OrgDb = org.Mm.eg.db,
                keyType = 'ENSEMBL',
                ont = "CC",
                pAdjustMethod = "BH",
                pvalueCutoff = 0.01,
                qvalueCutoff = 0.05))
> head(ego)
```