#!/usr/bin/env python3
"""Summarize selected pathways from previously archived GSEA tables; does not rerun GSEA."""
import csv
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
PATHWAYS = (
    "HALLMARK_OXIDATIVE_PHOSPHORYLATION",
    "HALLMARK_UV_RESPONSE_DN",
    "HALLMARK_TNFA_SIGNALING_VIA_NFKB",
    "HALLMARK_TGF_BETA_SIGNALING",
)
TISSUES = ("muscle", "adipose", "fibroblast")


def main():
    out = []
    for tissue in TISSUES:
        f = ROOT / "results" / "exploratory_pathways" / f"{tissue}_hallmark_gsea.csv"
        with f.open(newline="", encoding="utf-8-sig") as handle:
            rows = list(csv.DictReader(handle))
        by_name = {r["pathway"]: r for r in rows}
        if len(by_name) != len(rows):
            raise ValueError(f"Duplicate pathways in {f}")
        for path in PATHWAYS:
            if path not in by_name:
                raise ValueError(f"Missing pathway {path} in {f}")
            r = by_name[path]
            out.append({"tissue": tissue, "pathway": path,
                        "NES": float(r["NES"]), "padj": float(r["padj"]),
                        "source_table": f.name,
                        "evidence_status": "exploratory_precomputed_not_rerun"})
    dest = ROOT / "results" / "exploratory_pathways" / "selected_pathways_summary.csv"
    with dest.open("w", newline="", encoding="utf-8") as handle:
        w = csv.DictWriter(handle, fieldnames=out[0].keys())
        w.writeheader();w.writerows(out)
    print(f"Wrote {len(out)} tissue/pathway rows to {dest}")


if __name__ == "__main__":
    main()
