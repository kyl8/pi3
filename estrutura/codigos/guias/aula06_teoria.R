# R | aula06_teoria.R | blocos literais do guia; executar pelo runner.

# Bloco 1
base <- ranking_cosseno("modelo de recuperacao", ix, cfg)  # o ranking da Aula 02
round(base, 3)                                             # escores com nomes
grau <- gabarito_aula()                                    # os graus da Aula 05
round(metricas(base, grau, 2), 3)                          # as cinco da Aula 5,5, limiar 2

# Bloco 2
q0 <- vetor_consulta(tokenizar("modelo de recuperacao"), ix$vocab, ix$idf_tfidf)  # 45 pesos, a regua do corpus
length(q0)              # quantas coordenadas
round(q0[q0 > 0], 3)    # so as nao nulas

# Bloco 3
round(ix$w[c("de", "modelo", "espaco"), c("d2", "d3")], 3)  # tres linhas, duas colunas
cr <- rowMeans(ix$w[, c("d2", "d3")])                       # o centroide: media das colunas, termo a termo
round(cr[c("de", "modelo", "espaco")], 3)                   # as mesmas tres linhas

# Bloco 4
rocchio <- function(q, Dr, Dnr = character(0), ix, a = 1, b = 0.75, g = 0.15) {  # q: vetor; Dr, Dnr: nomes
  cr  <- rowMeans(ix$w[, Dr, drop = FALSE])                                # centroide dos relevantes
  cnr <- if (length(Dnr)) rowMeans(ix$w[, Dnr, drop = FALSE]) else 0       # dos nao relevantes; sem nenhum, 0
  a * q + b * cr - g * cnr                                                 # a formula, termo a termo
}                                                                          # fim da funcao

# Bloco 5
qm <- rocchio(q0, Dr = c("d2", "d3"), Dnr = "d4", ix = ix)  # o gabarito como marcas do usuario
sum(qm != 0)                                                # quantos termos tem a consulta agora
round(head(sort(qm, decreasing = TRUE), 8), 3)              # os de maior peso
round(qm[qm < 0], 3)                                        # os de peso negativo

# Bloco 6
ranking_vetor <- function(q, ix)                  # q: vetor de pesos no espaco de ix$vocab
  sort(apply(ix$w, 2, function(d) cosseno(q, d)), # um cosseno por coluna (apply: Aula 02)
       decreasing = TRUE)                         # do maior ao menor
round(ranking_vetor(q0, ix), 3)                   # teste: tem que dar o ranking base

# Bloco 7
novo <- ranking_vetor(qm, ix)                                             # a consulta reformulada
round(novo, 3)                                                            # o novo ranking
round(rbind(base = metricas(base, grau, 2), rocchio = metricas(novo, grau, 2)), 3)  # antes e depois

# Bloco 8
fora  <- c("d2", "d3", "d4")              # os que o usuario ja marcou
g_res <- grau[!names(grau) %in% fora]     # o gabarito sem eles
b_res <- base[!names(base) %in% fora]     # o ranking base sem eles
n_res <- novo[!names(novo) %in% fora]     # o ranking Rocchio sem eles
round(metricas(b_res, g_res, 2), 3)       # limiar 2: sobra algum relevante?

# Bloco 9
round(rbind(base = metricas(b_res, g_res, 1), rocchio = metricas(n_res, g_res, 1)), 3)  # limiar 1

# Bloco 10
top   <- names(base)[1:2]                    # os 2 primeiros do base: "d1" "d3"
q_prf <- rocchio(q0, top, ix = ix)           # Dr = top-k; Dnr vazio
round(head(sort(q_prf, decreasing = TRUE), 6), 3)  # os termos de maior peso
r_prf <- ranking_vetor(q_prf, ix)            # busca de novo
round(r_prf, 3)                              # o ranking
round(metricas(r_prf, grau, 2), 3)           # as cinco, limiar 2
