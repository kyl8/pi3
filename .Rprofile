# Ambiente local da disciplina; nao instala pacotes nem altera dados.
if (.Platform$OS.type == "windows") {
  invisible(Sys.setlocale("LC_CTYPE", "English_United States.utf8"))
} else if (!isTRUE(l10n_info()[["UTF-8"]])) {
  # Em locale nao UTF-8 (ex.: LANG=C), read.csv(fileEncoding = "UTF-8") devolve 0 linhas sem avisar.
  invisible(tryCatch(Sys.setlocale("LC_CTYPE", "C.UTF-8"), warning = function(w) NULL, error = function(e) NULL))
}
options(repos = c(CRAN = "https://cloud.r-project.org"))
