# Limitations and claim boundaries

1. **No experimental metformin treatment was conducted for this GitHub project.**
   All numerical work is secondary analysis of public study data.
2. **The underlying studies differ.** Fibroblast cultures and human biopsies
   have different doses, durations, cell mixtures, patient backgrounds and
   modelling estimands; overlapping gene sets do not identify a causal tissue
   effect by themselves.
3. **Technical sequencing records are not independent biological replicates.**
   Analyses treating them as independent have pseudoreplication risk and must
   be described only as methodological diagnostics.
4. **The MILES audit is incomplete.** There are only three of the intended four
   archived model results, no archived full-run completion marker, and no
   independent rerun in the preparation environment.
5. **Published/derived gene matching is not universal.** A subset of published
   identifiers could not be matched unambiguously; published totals can include
   repeated identifiers. We do not change thresholds to force agreement.
6. **The original edgeR version was not rerun.** Archived diagnostics used an
   edgeR workflow, but R 3.4.0/edgeR 3.18.1 version-specific reproduction still
   needs to be performed, along with filtering and dispersion sensitivity tests.
7. **Fibroblast preprocessing remains under review.** Earlier pilot notes
   reported non-identical count values for nominally shared control columns
   across upstream files. The four-donor GSEA file is included for exploratory
   comparison, not declared fully independently validated.
8. **Pathway activity does not equal phenotypic effect.** A negative normalized
   enrichment score is not direct proof of impaired function or adverse effects.
9. **Do not use archived tables to imply new statistical inference.** Plotting,
   CSV manipulation and table comparisons do not replace a rerun of upstream
   differential expression and gene-set tests.
10. **Source rights must be respected.** Reuse official dataset links and
    properly cite study authors. This package excludes copyrighted journal PDFs
    and full source count matrices.
