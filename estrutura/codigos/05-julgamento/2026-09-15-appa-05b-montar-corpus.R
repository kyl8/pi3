# Monta o corpus usado na avaliacao humana a partir do motor atual.

args <- commandArgs(trailingOnly = FALSE)
arquivo <- grep("^--file=", args, value = TRUE)
if (length(arquivo)) setwd(dirname(normalizePath(sub("^--file=", "", arquivo[1]))))

source("..\\2026-09-04-appa-MotorBuscaBm25.r")
dir.create("csv", showWarnings = FALSE)

decodificar_unicode <- function(texto) {
  ocorrencias <- gregexpr("<U\\+[[:xdigit:]]+>", texto, perl = TRUE)[[1]]
  if (ocorrencias[1] == -1) return(texto)

  tamanhos <- attr(ocorrencias, "match.length")
  partes <- character(length(ocorrencias) * 2 + 1)
  inicio <- 1
  posicao <- 1
  for (i in seq_along(ocorrencias)) {
    fim <- ocorrencias[i] - 1
    partes[posicao] <- substr(texto, inicio, fim)
    codigo <- substr(texto, ocorrencias[i] + 3, ocorrencias[i] + tamanhos[i] - 2)
    partes[posicao + 1] <- intToUtf8(strtoi(codigo, base = 16L))
    inicio <- ocorrencias[i] + tamanhos[i]
    posicao <- posicao + 2
  }
  partes[posicao] <- substr(texto, inicio, nchar(texto))
  paste0(partes, collapse = "")
}

normalizar_csv_unicode <- function(caminho) {
  linhas <- readLines(caminho, warn = FALSE, encoding = "ASCII")
  texto <- decodificar_unicode(paste(linhas, collapse = "\n"))
  conexao <- file(caminho, open = "wb")
  on.exit(close(conexao), add = TRUE)
  writeBin(charToRaw(enc2utf8(paste0(texto, "\n"))), conexao)
}

corpus <- data.frame(
  id = names(docs),
  titulo = paste("Paragrafo", names(docs)),
  texto = vapply(unname(docs), decodificar_unicode, character(1)),
  data = "",
  fonte = unname(doc_origem),
  url = "https://pt.wikipedia.org/",
  stringsAsFactors = FALSE
)

write.csv(corpus, "csv/2026-09-15-appa-05-corpus.csv", row.names = FALSE)
normalizar_csv_unicode("csv/2026-09-15-appa-05-corpus.csv")
cat("Corpus gravado:", nrow(corpus), "paragrafos\n")
