# Findings: strictly provisional and source-traceable

The numerical statements below refer to **previously generated output files**
that were available when this repository was curated. They are not results of a
new experiment and were not independently recomputed for this release.

## MILES audit (as of 19 November 2026)

| Model | Genes tested | BH-FDR < 0.05 | Median tagwise dispersion |
|---|---:|---:|---:|
| Muscle biological sample | 18,955 | 0 | 0.1821 |
| Muscle technical record (diagnostic) | 20,745 | 680 | 0.1623 |
| Adipose biological sample | 21,011 | 17 | 0.1401 |
| Adipose technical record (diagnostic) | not available | not available | not available |

In the archived muscle sequencing-record diagnostic, 596 publication-listed
genes were significant and the published-vs-reanalysis log2 fold-change Pearson
correlation was approximately 0.99976. For biological-sample muscle analysis,
there were zero BH-FDR significant genes. Published article totals (647 muscle,
146 adipose) are **not** reproduced under the above biological-sample model.
The archived run has no `RUN_COMPLETE.txt` and must be labelled **partial**.

The resemblance of the invalid technical-record diagnostic to publication
statistics is a hypothesis-generating signal, not sufficient to establish
that the published model used pseudoreplicates. Ask the authors for the exact
input count matrix, sequencing-repeat handling and original edgeR scripts.

## Exploratory three-tissue Hallmark analysis

The curated pathway values are in
`results/exploratory_pathways/selected_pathways_summary.csv` and come from
**three precomputed GSEA tables**, not a newly re-run GSEA. OXPHOS was negative
in the three archived output tables, and selected UV_RESPONSE_DN and
TNFA_SIGNALING_VIA_NFKB rows had positive NES values. These may be worthwhile
targets for a rigorously harmonized, independent future analysis.

`NES < 0` must **not** be equated with cellular injury, reduced mitochondrial
capacity or an adverse drug reaction without functional evidence.
