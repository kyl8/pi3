# R | aula05b_teoria.R | blocos literais do guia; executar pelo runner.

# Bloco 1
rk_bm25 <- ranking_bm25("modelo de recuperacao", ix, cfg)  # escores BM25, do maior ao menor (Aula 04)
ranking <- names(rk_bm25)                    # so os nomes, na ordem: ISTO e o ranking
grau    <- gabarito_aula()                   # os graus 0/1/2 da Aula 05, julgados ANTES
limiar  <- 2                                 # "relevante" = grau 2 ou mais: a decisao desta aula
relevantes <- names(grau)[grau >= limiar]    # os nomes dos relevantes
rel <- as.integer(ranking %in% relevantes)   # 1 na posicao i se ranking[i] e relevante
rel                                          # o gabarito, na ordem do ranking

# Bloco 2
R <- length(relevantes)   # 2 relevantes no gabarito
k <- seq_along(rel)       # posicoes de corte: 1, 2, ..., 8
acertos  <- cumsum(rel)   # quantos relevantes ate a posicao k
precisao <- acertos / k   # acertos sobre o que foi MOSTRADO
recall   <- acertos / R   # acertos sobre o TOTAL de relevantes

# Bloco 3
tabela <- round(rbind(P_at_k = precisao, R_at_k = recall), 3)   # duas linhas, 8 colunas, 3 casas
colnames(tabela) <- paste0("k=", k)                             # nomeia as colunas: k=1 ... k=8
tabela                                                          # mostra

# Bloco 4
plot(k, precisao, type = "b", ylim = c(0, 1),     # a precisao em cada corte, pontos ligados
     xlab = "k (corte no ranking)", ylab = "")   # nomes dos eixos
lines(k, recall, type = "b", lty = 2)             # o recall, tracejado, no mesmo grafico

# Bloco 5
precisao[rel == 1]                  # as precisoes nas posicoes com relevante
ap <- sum(precisao[rel == 1]) / R   # soma dividida por R -- NAO pelo numero de parcelas
round(ap, 3)                        # 3 casas

# Bloco 6
which(rel == 1)                 # as posicoes de TODOS os relevantes
mrr <- 1 / which(rel == 1)[1]   # [1] pega so a primeira posicao
mrr                             # o RR desta consulta (= MRR, com uma consulta so)

# Bloco 7
dcg  <- function(g) sum(g / log2(seq_along(g) + 1))   # cada ganho dividido por log2(i+1), somados
ndcg <- dcg(rel) / dcg(sort(rel, decreasing = TRUE))  # ideal = os MESMOS ganhos, em ordem decrescente
round(ndcg, 3)                                        # 3 casas

# Bloco 8
g <- grau[ranking]   # o grau de cada documento, NA ORDEM do ranking
g                    # vetor nomeado: os nomes vem junto

# Bloco 9
ndcg_g <- dcg(g) / dcg(sort(g, decreasing = TRUE))   # a mesma funcao, agora com os graus
round(ndcg_g, 3)                                     # 3 casas

# Bloco 10
resumo <- c(P_at_3 = precisao[[3]], AP = ap, MRR = mrr,   # [[3]]: o 3o valor, P@3
            nDCG_bin = ndcg, nDCG_grad = ndcg_g)          # as cinco, com nome
round(resumo, 3)                                          # 3 casas
