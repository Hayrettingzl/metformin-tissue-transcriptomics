# Metformin across human tissues: exploratory transcriptomic comparisons and a MILES reproducibility audit

**Project status: research work in progress / pre-release.**  This repository curates
existing computational analyses of publicly available metformin-response datasets.
No metformin treatment experiment was conducted by this repository's contributors.
Results have **not** been independently re-executed end-to-end for this release,
and no causal adverse drug effect is demonstrated.

## Research questions

1. Do preranked gene-set enrichment patterns show any concordance among **skeletal muscle,
   subcutaneous adipose tissue, and cultured fibroblasts** exposed to metformin in
   different studies? Which patterns are robust to experimental differences?
2. Why do differential-expression results obtained after aggregating technical
   sequencing records by biological sample differ substantially from the reported
   MILES 2018 gene lists?

These are **different analyses** with different evidentiary strengths. We do not
pool samples across studies or treat cultured cells and human biopsies as directly
comparable experiments.

## Data sources

| Source | Material | Access |
|---|---|---|
| Kulkarni et al. (2018), *Aging Cell*, DOI 10.1111/acel.12723 | Human muscle and adipose RNA-seq (MILES) | [GEO GSE107894](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE107894) |
| E-MTAB-16089 | Cultured human fibroblast transcriptomic experiment | [BioStudies](https://www.ebi.ac.uk/biostudies/arrayexpress/studies/E-MTAB-16089) |

## Verified from the archived local output files

| MILES model | Tested genes | FDR < 0.05 | Status |
|---|---:|---:|---|
| Muscle, biological-sample level | 18,955 | 0 | Completed in archived partial run |
| Fat, biological-sample level | 21,011 | 17 | Completed in archived partial run |
| Muscle, sequencing-record level | 20,745 | 680 | **Diagnostic only; not an acceptable independent-biological-replicate analysis** |
| Fat, sequencing-record level | — | — | **Missing: not completed in archived run** |

The 2018 paper reports **647 muscle and 146 adipose** significant DEGs. The marked
similarity between publication values and a sequencing-record-level diagnostic is
an **unresolved methodological observation**, not proof of an error by the authors.
An archival summary is at `results/archived_partial/model_summary.csv`.

## Exploratory pathways

Previously generated preranked Hallmark results are in
`results/exploratory_pathways/`. In all three archived output tables,
`HALLMARK_OXIDATIVE_PHOSPHORYLATION` has a negative normalized enrichment score.
The comparison remains exploratory: dose, exposure, tissue context, study design,
and statistical estimands differ. **Negative enrichment is not evidence of harm.**

## What can actually be reproduced?

- `analysis/miles/run_edger_audit.R`: a four-model R script based on the archived
  analysis code. **Not executed in the preparation environment**; requires R
  and `edgeR` and the GEO count file. The technical-record models are clearly
  labeled as diagnostics.
- `scripts/validate_repository.py`: checks the bundled metadata, result
  inventory and model counts.
- `scripts/compare_pathways.py`: recomputes the three-tissue comparison table
  from bundled archived GSEA output, without re-running GSEA.
- `scripts/make_figures.py`: regenerates the descriptive figures from the
  curated tables. Figures must **not** be interpreted as independent replication.

See [Reproduction instructions](docs/REPRODUCE.md), [methods](docs/METHODS.md),
[limitations](docs/LIMITATIONS.md), and [results](docs/FINDINGS.md).

## Acknowledgment and attribution

The primary RNA-seq data and published differential-expression results come from
Kulkarni and colleagues, not this repository. The experimental fibroblast dataset
is an independent public study. This repository reports computational reanalyses;
it does not claim to have collected, generated, or treated the biological samples.

**No software license has yet been selected.** Please obtain contributor consent
before selecting a license or publicly distributing any third-party-derived material.
