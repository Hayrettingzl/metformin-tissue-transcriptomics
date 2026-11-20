# MILES / Kulkarni 2018: sample aggregation versus technical-lane diagnostic
# IMPORTANT: Treating technical sequencing replicates as independent observations
# is NOT a scientifically valid primary analysis. It is run ONLY to diagnose
# whether such handling might explain the publication-vs-reanalysis discrepancy.
#
# Run from project root:
#     Rscript analysis/miles/run_edger_audit.R .
# Requires edgeR. This script was adapted from prior local source code;
# it has NOT been rerun in the repository-preparation environment.

suppressPackageStartupMessages(library(edgeR))
args <- commandArgs(trailingOnly=TRUE)
if (length(args) > 1L) stop('Usage: Rscript analysis/miles/run_edger_audit.R [repo_root]')
base_dir <- if (length(args)==1L) args[[1L]] else getwd()
base_dir <- normalizePath(base_dir,winslash='/',mustWork=TRUE)
required <- c(
  'data/raw/GSE107894_GEO_Kulkarni_et_al_Metformin_counts.txt.gz',
  'data/metadata/miles_sample_technical_replicate_map.csv',
  'data/references/published_vs_ours_Mus.csv',
  'data/references/published_vs_ours_Fat.csv')
missing_files <- required[!file.exists(file.path(base_dir,required))]
if (length(missing_files)) stop('Missing inputs: ', paste(missing_files,collapse=', '),
                                '\nFolder: ', base_dir)
output <- file.path(base_dir, 'results', 'recomputed')
dir.create(output,recursive=TRUE,showWarnings=FALSE)
complete_file <- file.path(output,'RUN_COMPLETE.txt')
if (file.exists(complete_file)) unlink(complete_file)
writeLines(c('STARTED',as.character(Sys.time()),
             paste0('edgeR=',as.character(packageVersion('edgeR'))),
             paste0('R=',getRversion())),file.path(output,'RUN_STARTED.txt'))

cat('MILES ROOT-CAUSE REPRODUCIBILITY AUDIT\n')
cat('Base folder:',base_dir,'\n')
cat('R version:',as.character(getRversion()),' edgeR:',as.character(packageVersion('edgeR')),'\n')
cat('The technical-lane model is for DIAGNOSTIC PURPOSES ONLY.\n\n')

raw <- read.delim(gzfile(file.path(base_dir,required[1])),
                  check.names=FALSE,stringsAsFactors=FALSE, quote='', comment.char='')
stopifnot(nrow(raw)==60554L, ncol(raw)==102L, !anyDuplicated(raw[[1]]))
feature_ids <- as.character(raw[[1]])
tech_counts <- as.matrix(raw[,-c(1,2),drop=FALSE])
storage.mode(tech_counts) <- 'numeric'
rownames(tech_counts) <- feature_ids
stopifnot(ncol(tech_counts)==100L,all(is.finite(tech_counts)),all(tech_counts>=0))
map <- read.csv(file.path(base_dir,required[2]),
                check.names=FALSE,stringsAsFactors=FALSE)
stopifnot(nrow(map)==100L,!anyDuplicated(map$technical_column),
          setequal(map$technical_column,colnames(tech_counts)))
map <- map[match(colnames(tech_counts),map$technical_column),,drop=FALSE]
stopifnot(identical(as.character(map$technical_column),colnames(tech_counts)))

create_design <- function(m) {
  m$participant <- factor(m$participant)
  m$period <- factor(m$visit,levels=c('V1','V2'))
  m$treatment <- factor(m$treatment,levels=c('Pla','Met'))
  if (anyNA(m[,c('participant','period','treatment')])) stop('Missing metadata')
  x <- model.matrix(~participant+period+treatment,data=m)
  if (qr(x)$rank != ncol(x)) stop('Nonfull rank design')
  if (!('treatmentMet' %in% colnames(x))) stop('No treatmentMet coefficient')
  x
}

summary_list <- list()
ref_list <- list()
qc_list <- list()
all_fit <- list()
n_summary <- 0L; n_ref <- 0L; n_qc <- 0L

