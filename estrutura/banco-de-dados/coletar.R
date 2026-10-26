# R | coletar.R | executar na raiz de pi3 ou nesta pasta.
if (.Platform$OS.type == "windows") invisible(Sys.setlocale("LC_CTYPE", "English_United States.utf8")) # Habilita UTF-8 no Windows.
raiz <- if (file.exists("estrutura/corpus")) "." else "../.." # Aceita os dois diretorios documentados.
pastas <- file.path(raiz, "estrutura/corpus/fontes-congeladas") # Usa textos congelados, sem mover ids por mudancas na Wikipedia.
nomes <- c("santos", "portuguesa", "jabaquara"); fontes <- c("Santos FC", "Portuguesa Santista", "Jabaquara") # Declara a ordem original dos artigos.
partes <- lapply(nomes, function(n) readLines(file.path(pastas, paste0(n, ".txt")), encoding = "UTF-8", warn = FALSE)) # Reconstroi os paragrafos das fontes locais.
docs <- setNames(unlist(partes, use.names = FALSE), paste0("d", seq_len(sum(lengths(partes))))) # Preserva a ordenacao historica.
origem <- setNames(rep(fontes, lengths(partes)), names(docs)) # Registra artigo de cada paragrafo.
cp <- read.csv(file.path(raiz, "estrutura/codigos/05-julgamento/csv/2026-09-15-appa-05-corpus.csv"), fileEncoding = "UTF-8", stringsAsFactors = FALSE) # Le a referencia congelada dos julgamentos.
stopifnot(identical(names(docs), cp$id), identical(unname(docs), cp$texto)) # Para antes de sobrescrever se ids ou textos divergirem.
destino <- file.path(raiz, "estrutura/banco-de-dados") # Mantem o caminho esperado pelo enunciado.
saveRDS(docs, file.path(destino, "docs.rds")); saveRDS(origem, file.path(destino, "origem.rds")) # Recria os dois artefatos exigidos.
cat("Corpus reconstituido das fontes congeladas:", length(docs), "documentos.\n") # Confirma o resultado verificavel.
