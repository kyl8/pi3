# Gera o conjunto de pares necessidade-documento que sera julgado.

args <- commandArgs(trailingOnly = FALSE)
arquivo <- grep("^--file=", args, value = TRUE)
if (length(arquivo)) setwd(dirname(normalizePath(sub("^--file=", "", arquivo[1]))))

dir_csv <- "csv"
corpus <- read.csv(file.path(dir_csv, "2026-09-15-appa-05-corpus.csv"), stringsAsFactors = FALSE, fileEncoding = "UTF-8")
necessidades <- read.csv(file.path(dir_csv, "2026-09-15-appa-05-necessidades.csv"), stringsAsFactors = FALSE, fileEncoding = "UTF-8")

source("..\\2026-09-04-appa-MotorBuscaBm25.r")

pool <- do.call(rbind, lapply(necessidades$id, function(id) {
  consulta <- necessidades$texto_consulta[necessidades$id == id]
  bm25 <- names(head(rankear_bm25(consulta, 10), 10))
  tfidf <- names(head(rankear_tfidf(consulta, 10), 10))
  data.frame(
    consulta = id,
    documento = unique(c(bm25, tfidf)),
    stringsAsFactors = FALSE
  )
}))
pool <- pool[order(pool$consulta, pool$documento), ]
write.csv(pool, file.path(dir_csv, "2026-09-15-appa-05-pool.csv"), row.names = FALSE, fileEncoding = "UTF-8")
cat("Pool gravado:", nrow(pool), "pares\n")
