# Aula 02 - Modelo do Espaço Vetorial: vetores, TF-IDF e similaridade do cosseno
# Grupo APPA

source("https://raw.githubusercontent.com/fractalarea/pi3-motor-de-busca/main/motor/motor02.R")
docs <- docs_aula()
cfg  <- cfg_aula()
ix   <- montar(docs, cfg)

# M4 - Função cosseno
cosseno <- function(a, b) {
  den <- sqrt(sum(a^2)) * sqrt(sum(b^2))
  if (den == 0) return(0)
  sum(a * b) / den
}

# M5 - Normalização por coluna
norm_cols <- function(m) {
  sweep(m, 2, sqrt(colSums(m^2)), "/")
}

# Matriz TF-IDF normalizada
wn <- norm_cols(ix$w)

# M6 - Vetor consulta
vetor_consulta <- function(tokens_q, vocab, idf) {
  tf_q <- as.integer(table(factor(tokens_q, levels = vocab)))
  tf_q * idf
}

qw <- vetor_consulta(tokenizar("modelo de recuperacao"), ix$vocab, ix$idf_tfidf)

# M7 - Ranking Cosseno
ranking_cosseno <- function(qw, wn) {
  # O cosseno entre qw e as colunas de wn (que ja estao normalizadas)
  # Como a query nao esta normalizada aqui, normalizamos ela primeiro:
  qw_norm <- qw / sqrt(sum(qw^2))
  if (is.nan(qw_norm[1])) qw_norm[is.na(qw_norm)] <- 0
  
  res <- apply(wn, 2, function(d) sum(qw_norm * d))
  sort(res, decreasing = TRUE)
}

ranking <- ranking_cosseno(qw, wn)
print(ranking)
