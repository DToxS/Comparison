# Differential Comparison

This analysis performs a statistical comparison of the difference in the expression level of each human reference genes represented as the counts of uniquely aligned sequence reads between a drug-treated condition and the control condition. At a given false discovery rate (FDR), such comparison generates a set of differentially expressed genes (DEGs) induced by a drug treatment to a sample and is carried out for all the drugs and all the cell lines.

## Inputs

The inputs of this analysis include:

- The gene read-counts table `Conv-RNAseq-Read-Counts.tsv` in the `Counts` directory.
- The experiment design table `Conv-RNAseq-Experiment-Design.tsv` in the `Counts` directory.
- The configuration file `Conv-RNAseq-Configs.tsv` in the `Configs` directory.
- The parameter files `Conv-RNAseq-Drug-Groups.tsv` and `Conv-RNAseq-Outlier-Cutoffs.tsv` in the `Params` directory.

## Procedure

The procedure of this analysis includes the following steps:

1. Compare the gene expression levels and identify the DEGs at each drug-treated conditions in each cell line, by running `Programs/Differential-Comparison/Run-Compare-Molecule-Expression.sh`.


## Outputs

The outputs of this analysis include:

- A set of data files of differential comparison results in the `Results` directory with a file name pattern of `Human-[Cell Line]-Hour-48-Plate-[Plate Number]-Calc.CTRL-[Drug Name].tsv`.