for (tissue in c('Mus','Fat')) {
  in_tissue <- map$tissue==tissue
  lane_metadata <- map[in_tissue,,drop=FALSE]
  lane_mat <- tech_counts[,lane_metadata$technical_column,drop=FALSE]
  biological_ids <- unique(lane_metadata$biological_sample)
  biological_mat <- vapply(biological_ids,function(s) {
    lane_cols <- lane_metadata$technical_column[lane_metadata$biological_sample==s]
    rowSums(lane_mat[,lane_cols,drop=FALSE])
  }, FUN.VALUE=numeric(nrow(lane_mat)))
  rownames(biological_mat) <- rownames(lane_mat)
  colnames(biological_mat) <- biological_ids
  biological_metadata <- lane_metadata[match(biological_ids,lane_metadata$biological_sample),,drop=FALSE]
  stopifnot(length(biological_ids)==(if(tissue=='Mus')27L else 28L),
            ncol(lane_mat)==(if(tissue=='Mus')57L else 43L),
            all(abs(rowSums(lane_mat)-rowSums(biological_mat)) < 1e-5))

  pub <- read.csv(file.path(base_dir,'data','references',paste0('published_vs_ours_',tissue,'.csv')),
                  check.names=FALSE,stringsAsFactors=FALSE,fileEncoding='UTF-8-BOM')
  stopifnot(all(c('match_status','ours_gene_id','published_logFC') %in% colnames(pub)))
  pub <- pub[pub$match_status=='unique' & !is.na(pub$ours_gene_id) &
             nzchar(pub$ours_gene_id), ,drop=FALSE]
  stopifnot(!anyDuplicated(pub$ours_gene_id))

  for(level in c('biological_sample','technical_lane_DIAGNOSTIC_ONLY')) {
    if(level=='biological_sample') { m <- biological_metadata; cnt <- biological_mat }
    else { m <- lane_metadata; cnt <- lane_mat }
    design <- create_design(m)
    y <- DGEList(counts=cnt)
    # A plausible *alternate* interpretation of the publication's ambiguous
    # CPM statement: retain CPM>=1 in at least 2 libraries, not the literal
    # requirement that all but <=1 libraries have CPM>=1.
    keep <- rowSums(cpm(y,log=FALSE)>=1)>=2
    keep_literal <- rowSums(cpm(y,log=FALSE)<1)<2
    if(sum(keep)<1000) stop('Unexpected gene retention')
    y <- y[keep,,keep.lib.sizes=FALSE]
    y <- calcNormFactors(y,method='TMM')
    y <- estimateDisp(y,design,robust=FALSE)
    fit <- glmFit(y,design,dispersion=y$tagwise.dispersion)
    lrt <- glmLRT(fit,coef='treatmentMet')
    tab <- topTags(lrt,n=Inf,sort.by='none')$table
    stopifnot(identical(rownames(tab),rownames(y)),all(is.finite(tab$PValue)),
              all(is.finite(tab$FDR)))
    tag <- paste(tissue,level,sep='__')
    out_tab <- data.frame(gene_id=rownames(tab),symbol=raw[[2]][match(rownames(tab),feature_ids)],
                          logFC=tab$logFC,logCPM=tab$logCPM,
                          LR=tab$LR,PValue=tab$PValue,FDR=tab$FDR,
                          dispersion=y$tagwise.dispersion,
                          stringsAsFactors=FALSE)
    gz_out <- gzfile(file.path(output,paste0(tag,'__ALL_GENES.csv.gz')),open='wt')
    write.csv(out_tab,gz_out,row.names=FALSE)
    close(gz_out)
    indices <- match(pub$ours_gene_id,out_tab$gene_id)
    ref <- data.frame(tissue=tissue,model=level,symbol=pub$symbol,
                      published_gene_id=pub$ours_gene_id,
                      published_logFC=pub$published_logFC,
                      published_FDR=pub$published_FDR,
                      present=!is.na(indices),
                      new_logFC=out_tab$logFC[indices],
                      new_PValue=out_tab$PValue[indices],
                      new_FDR=out_tab$FDR[indices],
                      stringsAsFactors=FALSE)
    write.csv(ref,file.path(output,paste0(tag,'__PUBLISHED_GENES.csv')),row.names=FALSE)
    n_ref <- n_ref+1L;ref_list[[n_ref]]<-ref
    valid <- which(ref$present & is.finite(ref$new_logFC) &
                   is.finite(ref$published_logFC))
    ref_ids <- pub$ours_gene_id
    sig <- out_tab$gene_id[out_tab$FDR<0.05]
    matched_sig <- intersect(sig,ref_ids)
    n_summary <- n_summary+1L
    summary_list[[n_summary]]<-data.frame(
      tissue=tissue,analysis_level=level,n_input_libraries=ncol(cnt),
      n_independent_biological_samples=length(biological_ids),
      n_independent_subjects=length(unique(m$participant)),
      residual_df=ncol(cnt)-ncol(design),
      n_cpm_ge1_in_2= sum(keep),
      n_literal_CPM_2018_interpretation=sum(keep_literal),
      n_tested=nrow(out_tab),n_FDR05=length(sig),
      min_FDR=min(out_tab$FDR),
      median_gene_dispersion=median(y$tagwise.dispersion),
      median_TMM_factor=median(y$samples$norm.factors),
      n_pub_unique=nrow(pub), n_pub_present=sum(ref$present),
      n_pub_FDR05=sum(ref$new_FDR<0.05,na.rm=TRUE),
      n_sig_in_pub_list=length(matched_sig),
      n_sig_not_in_pub_list=length(setdiff(sig,ref_ids)),
      pub_logFC_Pearson=if(length(valid)>2)cor(ref$published_logFC[valid],ref$new_logFC[valid]) else NA_real_,
      pub_logFC_Spearman=if(length(valid)>2)cor(ref$published_logFC[valid],ref$new_logFC[valid],method='spearman') else NA_real_,
      pub_logFC_median_abs_diff=if(length(valid))median(abs(ref$new_logFC[valid]-ref$published_logFC[valid])) else NA_real_,
      stringsAsFactors=FALSE)
    n_qc<-n_qc+1L
    qc_list[[n_qc]]<-data.frame(tissue=tissue,analysis_level=level,
       library=colnames(cnt),biological_sample=if(level=='biological_sample')biological_ids else m$biological_sample,
       participant=m$participant,period=m$visit,treatment=m$treatment,
       library_count_sum=colSums(cnt),
       tmm_factor=y$samples$norm.factors,stringsAsFactors=FALSE)
    all_fit[[tag]]<-out_tab[,c('gene_id','FDR','PValue','logFC')]
    cat('COMPLETED',tag,'tested',nrow(out_tab),'DEG',length(sig),
        'published overlap',length(matched_sig),'\n')
  }
}
summary_tab <- do.call(rbind,summary_list)
write.csv(summary_tab,file.path(output,'MODEL_COMPARISON.csv'),row.names=FALSE)
write.csv(do.call(rbind,ref_list),file.path(output,'PUBLISHED_GENE_COMPARISON.csv'),row.names=FALSE)
write.csv(do.call(rbind,qc_list),file.path(output,'LIBRARY_AND_TMM_QC.csv'),row.names=FALSE)
for(tissue in c('Mus','Fat')) {
  a <- all_fit[[paste(tissue,'biological_sample',sep='__')]]
  b <- all_fit[[paste(tissue,'technical_lane_DIAGNOSTIC_ONLY',sep='__')]]
  matched <- match(a$gene_id,b$gene_id)
  xx <- data.frame(gene_id=a$gene_id,biological_FDR=a$FDR,
                   biological_PValue=a$PValue,biological_logFC=a$logFC,
                   techlane_PValue=b$PValue[matched],techlane_FDR=b$FDR[matched],
                   techlane_logFC=b$logFC[matched],stringsAsFactors=FALSE)
  write.csv(xx,file.path(output,paste0(tissue,'__BIOLOGICAL_VS_TECHLANE.csv')),row.names=FALSE)
}
writeLines(capture.output(sessionInfo()),file.path(output,'sessionInfo.txt'))
writeLines(c('FINISHED',as.character(Sys.time()),
             paste0('Models:',nrow(summary_tab)),
             paste0('edgeR:',as.character(packageVersion('edgeR'))),
             'Technical-lane model is an INVALID inferential design, diagnostic only.',
             'Do not cite it as a valid experiment or evidence of treatment effects.'),
           complete_file)
cat('FINISHED. Results:',output,'\n')
print(summary_tab[,c('tissue','analysis_level','n_tested','n_FDR05','n_sig_in_pub_list','pub_logFC_Pearson')])
