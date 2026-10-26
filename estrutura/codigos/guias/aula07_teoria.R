# R | aula07_teoria.R | blocos literais do guia; executar pelo runner.

# Bloco 1
round(ranking_cosseno("busca", ix, cfg), 3)          # quem tem a palavra "busca"?
round(ranking_cosseno("ranqueamento", ix, cfg), 3)   # e "ranqueamento"?

# Bloco 2
sum(ix$w[, "d1"] != 0)                    # quantas coordenadas de d1 nao sao zero
sum(ix$w != 0) / length(ix$w)             # a fracao nao nula da matriz inteira

# Bloco 3
s <- svd(ix$w)                                   # a decomposicao: lista com d, u (45 x 8), v (8 x 8)
round(s$d, 3)                                    # os valores singulares, do maior ao menor
round(s$d^2, 2); round(sum(s$d^2), 2)            # a "energia" de cada direcao, e o total
all(round(s$u %*% diag(s$d) %*% t(s$v) - ix$w, 10) == 0)  # U Sigma V' devolve W?

# Bloco 4
lsa <- function(ix, k) {                                          # k: quantas dimensoes guardar
  s <- svd(ix$w)                                                  # W = U Sigma V'
  U <- s$u[, 1:k, drop = FALSE]; rownames(U) <- ix$vocab          # termos x k
  D <- s$v[, 1:k, drop = FALSE] %*% diag(s$d[1:k], nrow = k)      # documentos x k: V_k Sigma_k
  rownames(D) <- colnames(ix$w)                                   # d1 ... d8
  list(U = U, S = s$d[1:k], D = D)                                # o modelo
}

# Bloco 5
m2 <- lsa(ix, 2)       # LSA com k = 2
round(m2$D, 3)         # os 8 documentos em duas coordenadas

# Bloco 6
q0 <- vetor_consulta(preparar("modelo de recuperacao", cfg), ix$vocab, ix$idf_tfidf)  # 45 pesos
qk <- t(m2$U) %*% q0                                       # (2 x 45) %*% (45): duas coordenadas
round(qk, 3)                                               # a consulta dobrada
round(m2$U[c("de", "modelo", "recuperacao"), ], 3)         # as linhas de U que importam

# Bloco 7
ranking_lsa <- function(consulta, ix, cfg, modelo) {               # modelo: o que lsa() devolve
  q0 <- vetor_consulta(preparar(consulta, cfg), ix$vocab, ix$idf_tfidf)  # texto -> 45 pesos
  qk <- t(modelo$U) %*% q0                                         # dobra: k coordenadas
  s  <- apply(modelo$D, 1, function(d) cosseno(qk, d))             # um cosseno por LINHA (documento)
  sort(s, decreasing = TRUE)                                       # do maior ao menor
}
r2 <- ranking_lsa("modelo de recuperacao", ix, cfg, m2); round(r2, 3)    # o ranking LSA, k = 2
round(metricas(r2, gabarito_aula(), 2), 3)                               # as cinco, limiar 2

# Bloco 8
round(ranking_lsa("busca", ix, cfg, m2), 3)          # no lexico, so d5 e d7
round(ranking_lsa("ranqueamento", ix, cfg, m2), 3)   # no lexico, so d3

# Bloco 9
intersect(ix$tokens$d3, ix$tokens$d8)            # o que d3 e d8 tem em comum
round(cosseno(ix$w[, "d3"], ix$w[, "d8"]), 3)    # na TF-IDF: 45 coordenadas
round(cosseno(m2$D["d3", ], m2$D["d8", ]), 3)    # no LSA: 2 coordenadas

# Bloco 10
rrf <- function(..., c = 60) {                         # ...: quantos rankings vierem
  rks <- list(...)                                     # os rankings, numa lista
  ids <- unique(unlist(lapply(rks, names)))            # todos os documentos que aparecem
  s <- sapply(ids, function(d)                         # para cada documento...
    sum(sapply(rks, function(r) {                      # ...soma sobre os rankings
      p <- which(names(r) == d)                        # a posicao dele neste ranking
      if (length(p)) 1 / (c + p) else 0 })))           # ausente: nao soma nada
  sort(s, decreasing = TRUE)                           # do maior ao menor
}

# Bloco 11
rb <- ranking_bm25("modelo de recuperacao", ix, cfg)   # lexico: d3 d1 d2 d4 d8 d6 d5 d7
rh <- rrf(rb, r2)                                      # funde com o LSA k = 2 (d2 d3 d8 d6 d5 d1 d4 d7)
round(rh, 4)                                           # o hibrido

# Bloco 12
rc <- ranking_cosseno("modelo de recuperacao", ix, cfg); g <- gabarito_aula()  # o cosseno e os graus
round(rbind(cosseno = metricas(rc, g, 2), bm25 = metricas(rb, g, 2),           # lexicos...
            lsa2 = metricas(r2, g, 2), rrf = metricas(rh, g, 2)), 3)           # ...denso e hibrido
