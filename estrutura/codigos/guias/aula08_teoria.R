# R | aula08_teoria.R | blocos literais do guia; executar pelo runner.

# Bloco 1
rb <- ranking_bm25("modelo de recuperacao", ix, cfg)   # estagio 1: um escore para CADA documento
round(rb, 3)                                           # o ranking da Aula 04
r <- relevancia(rb, gabarito_aula(), 2)                # relevante (grau >= 2) em cada posicao
r$rel                                                  # 1 = relevante; 0 = nao
sapply(1:4, function(k) recall_k(r$rel, k, r$R))       # que fracao dos relevantes ja esta no top-k

# Bloco 2
docs2 <- docs                                                # uma copia do corpus
docs2[["d2"]] <- paste(rev(ix$tokens$d2), collapse = " ")    # d2 de tras para frente
docs2[["d2"]]                                                # confira: as mesmas palavras, outra ordem
ix2 <- montar(docs2, cfg)                                    # o indice do corpus embaralhado
round(ranking_bm25("modelo de recuperacao", ix2, cfg), 3)    # mudou alguma coisa?

# Bloco 3
outer(c(6, 8), 4, "-")          # posicoes de "de" em d3 (6 e 8) menos a de "modelo" (4)
min(c(2, 4))                    # o menor
TRUE && FALSE                   # "e" de um valor so

# Bloco 4
proximidade <- function(qt, dt, janela = 3) {        # qt: tokens da consulta; dt: tokens do documento
  s <- 0                                             # o escore comeca em zero
  for (i in seq_along(qt)) for (j in seq_along(qt))  # todos os pares de posicoes da consulta...
    if (i < j && qt[i] != qt[j]) {                   # ...com i antes de j e termos diferentes
      pos_i <- which(dt == qt[i])                    # onde o termo i aparece no documento
      pos_j <- which(dt == qt[j])                    # onde o termo j aparece
      if (length(pos_i) && length(pos_j)) {          # os dois aparecem?
        d <- outer(pos_j, pos_i, "-")                # todas as distancias (j menos i)
        d <- d[d > 0 & d <= janela]                  # so j DEPOIS de i, e dentro da janela
        if (length(d)) s <- s + 1 / min(d)           # soma 1 / a menor distancia
      }
    }
  s                                                  # devolve o escore
}

# Bloco 5
qt <- preparar("modelo de recuperacao", cfg)                 # modelo, de, recuperacao
px <- sapply(ix$tokens, function(dt) proximidade(qt, dt))    # um escore por documento
px                                                           # quem tem os termos em ordem e perto?
proximidade(qt, ix2$tokens$d2)                               # e o d2 embaralhado do Modulo 2?

# Bloco 6
order(-c(0.5, 1, 0), 1:3)       # escores 0,5 / 1 / 0: quem vem primeiro?
order(-c(1, 0, 1), 1:3)         # empate entre o 1o e o 3o: desempata a posicao

# Bloco 7
reordenar <- function(rk, k, sc) {               # rk: ranking do estagio 1; sc: escores do estagio 2
  k <- min(k, length(rk))                        # protecao: k nao passa do numero de documentos
  top <- names(rk)[1:k]                          # a cabeca: os k primeiros
  nova <- top[order(-sc[top], seq_along(top))]   # pelo escore, decrescente; empate: ordem do estagio 1
  c(nova, names(rk)[-(1:k)])                     # cabeca reordenada + cauda intacta (NOMES)
}
reordenar(rb, 2, px)            # so d3 e d1 sao relidos
reordenar(rb, 3, px)            # agora d2 entra na cabeca

# Bloco 8
g <- gabarito_aula()                                       # os graus canonicos
round(rbind(bm25 = metricas(rb, g, 2),                     # o estagio 1 sozinho
            k2   = metricas(reordenar(rb, 2, px), g, 2),   # reordenando 2
            k3   = metricas(reordenar(rb, 3, px), g, 2)), 3)  # reordenando 3

# Bloco 9
qb <- preparar("documentos busca", cfg)                       # a ordem trocada
round(ranking_bm25("documentos busca", ix, cfg), 3)           # o BM25 nao liga para ordem
sapply(ix$tokens, function(dt) proximidade(qb, dt))           # o brinquedo liga - demais

# Bloco 10
round(sapply(1:8, function(k) metricas(reordenar(rb, k, px), g, 2)[["AP"]]), 3)   # o AP para cada k
