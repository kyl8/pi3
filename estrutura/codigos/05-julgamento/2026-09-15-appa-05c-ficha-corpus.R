# Confere a ficha tecnica do corpus antes do julgamento.

args <- commandArgs(trailingOnly = FALSE)
arquivo <- grep("^--file=", args, value = TRUE)
if (length(arquivo)) setwd(dirname(normalizePath(sub("^--file=", "", arquivo[1]))))

ler_csv_utf8 <- function(caminho) {
  linhas <- readLines(caminho, warn = FALSE, encoding = "UTF-8")
  read.csv(textConnection(linhas), stringsAsFactors = FALSE, check.names = FALSE)
}

corpus <- ler_csv_utf8("csv/2026-09-15-appa-05-corpus.csv")
cat("Linhas:", nrow(corpus), "\n")
cat("Colunas:", paste(names(corpus), collapse = ", "), "\n")
cat("IDs duplicados:", sum(duplicated(corpus$id)), "\n")
cat("Documentos por clube:\n")
print(table(corpus$fonte))
