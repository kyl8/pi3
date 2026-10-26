# Configuracao APPA; selecao assistida de 2026-10-25, ver sincronizacao.
cfg <-
list(corpus_dir = "estrutura/corpus", resultados_dir = "estrutura/resultados",
    minimo = 50, limpar = TRUE, acentos = "translit", stopwords = c("a",
    "o", "e", "de", "do", "da", "dos", "das", "em", "no", "na",
    "para", "por", "com", "que", "um", "uma"), stemming = TRUE,
    k1 = 1.5, b = 0.75, limiar = 2L, juizes = "codex_assistido",
    prf_k = 0L, rocchio = c(a = 1, b = 0.75, g = 0.15), modelo = "hibrido",
    lsa_k = 20L, rrf_c = 60, grupo = "APPA")
