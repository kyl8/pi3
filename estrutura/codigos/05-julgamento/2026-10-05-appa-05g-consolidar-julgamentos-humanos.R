# Consolida tres julgamentos humanos da Aula 05 sem fabricar consenso.
# O qrels final so e gravado quando todos os pares possuem maioria de dois ou tres juizes.

kappa_cohen <- function(a, b) {
  m <- table(factor(a, levels = 0:2), factor(b, levels = 0:2))
  n <- sum(m)
  po <- sum(diag(m)) / n
  pe <- sum(rowSums(m) * colSums(m)) / n^2
  if (isTRUE(all.equal(1 - pe, 0))) return(NA_real_)
  (po - pe) / (1 - pe)
}

args <- commandArgs(trailingOnly = FALSE)
arquivo <- grep("^--file=", args, value = TRUE)
if (length(arquivo)) setwd(dirname(normalizePath(sub("^--file=", "", arquivo[1]))))

dir_csv <- "csv"
dir_juizes <- file.path(dir_csv, "julgamentos-humanos")
pool <- read.csv(file.path(dir_csv, "2026-09-15-appa-05-pool.csv"),
  stringsAsFactors = FALSE, fileEncoding = "UTF-8")
arquivos <- list.files(dir_juizes, pattern = "^juiz_[0-9]+\\.csv$", full.names = TRUE)
if (length(arquivos) != 3) stop("Sao necessarios exatamente tres arquivos juiz_XX.csv.")

chave <- function(x) paste(x$consulta, x$documento, sep = "|")
chaves_pool <- sort(chave(pool))
ler_juiz <- function(caminho) {
  x <- read.csv(caminho, stringsAsFactors = FALSE, na.strings = "", fileEncoding = "UTF-8")
  obrigatorias <- c("consulta", "documento", "grau", "juiz")
  if (!all(obrigatorias %in% names(x))) stop("Colunas ausentes em ", basename(caminho))
  if (nrow(x) != nrow(pool) || !identical(sort(chave(x)), chaves_pool)) {
    stop("O arquivo ", basename(caminho), " nao cobre exatamente o pool.")
  }
  if (length(unique(x$juiz)) != 1) stop("Cada arquivo deve conter apenas um juiz: ", basename(caminho))
  if (any(is.na(x$grau)) || any(!(x$grau %in% 0:2))) {
    stop("Todos os graus devem ser 0, 1 ou 2 em ", basename(caminho))
  }
  x[match(chave(pool), chave(x)), c("consulta", "documento", "grau", "juiz")]
}

votos <- lapply(arquivos, ler_juiz)
nomes <- vapply(votos, function(x) unique(x$juiz), character(1))
if (length(unique(nomes)) != 3) stop("Os tres arquivos precisam ter identificacoes de juiz diferentes.")
graus <- sapply(votos, `[[`, "grau")
colnames(graus) <- nomes

maioria <- apply(graus, 1, function(x) {
  frequencia <- tabulate(x + 1, nbins = 3)
  if (max(frequencia) >= 2) which.max(frequencia) - 1L else NA_integer_
})
divergencias <- data.frame(pool, graus, consenso = maioria, stringsAsFactors = FALSE)
divergencias <- divergencias[apply(graus, 1, function(x) length(unique(x)) > 1), ]
write.csv(divergencias, file.path(dir_juizes, "divergencias.csv"), row.names = FALSE, fileEncoding = "UTF-8")

pares <- combn(seq_len(ncol(graus)), 2)
kappas <- data.frame(
  juiz_a = colnames(graus)[pares[1, ]],
  juiz_b = colnames(graus)[pares[2, ]],
  kappa = apply(pares, 2, function(i) kappa_cohen(graus[, i[1]], graus[, i[2]])),
  stringsAsFactors = FALSE
)
write.csv(kappas, file.path(dir_juizes, "kappas.csv"), row.names = FALSE, fileEncoding = "UTF-8")

if (anyNA(maioria)) {
  cat("Ha", sum(is.na(maioria)), "pares sem maioria. Consulte divergencias.csv e registre o desempate humano.\n")
  quit(save = "no", status = 1)
}

qrels_final <- data.frame(
  consulta = pool$consulta,
  documento = pool$documento,
  grau = maioria,
  juiz = "consenso_3_juizes",
  timestamp = format(Sys.time(), "%Y-%m-%dT%H:%M:%S%z"),
  segundos = "",
  metodo = "maioria_de_tres_julgamentos_humanos",
  stringsAsFactors = FALSE
)
write.csv(qrels_final, file.path(dir_csv, "2026-09-15-appa-05-qrels-humanos.csv"),
  row.names = FALSE, fileEncoding = "UTF-8")
cat("Qrels humano final gravado com", nrow(qrels_final), "pares.\n")
print(kappas)
