# Calcula kappa de Cohen para duas colunas de julgamentos humanos.

kappa_cohen <- function(a, b) {
  m <- table(factor(a, levels = 0:2), factor(b, levels = 0:2))
  n <- sum(m)
  po <- sum(diag(m)) / n
  pe <- sum(rowSums(m) * colSums(m)) / n^2
  (po - pe) / (1 - pe)
}

args <- commandArgs(trailingOnly = FALSE)
arquivo <- grep("^--file=", args, value = TRUE)
if (length(arquivo)) setwd(dirname(normalizePath(sub("^--file=", "", arquivo[1]))))

arquivo_qrels <- "csv/2026-09-15-appa-05-qrels.csv"
if (!file.exists(arquivo_qrels)) {
  cat("Ainda nao existe qrels humano. Use o HTML para gerar esse arquivo.\n")
  quit(save = "no", status = 0)
}

qrels <- read.csv(arquivo_qrels, stringsAsFactors = FALSE, fileEncoding = "UTF-8")
if (!all(c("consulta", "documento", "grau", "juiz") %in% names(qrels))) {
  stop("O qrels precisa ter consulta, documento, grau e juiz.")
}
juizes <- unique(qrels$juiz)
if (length(juizes) < 2) {
  cat("O qrels tem apenas um juiz. A coleta de um segundo julgamento e necessaria.\n")
  quit(save = "no", status = 0)
}

pares <- split(qrels, interaction(qrels$consulta, qrels$documento, drop = TRUE))
comparaveis <- Filter(function(x) length(unique(x$juiz)) >= 2, pares)
if (!length(comparaveis)) stop("Nao ha documentos julgados pelos mesmos dois juizes.")

a <- vapply(comparaveis, function(x) x$grau[match(juizes[1], x$juiz)], numeric(1))
b <- vapply(comparaveis, function(x) x$grau[match(juizes[2], x$juiz)], numeric(1))
cat("Juizes:", juizes[1], "e", juizes[2], "\n")
cat("Pares comparaveis:", length(a), "\n")
cat("Kappa de Cohen:", round(kappa_cohen(a, b), 4), "\n")
