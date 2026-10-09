# 2026-10-09-appa-Atividade06-RocchioFeedback.r

# Corpus de 8 documentos (da aula 06)
docs <- c(
  d1 = "recuperacao de informacao ordena documentos por relevancia",
  d2 = "o modelo de espaco vetorial representa documentos como vetores",
  d3 = "bm25 e um modelo probabilistico de ranqueamento de texto",
  d4 = "aprendizado estatistico fundamenta a recuperacao moderna",
  d5 = "o indice invertido acelera a busca em muitos documentos",
  d6 = "embeddings capturam a semantica de palavras e documentos",
  d7 = "a avaliacao mede a relevancia dos resultados da busca",
  d8 = "ciencia de dados combina estatistica e programacao"
)

# 1. Implementar rocchio sobre o corpus de 8 documentos.
# Pre-processamento e vetorizacao (TF-IDF)
tok <- function(x) unlist(strsplit(tolower(x), "\\s+"))
tokens <- lapply(docs, tok)
vocab <- sort(unique(unlist(tokens)))

tf <- sapply(tokens, function(t) as.integer(table(factor(t, levels = vocab))))
rownames(tf) <- vocab
idf <- log(ncol(tf) / rowSums(tf > 0))
w <- tf * idf

cosseno <- function(a, b) {
  den <- sqrt(sum(a^2)) * sqrt(sum(b^2))
  if (den == 0) return(0)
  sum(a*b) / den
}

rocchio <- function(q, Dr, Dnr = character(0), a = 1, b = 0.75, g = 0.15) {
  cr <- if (length(Dr) > 0) rowMeans(w[, Dr, drop = FALSE]) else rep(0, length(q))
  cnr <- if (length(Dnr) > 0) rowMeans(w[, Dnr, drop = FALSE]) else rep(0, length(q))
  a * q + b * cr - g * cnr
}

# 2. Escolher uma consulta, marcar 1-2 relevantes e comparar o ranking antes/depois.
consulta_texto <- "modelo de recuperacao"
qw <- as.integer(table(factor(tok(consulta_texto), levels = vocab))) * idf

base <- apply(w, 2, function(d) cosseno(qw, d))
ranking_base <- sort(base, decreasing = TRUE)
cat("--- Ranking Base ---\n")
print(round(ranking_base, 3))

# Marcando d2 e d3 como relevantes e d4 como nao relevante
Dr <- c("d2", "d3")
Dnr <- c("d4")

qm <- rocchio(qw, Dr, Dnr)
# Zera os pesos negativos (opcional)
qm[qm < 0] <- 0

novo <- apply(w, 2, function(d) cosseno(qm, d))
ranking_novo <- sort(novo, decreasing = TRUE)
cat("\n--- Ranking com Feedback (Rocchio) ---\n")
print(round(ranking_novo, 3))

# 3. Implementar pseudo-feedback com os top-2 e discutir o resultado.
# Pseudo-feedback: assumimos os top-k (aqui top-2) da busca base como relevantes, nenhum nao relevante.
top2_docs <- names(ranking_base)[1:2]
cat("\nTop-2 documentos da busca inicial:", paste(top2_docs, collapse = ", "), "\n")

qm_pseudo <- rocchio(qw, Dr = top2_docs, Dnr = character(0))
qm_pseudo[qm_pseudo < 0] <- 0

novo_pseudo <- apply(w, 2, function(d) cosseno(qm_pseudo, d))
ranking_pseudo <- sort(novo_pseudo, decreasing = TRUE)
cat("\n--- Ranking com Pseudo-feedback (Top-2) ---\n")
print(round(ranking_pseudo, 3))
