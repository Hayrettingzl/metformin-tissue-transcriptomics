# Input data and provenance

## MILES (human biopsies)

- Study: Kulkarni et al., *Aging Cell* (2018),
  https://doi.org/10.1111/acel.12723.
- GEO accession: [GSE107894](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE107894).
- Required downloaded file name: `GSE107894_GEO_Kulkarni_et_al_Metformin_counts.txt.gz`.
- `data/metadata/miles_sample_technical_replicate_map.csv`:
  prior-work mapping of 100 public GEO sequencing columns to participant,
  visit, treatment, tissue, and biological sample. Re-audit against GEO metadata
  before a new release.
- `data/references/published_vs_ours_Mus.csv` and `..._Fat.csv`:
  derived minimal matches to supplementary publication values from a
  previously prepared audit. These are not the primary supplemental tables.
- `results/archived_partial/`: only outputs actually present in the
  previously supplied `RESULTS_ROOT_CAUSE.zip`, plus a separately calculated
  partial-model summary. The missing fourth model is not backfilled.

## Fibroblasts

- Public accession: [E-MTAB-16089](https://www.ebi.ac.uk/biostudies/arrayexpress/studies/E-MTAB-16089).
- `results/exploratory_pathways/fibroblast_hallmark_gsea.csv`:
  copied from earlier `MILES_2018_CPM_Dispersiyon_DUZELTILMIS.zip` and originally
  labelled `fibroblast_4donor_GSEA.csv`.
- `muscle_hallmark_gsea.csv` and `adipose_hallmark_gsea.csv`:
  copied respectively from `Mus_fractional_GSEA.csv` and
  `Fat_fractional_GSEA.csv` in the same earlier archive.
- These are derived output tables, **not** the raw E-MTAB-16089 experiments.

## No personal participant data collection

The archived public pseudonymous participant labels were already present in
study data. Do not add identifying records, unpublished clinical identifiers,
or consent-restricted files to this repository.
