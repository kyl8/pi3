# Confere a ficha tecnica do corpus antes do julgamento.

args <- commandArgs(trailingOnly = FALSE)
arquivo <- grep("^--file=", args, value = TRUE)
if (length(arquivo)) setwd(dirname(normalizePath(sub("^--file=", "", arquivo[1]))))

corpus <- read.csv("csv/2026-09-15-appa-05-corpus.csv", stringsAsFactors = FALSE, fileEncoding = "UTF-8")
cat("Linhas:", nrow(corpus), "\n")
cat("Colunas:", paste(names(corpus), collapse = ", "), "\n")
cat("IDs duplicados:", sum(duplicated(corpus$id)), "\n")
cat("Documentos por clube:\n")
print(table(corpus$fonte))
