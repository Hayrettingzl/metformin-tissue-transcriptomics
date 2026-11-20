#!/usr/bin/env python3
"""Audit inventory of public metadata/archived outputs. This does NOT validate edgeR fits."""
import csv
from collections import Counter,defaultdict
from pathlib import Path

ROOT=Path(__file__).resolve().parents[1]

def read_rows(p):
    with (ROOT/p).open(newline='',encoding='utf-8-sig') as f:
        return list(csv.DictReader(f))

def check(condition, text):
    if not condition:
        raise AssertionError(text)
    print('[OK]',text)

def main():
    rows=read_rows('data/metadata/miles_sample_technical_replicate_map.csv')
    check(len(rows)==100,'100 sequencing-record identifiers')
    check(len({r['technical_column'] for r in rows})==100,'100 unique sequencing-record identifiers')
    by_tissue=defaultdict(list)
    for r in rows:
        if not all(r[k] for k in ['technical_column','biological_sample','participant','visit','treatment','tissue']):
            raise AssertionError(f'Missing metadata row: {r}')
        by_tissue[r['tissue']].append(r)
    check(set(by_tissue)=={'Mus','Fat'},'expected tissues only')
    check(len(by_tissue['Mus'])==57,'57 muscle sequencing-record columns')
    check(len(by_tissue['Fat'])==43,'43 adipose sequencing-record columns')
    check(len({r['biological_sample'] for r in by_tissue['Mus']})==27,'27 muscle biopsies')
    check(len({r['biological_sample'] for r in by_tissue['Fat']})==28,'28 adipose biopsies')
    for tissue,rs in by_tissue.items():
        sample_fields=defaultdict(set)
        for r in rs:
            sample_fields[r['biological_sample']].add((r['participant'],r['visit'],r['treatment'],r['tissue']))
        check(all(len(x)==1 for x in sample_fields.values()),f'{tissue} biological-sample metadata internally consistent')
    models=read_rows('results/archived_partial/model_summary.csv')
    check(len(models)==4,'partial archive has four model-status rows')
    found={(r['model'],r['status']):r for r in models}
    expected={'Mus__biological_sample':(18955,0),'Mus__technical_lane_DIAGNOSTIC_ONLY':(20745,680),'Fat__biological_sample':(21011,17)}
    for key,(ng,nd) in expected.items():
        r=found[key,'OK']
        check(int(r['n_tested'])==ng and int(r['n_deg'])==nd,f'archived {key} count values match')
        check((ROOT/'results/archived_partial'/f'{key}__PUBLISHED_GENES.csv').is_file(),f'{key} archived comparison exists')
    check(found['Fat__technical_lane_DIAGNOSTIC_ONLY','MISSING']['n_tested']=='',
          'adipose sequencing-record diagnostic is declared missing')
    for tissue in ('Mus','Fat'):
        rs=read_rows(f'data/references/published_vs_ours_{tissue}.csv')
        check(len(rs)==(647 if tissue=='Mus' else 146),f'{tissue} derived publication match input size')
    for tissue in ('muscle','adipose','fibroblast'):
        rs=read_rows(f'results/exploratory_pathways/{tissue}_hallmark_gsea.csv')
        check(len(rs)==50,f'{tissue} archived Hallmark pathways: 50')
    print('PASS: curated source-file integrity checks only. Not an independent statistical reproduction.')

if __name__=='__main__':main()
