# Checklist before public release

- [ ] Create a dedicated **private** GitHub repository; do not reuse unrelated repositories.
- [ ] Record all contributors and obtain permission for the code and derived artifacts.
- [ ] Verify GSE107894 sample labels against GEO metadata; audit biological pairing.
- [ ] Run `python scripts/validate_repository.py` successfully.
- [ ] Run `python scripts/compare_pathways.py` and `python scripts/make_figures.py`.
- [ ] Install R/edgeR and perform a **fresh, documented** MILES audit run.
- [ ] Confirm `results/recomputed/RUN_COMPLETE.txt` is present and inspect warnings.
- [ ] Explain any discrepancy with the archived partial results.
- [ ] Test historical edgeR version and sensitivity alternatives if feasible.
- [ ] Verify fibroblast donor and control-count provenance; rerun the GSEA pipeline.
- [ ] Review all public derived tables for third-party rights and potential sensitive data.
- [ ] Add provenance hashes and session information for newly generated results.
- [ ] Choose a code and data licensing approach with all contributors.
- [ ] Consider a preprint only after a full technical and scientific audit.
