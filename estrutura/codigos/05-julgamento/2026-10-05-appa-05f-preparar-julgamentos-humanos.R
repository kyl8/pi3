# Prepara tres planilhas vazias para julgamento humano da Aula 05.
# Nenhum grau e atribuido por este script.

args <- commandArgs(trailingOnly = FALSE)
arquivo <- grep("^--file=", args, value = TRUE)
if (length(arquivo)) setwd(dirname(normalizePath(sub("^--file=", "", arquivo[1]))))

dir_csv <- "csv"
pool <- read.csv(file.path(dir_csv, "2026-09-15-appa-05-pool.csv"),
  stringsAsFactors = FALSE, fileEncoding = "UTF-8")
stopifnot(all(c("consulta", "documento") %in% names(pool)))

saida <- file.path(dir_csv, "julgamentos-humanos")
dir.create(saida, showWarnings = FALSE, recursive = TRUE)

for (i in 1:3) {
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
  caminho <- file.path(saida, sprintf("juiz_%02d.csv", i))
  write.csv(planilha, caminho, row.names = FALSE, na = "", fileEncoding = "UTF-8")
  cat("Planilha criada:", caminho, "\n")
}
cat("Cada planilha possui", nrow(pool), "pares sem grau.\n")
