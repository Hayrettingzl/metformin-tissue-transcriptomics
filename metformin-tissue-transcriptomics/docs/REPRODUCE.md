# Reproduction instructions

## 1. Validate included files (Python 3)

```bash
python scripts/validate_repository.py
```

## 2. Recompute summary and graphics from previously generated results

```bash
python -m pip install -r requirements-figures.txt
python scripts/compare_pathways.py
python scripts/make_figures.py
```

These commands run on the **archived output tables**; they do not rerun the
biological differential-expression or GSEA analysis.

## 3. R / edgeR rerun (separate, not performed during packaging)

Install R with a compatible Bioconductor `edgeR` version. For a historical
reproduction attempt, construct a separately pinned legacy environment and
record the output of `sessionInfo()`. The precise package environment of the
original study is not yet reproduced in this repository.

Download the GEO count file and place it at:

```
data/raw/GSE107894_GEO_Kulkarni_et_al_Metformin_counts.txt.gz
```

From the repository root run:

```bash
Rscript analysis/miles/run_edger_audit.R .
```

The script writes all output files to `results/recomputed/`. Inspect
`MODEL_COMPARISON.csv`, `LIBRARY_AND_TMM_QC.csv`, `sessionInfo.txt`, and
`RUN_COMPLETE.txt`. If `RUN_COMPLETE.txt` is missing, the rerun is **incomplete**.
The two technical-record models must never be interpreted as inferential
biological validation.

## 4. Run the missing historical sensitivity checks

- Finish the missing adipose technical-record diagnostic.
- Audit visit/treatment coding and participant pairing against source GEO metadata.
- Test the literal and alternate CPM filter definitions separately.
- Investigate tagwise dispersion and original edgeR 3.18.1 behaviour.
- Ask the publication's authors for their input matrix and original model design.
- Validate fibroblast donor/time modelling and the source count matrices.

Do not promote the repository from pre-release until all required items in
`docs/RELEASE_CHECKLIST.md` have been reviewed.
