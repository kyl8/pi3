# -----------------------------------------------------------------------------
# Projeto Integrador III - Ciência de Dados (FATEC)
# Aula 5,5 - Métricas de Avaliação: P@k, R@k, MAP, MRR e nDCG
# Script de Cálculo Canônico e Exploração Experimental
# Grupo APPA - 18/09/2026
# -----------------------------------------------------------------------------

# 1. Cenário Canônico da Aula (Slides 3 e 4)
ranking <- c("d3", "d1", "d2", "d4", "d8", "d6", "d5", "d7")  # Saída BM25 (Aula 04)
grau <- c(d1 = 1, d2 = 2, d3 = 2, d4 = 0,                     # Gabarito julgado (Aula 05)
          d5 = 0, d6 = 1, d7 = 0, d8 = 0)

# Binarização: "relevante" = grau 2 (limiar estrito)
relevantes <- names(grau)[grau == 2]                           # "d2" e "d3"
R <- length(relevantes)                                        # Total de relevantes no corpus (R = 2)

# Vetor rel: gabarito reordenado pelo ranking (Módulo 1)
rel <- as.integer(ranking %in% relevantes)
cat("--- Módulo 1: Vetor rel ---\n")
print(rel)

# 2. P@k e R@k para todos os cortes (Módulo 4)
k <- seq_along(ranking)
acertos <- cumsum(rel)
precisao <- acertos / k
recall <- acertos / R

tabela_pr <- round(rbind(P_at_k = precisao, R_at_k = recall), 3)
colnames(tabela_pr) <- paste0("k=", k)
cat("\n--- Módulo 4: Tabela P@k e R@k ---\n")
print(tabela_pr)

# 3. Average Precision (AP) (Módulo 5)
# A precisão é somada apenas onde rel == 1 e dividida por R (não pelo número de acertos recuperados)
ap <- sum(precisao[rel == 1]) / R
cat("\n--- Módulo 5: Average Precision (AP) ---\n")
cat("Precisões nos relevantes:", precisao[rel == 1], "\n")
cat("AP:", round(ap, 3), "\n")

# 4. Reciprocal Rank (MRR) (Módulo 6)
# Considera estritamente a posição do primeiro documento relevante
mrr <- 1 / which(rel == 1)[1]
cat("\n--- Módulo 6: Reciprocal Rank (RR/MRR) ---\n")
cat("Primeiro relevante na posição:", which(rel == 1)[1], "\n")
cat("MRR:", round(mrr, 3), "\n")

# 5. nDCG Binário e Graduado (Módulos 7 e 8)
dcg <- function(r) {
  sum(r / log2(seq_along(r) + 1))
}

# nDCG Binário
idcg_bin <- dcg(sort(rel, decreasing = TRUE))
ndcg_bin <- dcg(rel) / idcg_bin

# nDCG Graduado (usa os graus reais 0, 1, 2)
g <- grau[ranking]
idcg_grad <- dcg(sort(g, decreasing = TRUE))
ndcg_grad <- dcg(g) / idcg_grad

cat("\n--- Módulos 7 e 8: nDCG ---\n")
cat("nDCG Binário:", round(ndcg_bin, 3), "\n")
cat("DCG Graduado:", round(dcg(g), 3), "IDCG Graduado:", round(idcg_grad, 3), "\n")
cat("nDCG Graduado:", round(ndcg_grad, 3), "\n")

# 6. Resumo das Cinco Métricas Lado a Lado (Slide 23)
resumo <- c(P_at_3 = precisao[[3]], AP = ap, MRR = mrr,
            nDCG_bin = ndcg_bin, nDCG_grad = ndcg_grad)
cat("\n--- Resumo das Cinco Métricas ---\n")
print(round(resumo, 3))


# =============================================================================
# Explorações do Slide 26 (Tarefa de Casa 1)
# =============================================================================
cat("\n==================================================\n")
cat("Explorações do Slide 26 (Tarefa 1)\n")
cat("==================================================\n")

# A. Inverter o ranking (rev(ranking))
ranking_rev <- rev(ranking)
rel_rev <- as.integer(ranking_rev %in% relevantes)
g_rev <- grau[ranking_rev]
prec_rev <- cumsum(rel_rev) / seq_along(ranking_rev)
ap_rev <- sum(prec_rev[rel_rev == 1]) / R
mrr_rev <- 1 / which(rel_rev == 1)[1]
ndcg_bin_rev <- dcg(rel_rev) / idcg_bin
ndcg_grad_rev <- dcg(g_rev) / idcg_grad

cat("\nA. Efeito da Inversão do Ranking (rev(ranking)):\n")
resumo_rev <- c(P_at_3 = prec_rev[[3]], AP = ap_rev, MRR = mrr_rev,
                nDCG_bin = ndcg_bin_rev, nDCG_grad = ndcg_grad_rev)
print(round(resumo_rev, 3))

# B. Alteração do limiar binário para grau >= 1
relevantes_ge1 <- names(grau)[grau >= 1]
R_ge1 <- length(relevantes_ge1)
rel_ge1 <- as.integer(ranking %in% relevantes_ge1)
prec_ge1 <- cumsum(rel_ge1) / seq_along(ranking)
ap_ge1 <- sum(prec_ge1[rel_ge1 == 1]) / R_ge1
mrr_ge1 <- 1 / which(rel_ge1 == 1)[1]
ndcg_bin_ge1 <- dcg(rel_ge1) / dcg(sort(rel_ge1, decreasing = TRUE))

cat("\nB. Efeito do Limiar Binário grau >= 1 (R = 4):\n")
cat("P@3:", round(prec_ge1[[3]], 3),
    "AP:", round(ap_ge1, 3),
    "MRR:", round(mrr_ge1, 3),
    "nDCG_bin:", round(ndcg_bin_ge1, 3), "\n")

# C. Troca do desconto log2(i+1) por linear 1/i
dcg_linear <- function(r) {
  sum(r / seq_along(r))
}
ndcg_lin_bin <- dcg_linear(rel) / dcg_linear(sort(rel, decreasing = TRUE))
ndcg_lin_grad <- dcg_linear(g) / dcg_linear(sort(g, decreasing = TRUE))

cat("\nC. Efeito do Desconto Linear (1/i) vs Logarítmico (1/log2(i+1)):\n")
cat("nDCG Linear Binário:", round(ndcg_lin_bin, 3), "(vs log:", round(ndcg_bin, 3), ")\n")
cat("nDCG Linear Graduado:", round(ndcg_lin_grad, 3), "(vs log:", round(ndcg_grad, 3), ")\n")

# D. Mover d6 da 6ª para a 4ª posição
ranking_d6 <- c("d3", "d1", "d2", "d6", "d4", "d8", "d5", "d7")
rel_d6 <- as.integer(ranking_d6 %in% relevantes)
g_d6 <- grau[ranking_d6]
prec_d6 <- cumsum(rel_d6) / seq_along(ranking_d6)
ap_d6 <- sum(prec_d6[rel_d6 == 1]) / R
mrr_d6 <- 1 / which(rel_d6 == 1)[1]
ndcg_bin_d6 <- dcg(rel_d6) / idcg_bin
ndcg_grad_d6 <- dcg(g_d6) / idcg_grad

cat("\nD. Efeito de mover d6 da 6ª para a 4ª posição:\n")
cat("P@3:", round(prec_d6[[3]], 3),
    "AP:", round(ap_d6, 3),
    "MRR:", round(mrr_d6, 3),
    "nDCG_bin:", round(ndcg_bin_d6, 3),
    "nDCG_grad:", round(ndcg_grad_d6, 3), "\n")
