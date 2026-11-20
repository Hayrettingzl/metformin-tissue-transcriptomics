# Methods and analysis provenance

## MILES differential expression

The original human MILES experiment is available as GEO GSE107894. The archived
count matrix has 100 sequencing-record columns, corresponding to 27 muscle and
28 adipose biological samples; some biopsies have multiple sequencing records.
The provided metadata table contains 57 muscle and 43 adipose sequencing-record
columns. These are **not** 100 independent biological specimens.

**Biological-sample analysis:** sum per-gene raw counts from sequencing records
belonging to the same biopsy; fit a paired/crossover design with factors for
participant, visit and metformin treatment, separately by tissue. The bundled
script runs edgeR negative-binomial GLMs with TMM normalization, likelihood-ratio
tests and Benjamini-Hochberg FDR.

**Filter used in the archived partial run:** CPM >= 1 in at least two columns.
This is one plausible sensitivity-model interpretation, *not a certified
reconstruction of the authors' original filtering choice.*

**Technical-record analysis:** identical family of models but with each
sequencing-record column represented separately. This neglects within-biopsy
correlation and is retained **only** to probe a possible explanation for the
published-versus-biological-sample discrepancy. **Its DEG calls must not be used
as evidence of biological treatment effects.**

## Published-gene comparison

The external published DEG lists are from the cited 2018 supplemental material.
The previously generated `published_vs_ours_{Mus,Fat}.csv` tables in
`data/references/` contain a minimal, derived matching table (not the entire
journal supplement). Only records with unambiguous matching were compared.
Archived result tables in `results/archived_partial/` reflect prior execution;
we have not rerun edgeR during packaging.

## Fibroblast pathway context

The precomputed fibroblast file was obtained from a previous **four-donor**
analysis package. Muscle and adipose Hallmark outputs were similarly imported
from a prior analysis archive. They have different contrasts, exposure conditions,
modelling histories, and gene universes. No direct differential expression
comparison or causal cross-tissue conclusion is made in this curated release.

The Python summarizer performs table selection and formatting only. It **does not
recompute GSEA**, validate the upstream donor model, or resolve the documented
inconsistencies among prior fibroblast count-processing inputs.

## Integrity checks

The repository's validation script checks identifiers and counts in the metadata
and archived output summary; does not verify edgeR estimates or inferential
assumptions. R and edgeR versions, session information, design rank and complete
model artifacts should be recorded by a future full rerun.
