# R | aula04_teoria.R | blocos literais do guia; executar pelo runner.

# Bloco 1
f <- 0:5                                  # os valores de f que vamos testar
round(exp(-2) * 2^f / factorial(f), 3)    # P(X = f) com lambda = 2, para cada f de uma vez

# Bloco 2
w2p <- function(f, p = 0.6, q = 0.1, lam = 3, mu = 0.2) {    # o peso 2-Poisson do Módulo 4
  num <- p * exp(-lam) * lam^f + (1 - p) * exp(-mu) * mu^f   # mistura, dado relevante
  den <- q * exp(-lam) * lam^f + (1 - q) * exp(-mu) * mu^f   # mistura, dado irrelevante
  log(num / den)                                             # o log da razão
}                                                            # fim da função
round(w2p(c(0, 1, 2, 3, 5, 8)) - w2p(0), 3)                  # a curva, já normalizada

# Bloco 3
f <- 0:8                                                   # ocorrências do termo
plot(f, f, type = "b",                                     # o TF linear: uma reta
     xlab = "ocorrências (f)", ylab = "contribuição")      # nomes dos eixos
lines(f, f * 2.2 / (f + 1.2), type = "b")                  # o BM25 com k1 = 1,2: dobra e para

# Bloco 4
ix$tf[c("modelo", "de", "recuperacao"), ]   # as linhas dos três termos da consulta

# Bloco 5
dl    <- colSums(ix$tf)                                     # |d|: quantas palavras tem cada documento
avgdl <- mean(dl)                                           # avgdl: o tamanho MÉDIO
idf_b <- log((ix$N - ix$df + 0.5) / (ix$df + 0.5) + 1)      # o IDF do Módulo 8, um por termo
dl                                                          # mostra os 8 tamanhos

# Bloco 6
bm25_doc <- function(termos, d, k1 = 1.2, b = 0.75) {   # escore BM25 de UM documento d
  s <- 0                                                 # acumulador do somatório
  for (t in termos) {                                    # a SOMA sobre os termos da consulta
    if (!t %in% ix$vocab) next                           # termo fora do vocabulário: pula
    f <- ix$tf[t, d]                                     # f: frequência do termo NESTE documento
    if (f == 0) next                                     # termo ausente: contribui 0 (por quê?)
    K <- k1 * (1 - b + b * dl[[d]] / avgdl)              # o K do Módulo 7
    s <- s + idf_b[[t]] * (f * (k1 + 1)) / (f + K)       # a contribuição do termo
  }                                                      # fim do for
  s                                                      # devolve a soma
}                                                        # fim da função

# Bloco 7
consulta <- preparar("modelo de recuperacao", cfg)                     # a MESMA limpeza do índice (motor)
scores <- sapply(colnames(ix$tf), function(d) bm25_doc(consulta, d))   # um escore por documento
round(sort(scores, decreasing = TRUE), 3)                              # do maior ao menor

# Bloco 8
sat <- function(f, k1 = 1.2) (f * (k1 + 1)) / (f + k1)   # a saturação, sem o tamanho
round(sat(1:5), 3)                                       # f = 1 a 5

# Bloco 9
s2 <- sapply(colnames(ix$tf), function(d) bm25_doc(consulta, d, k1 = 0.5))   # troque k1 ou b aqui
round(sort(s2, decreasing = TRUE), 3)                                        # a ordem mudou?
