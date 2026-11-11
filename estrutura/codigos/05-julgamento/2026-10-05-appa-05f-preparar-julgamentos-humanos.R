# Prepara tres planilhas vazias para julgamento humano da Aula 05.
# Nenhum grau e atribuido por este script.

args <- commandArgs(trailingOnly = FALSE)
arquivo <- grep("^--file=", args, value = TRUE)
if (length(arquivo)) setwd(dirname(normalizePath(sub("^--file=", "", arquivo[1]))))

dir_csv <- if (dir.exists("estrutura/codigos/05-julgamento/csv")) "estrutura/codigos/05-julgamento/csv" else "csv"
pool <- read.csv(file.path(dir_csv, "2026-11-06-appa-05-pool-v2.csv"),
  stringsAsFactors = FALSE, fileEncoding = "UTF-8")
stopifnot(all(c("consulta", "documento") %in% names(pool)))

saida <- file.path(dir_csv, "julgamentos-humanos")
dir.create(saida, showWarnings = FALSE, recursive = TRUE)

chave <- function(x) paste(x$consulta, x$documento, sep = "|")
stopifnot(!anyDuplicated(chave(pool)))
# Confere todos os arquivos antes de gravar qualquer um: votos existentes nunca sao apagados.
for (i in 1:3) {
  caminho <- file.path(saida, sprintf("juiz_%02d.csv", i))
  if (!file.exists(caminho)) next
  anterior <- read.csv(caminho, stringsAsFactors = FALSE, na.strings = "", fileEncoding = "UTF-8")
  stopifnot(all(c("consulta", "documento", "grau", "juiz") %in% names(anterior)))
  if (any(!is.na(anterior$grau)) && !identical(sort(chave(anterior)), sort(chave(pool)))) {
    stop("Pool mudou e existem votos em ", caminho, ". Migre os votos antes de preparar novas planilhas.", call. = FALSE)
  }
}

for (i in 1:3) {
  caminho <- file.path(saida, sprintf("juiz_%02d.csv", i))
  if (file.exists(caminho)) {
    anterior <- read.csv(caminho, stringsAsFactors = FALSE, na.strings = "", fileEncoding = "UTF-8")
    if (identical(sort(chave(anterior)), sort(chave(pool)))) {
      cat("Planilha preservada:", caminho, "\n")
      next
    }
  }
  planilha <- data.frame(
    consulta = pool$consulta,
    documento = pool$documento,
    grau = NA_integer_,
    juiz = sprintf("juiz_%02d", i),
    timestamp = NA_character_,
    segundos = NA_character_,
    metodo = "julgamento_humano",
    stringsAsFactors = FALSE
  )
  write.csv(planilha, caminho, row.names = FALSE, na = "", fileEncoding = "UTF-8")
  cat("Planilha criada:", caminho, "\n")
}
cat("Cada planilha possui", nrow(pool), "pares sem grau.\n")
