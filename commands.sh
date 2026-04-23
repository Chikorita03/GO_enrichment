# Motif → Gene List → GO Enrichment Pipeline

set -e
# Step 1: Convert annotation → BED
# (Used the file: human_gene_annotation.tsv.gz)

zcat human_gene_annotation.tsv.gz | awk 'BEGIN{OFS="\t"} 
{
    # Adjust columns if needed (assumed format)
    # chrom, start, end, gene_id
    print $1, $2, $3, $4
}' > genes.bed

# Step 2: Extend regions (±500 bp)
bedtools slop \
    -i genes.bed \
    -g hg38.chrom.sizes \
    -b 500 > genes_500bp.bed

# Step 3: Clean BED
cp genes_500bp.bed genes_clean.bed
cp genes_clean.bed genes_fixed.bed

# Step 4: Extract sequences
bedtools getfasta \
    -fi hg38.fa \
    -bed genes_fixed.bed \
    -fo sequences.fa

# Step 5: Motif search
fuzznuc \
    -sequence sequences.fa \
    -pattern "GCGC..GCGC" \
    -outfile motif_hits.fa

# Step 6: Extract gene IDs
grep ">" motif_hits.fa | cut -d":" -f1 | sed 's/>//' > gene_list.txt

# Step 7: Run GO enrichment
Rscript go_enrichment.R

# Outputs
# gene_list.txt   → genes with motif hits
# go_results.csv  → GO enrichment results
# go_plots.pdf    → dotplot visualization