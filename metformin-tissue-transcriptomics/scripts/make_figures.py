#!/usr/bin/env python3
"""Descriptive figures only; inputs are previously generated, provisional output tables."""
from pathlib import Path
import pandas as pd
import matplotlib.pyplot as plt

ROOT=Path(__file__).resolve().parents[1]
OUT=ROOT/'figures';OUT.mkdir(parents=True,exist_ok=True)


def deg_figure():
    fig,ax=plt.subplots(figsize=(8.6,4.7))
    names=['Muscle: biological sample', 'Adipose: biological sample',
           'Muscle: technical record (diagnostic only)']
    counts=[0,17,680]
    y=range(3)
    bars=ax.barh(y,counts)
    ax.set_yticks(list(y),names);ax.invert_yaxis()
    ax.set_xlabel('BH-FDR < 0.05 genes (archived partial outputs)')
    ax.set_title('MILES sensitivity to the unit of analysis')
    ax.set_xlim(0,780)
    for b,n in zip(bars,counts):ax.text(n+12,b.get_y()+b.get_height()/2,str(n),va='center')
    fig.text(0.02,0.015,'Technical-record fit is methodologically invalid for independent biological inference. Fat diagnostic missing.',fontsize=8)
    fig.tight_layout(rect=(0,0.04,1,1))
    fig.savefig(OUT/'miles_unit_of_analysis.png',dpi=170,bbox_inches='tight')
    plt.close(fig)


def pathway_figure():
    d=pd.read_csv(ROOT/'results/exploratory_pathways/selected_pathways_summary.csv')
    paths=['HALLMARK_OXIDATIVE_PHOSPHORYLATION','HALLMARK_UV_RESPONSE_DN','HALLMARK_TNFA_SIGNALING_VIA_NFKB','HALLMARK_TGF_BETA_SIGNALING']
    tissues=['muscle','adipose','fibroblast']
    mat=d.pivot(index='pathway',columns='tissue',values='NES').loc[paths,tissues]
    fig,ax=plt.subplots(figsize=(8.9,4.8))
    x=range(len(paths));width=.24
    for j,t in enumerate(tissues):
        ax.bar([k+width*(j-1) for k in x],mat[t],width,label=t.capitalize())
    ax.axhline(0,linewidth=.8)
    ax.set_xticks(list(x),['OXPHOS','UV response DN','TNFα/NF-κB','TGF-β'])
    ax.set_ylabel('Archived Hallmark normalized enrichment score (NES)')
    ax.set_title('Exploratory pathways: different studies and contrasts')
    ax.legend(loc='upper left',ncol=3,frameon=False)
    fig.text(0.02,0.015,'Descriptive comparison only. Different studies and estimands; negative NES is not an adverse-effect diagnosis.',fontsize=8)
    fig.tight_layout(rect=(0,0.05,1,1))
    fig.savefig(OUT/'exploratory_hallmark_nes.png',dpi=170,bbox_inches='tight')
    plt.close(fig)


if __name__=='__main__':
    deg_figure();pathway_figure()
    print('Wrote figures/miles_unit_of_analysis.png and figures/exploratory_hallmark_nes.png')
