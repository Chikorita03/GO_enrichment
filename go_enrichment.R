library(clusterProfiler)
library(org.Hs.eg.db)

genes <- read.table("gene_list.txt", stringsAsFactors = FALSE)[,1]

genes <- read.table("gene_list.txt", stringsAsFactors = FALSE)[,1]

genes <- sub("::.*", "", genes)
genes <- sub("\\..*", "", genes)
genes <- unique(genes)

head(genes)

ego <- enrichGO(
  gene = genes,
  OrgDb = org.Hs.eg.db,
  keyType = "ENSEMBL",
  ont = "BP",
  pvalueCutoff = 0.05
)

write.csv(as.data.frame(ego), "go_results.csv", row.names = FALSE)
dotplot(ego, showCategory = 10)