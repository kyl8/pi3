# Cria uma referencia inicial para conferir o fluxo de avaliacao.
# Os graus precisam ser revisados no HTML antes de uma conclusao final.

args <- commandArgs(trailingOnly = FALSE)
arquivo <- grep("^--file=", args, value = TRUE)
if (length(arquivo)) setwd(dirname(normalizePath(sub("^--file=", "", arquivo[1]))))

dir_csv <- "csv"
ler_csv_utf8 <- function(caminho) {
  linhas <- readLines(caminho, warn = FALSE, encoding = "UTF-8")
  read.csv(textConnection(linhas), stringsAsFactors = FALSE, check.names = FALSE)
}

corpus <- ler_csv_utf8(file.path(dir_csv, "2026-09-15-appa-05-corpus.csv"))
pool <- ler_csv_utf8(file.path(dir_csv, "2026-09-15-appa-05-pool.csv"))

termos_fortes <- list(
  q01 = "fund|hist|cri|orig|primeir|form",
  q02 = "titul|campe|ta[cç]|conquist|trofe",
  q03 = "estadi|ulrico|sede|campo",
  q04 = "fund|hist|hespanha|agremia|clube",
  q05 = "rival|class|confront|corinth|palmeir|sao paulo",
  q06 = "estadi|ulrico|campo"
)
clube_esperado <- c(
  q01 = "Santos FC", q02 = "Santos FC", q03 = "Portuguesa Santista",
  q04 = "Jabaquara", q05 = "Santos FC", q06 = "Jabaquara"
)

qrels <- merge(pool, corpus[c("id", "texto", "fonte")],
  by.x = "documento", by.y = "id", all.x = TRUE, sort = FALSE
)
qrels$grau <- mapply(function(consulta, texto, fonte) {
  if (!identical(fonte, clube_esperado[[consulta]])) return(0L)
  if (grepl(termos_fortes[[consulta]], texto, ignore.case = TRUE, perl = TRUE)) return(2L)
  1L
}, qrels$consulta, qrels$texto, qrels$fonte)
qrels$juiz <- "referencia_inicial_appa"
qrels$timestamp <- "2026-09-17T00:00:00-03:00"
qrels$segundos <- ""
qrels$metodo <- "regra_de_referencia"

qrels <- qrels[c("consulta", "documento", "grau", "juiz", "timestamp", "segundos", "metodo")]
write.csv(qrels, file.path(dir_csv, "2026-09-15-appa-05-qrels.csv"),
  row.names = FALSE, fileEncoding = "UTF-8"
)
cat("Qrels inicial gravado:", nrow(qrels), "julgamentos\n")
print(table(qrels$grau))
