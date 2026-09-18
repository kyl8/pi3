# Monta o corpus usado na avaliacao humana a partir do motor atual.

args <- commandArgs(trailingOnly = FALSE)
arquivo <- grep("^--file=", args, value = TRUE)
if (length(arquivo)) setwd(dirname(normalizePath(sub("^--file=", "", arquivo[1]))))

source("..\\2026-09-04-appa-MotorBuscaBm25.r")
dir.create("csv", showWarnings = FALSE)

corpus <- data.frame(
  id = names(docs),
  titulo = paste("Paragrafo", names(docs)),
  texto = unname(docs),
  data = "",
  fonte = unname(doc_origem),
  url = "https://pt.wikipedia.org/",
  stringsAsFactors = FALSE
)

write.csv(corpus, "csv/2026-09-15-appa-05-corpus.csv", row.names = FALSE, fileEncoding = "UTF-8")
cat("Corpus gravado:", nrow(corpus), "paragrafos\n")
