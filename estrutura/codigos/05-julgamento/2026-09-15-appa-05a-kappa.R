# Calcula kappa de Cohen entre os julgadores humanos.
# Le csv/julgamentos-humanos/juiz_*.csv (graus 0, 1, 2) e usa os pares julgados pelos dois juizes escolhidos.
# Uso: source() ou Rscript a partir de qualquer pasta; nunca encerra a sessao do R.

kappa_cohen <- function(a, b) {
  m <- table(factor(a, levels = 0:2), factor(b, levels = 0:2))
  n <- sum(m)
  po <- sum(diag(m)) / n
  pe <- sum(rowSums(m) * colSums(m)) / n^2
  if (isTRUE(all.equal(1 - pe, 0))) return(NA_real_) # pe = 1: kappa indefinido
  (po - pe) / (1 - pe)
}

args <- commandArgs(trailingOnly = FALSE)
arquivo <- grep("^--file=", args, value = TRUE)
if (length(arquivo)) setwd(dirname(normalizePath(sub("^--file=", "", arquivo[1]))))

dir_juizes <- "csv/julgamentos-humanos"
arquivos <- list.files(dir_juizes, pattern = "^juiz_[0-9]+\\.csv$", full.names = TRUE)
if (length(arquivos) < 2) stop("Sao necessarios ao menos dois arquivos juiz_XX.csv em ", dir_juizes, ".", call. = FALSE)

qrels <- do.call(rbind, lapply(arquivos, function(f) {
  x <- read.csv(f, stringsAsFactors = FALSE, na.strings = "", fileEncoding = "UTF-8")
  if (!all(c("consulta", "documento", "grau", "juiz") %in% names(x))) stop("Colunas ausentes em ", basename(f), call. = FALSE)
  x[c("consulta", "documento", "grau", "juiz")]
}))
qrels <- qrels[!is.na(qrels$grau), ]
juizes <- unique(qrels$juiz)
if (length(juizes) < 2) stop("Ainda nao ha graus preenchidos por dois juizes. Use o HTML de julgamento e exporte os CSV.", call. = FALSE)

# Compara apenas os dois primeiros juizes com graus; para as tres combinacoes use o script 05g.
a <- qrels[qrels$juiz == juizes[1], ]
b <- qrels[qrels$juiz == juizes[2], ]
m <- merge(a, b, by = c("consulta", "documento"), suffixes = c("_a", "_b"))
if (!nrow(m)) stop("Nao ha documentos julgados pelos mesmos dois juizes.", call. = FALSE)

cat("Juizes:", juizes[1], "e", juizes[2], "\n")
cat("Pares comparaveis:", nrow(m), "\n")
cat("Kappa de Cohen:", round(kappa_cohen(m$grau_a, m$grau_b), 4), "\n")
