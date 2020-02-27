# Differential Comparison

This step of analysis performs a statistical comparison of the difference in the expression level of each human reference genes represented as the counts of uniquely aligned sequence reads between a drug-treated condition and the control condition. At a given false discovery rate (FDR), such comparison generates a set of differentially expressed genes (DEGs) induced by a drug treatment to a sample and is carried out for all the drugs and all the cell lines.

**Note:**

- The `[Type]` tag included in the file and directory names below refers to either `Conv` for conventional sequence data or `DGE` for 3'-DGE sequence data.
- The `[Set]` and `[Subset]` tags refer to [Analyzing 3'-DGE Random-Primed mRNA-Sequencing Data](https://github.com/DToxS/DGE-GEO-Depot) and they only apply to `DGE` type of sequence data where multiple `[Set]` of datasets are available.

## Inputs

The inputs of this analysis include:

- The gene read-counts table `[Type]-RNAseq-Read-Counts-[Set]-[Subset].tsv` in the `Counts` sub-directory of each `[Set]` of dataset directory under the corresponding `[Type]-GEO-Depot` top directory.
- The experiment design table `[Type]-RNAseq-Experiment-Design-[Set]-[Subset].tsv` in the `Counts` sub-directory of each `[Set]` of dataset directory under the corresponding `[Type]-GEO-Depot` top directory.
- The configuration file `[Type]-RNAseq-Configs-[Set]-[Subset].tsv` in the `Configs` sub-directory of each `[Set]` of dataset directory under the corresponding `[Type]-GEO-Depot` top directory.
- The parameter files `[Type]-RNAseq-Drug-Groups-[Set]-[Subset].tsv` and `[Type]-RNAseq-Outlier-Cutoffs-[Set]-[Subset].tsv` in the `Params` sub-directory of each `[Set]` of dataset directory under the corresponding `[Type]-GEO-Depot` top directory.

## Procedure

The procedure of this analysis includes the following steps:

1. Set the variable `DATASET_DIR` in `Programs/Differential-Comparison/Compare-[Type]-Expr-Diffs.GEO.sh` to the absolute path of the `[Type]-GEO-Depot` top directory, and launch the program to compare the gene expression levels and identify the DEGs at each drug-treated conditions in each cell line.


## Outputs

The outputs of this analysis include:

- A single set or multiple sets of statistical comparison result files for the DEGs identified at all drug treatments and in all cell lines with a file name pattern of `Human-[Cell Line]-Hour-48-Plate-[Plate Number]-Calc.CTRL-[Drug Name].tsv`. The single set of DEG statistical results is generated from a single `Conv` sequence dataset and located at the `Results/FDR-[Value]` directory under the `Conv-GEO-Depot` top directory, while the multiple sets of DEG statistical results are generated from multiple `DGE` sequence datasets and located at the `Results/FDR-[Value]` sub-directory of each `[Set]` of dataset directory under the `DGE-GEO-Depot` top directory.
