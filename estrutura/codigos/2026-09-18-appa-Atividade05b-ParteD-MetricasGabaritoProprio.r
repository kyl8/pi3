# -----------------------------------------------------------------------------
# Projeto Integrador III - Ciência de Dados (FATEC)
# Aula 5,5 - Parte D: As Métricas no Seu Próprio Gabarito (qrels.csv)
# Comparação Completa: BM25 vs. TF-IDF (Similaridade do Cosseno)
# Grupo APPA - 18/09/2026
# -----------------------------------------------------------------------------
# IMPORTANTE: executar a partir da raiz do repositório (pi3/)
# Se necessário, ajuste o diretório de trabalho:
# setwd("caminho/para/pi3")

# 1. Carregamento dos Motores de Busca e Dados de Julgamento
source("estrutura/codigos/2026-09-04-appa-MotorBuscaBm25.r")

dir_csv <- "estrutura/codigos/05-julgamento/csv"
dir_resultados <- "estrutura/resultados"
dir.create(dir_resultados, showWarnings = FALSE, recursive = TRUE)

necessidades <- read.csv(file.path(dir_csv, "2026-09-15-appa-05-necessidades.csv"),
                         stringsAsFactors = FALSE, encoding = "UTF-8")
qrels_completo <- read.csv(file.path(dir_csv, "2026-09-15-appa-05-qrels.csv"),
                           stringsAsFactors = FALSE, encoding = "UTF-8")

# Função de DCG com desconto logarítmico em base 2 (Módulo 7)
dcg <- function(r) {
  sum(r / log2(seq_along(r) + 1))
}

# -----------------------------------------------------------------------------
# 2. Função de Cálculo das Cinco Métricas para um Ranking e Gabarito
# -----------------------------------------------------------------------------
calcular_metricas_consulta <- function(ranking_docs, grau_nomeado, limiar = 1, k = 10) {
  ranking <- head(ranking_docs, k)
  
  # Identifica os relevantes conforme o limiar escolhido (Módulo 10)
  relevantes <- names(grau_nomeado)[grau_nomeado >= limiar]
  R <- length(relevantes)
  
  # Se não houver nenhum relevante no gabarito para este limiar
  if (R == 0) {
    return(data.frame(
      P_at_3 = NA,
      AP = NA,
      MRR = NA,
      nDCG_bin = NA,
      nDCG_grad = NA,
      R_total = 0
    ))
  }
  
  # Vetor rel binário reordenado pelo ranking (Módulo 10)
  rel <- as.integer(ranking %in% relevantes)
  
  # P@k e R@k com contagem acumulada (Módulo 4)
  precisao <- cumsum(rel) / seq_along(rel)
  
  # Average Precision com divisão obrigatória por R (Módulo 5)
  ap <- sum(precisao[rel == 1]) / R
  
  # Reciprocal Rank (MRR) - posição do primeiro relevante (Módulo 6)
  primeiro <- which(rel == 1)
  mrr <- if (length(primeiro) > 0) 1 / primeiro[1] else 0
  
  # nDCG Binário (Módulo 7)
  idcg_bin <- dcg(sort(rel, decreasing = TRUE))
  ndcg_bin <- if (idcg_bin > 0) dcg(rel) / idcg_bin else 0
  
  # nDCG Graduado com tratamento de pooling para não julgados (Módulo 8 e 11)
  g <- grau_nomeado[ranking]
  g[is.na(g)] <- 0  # Documentos fora da pool recebem grau 0
  idcg_grad <- dcg(head(sort(grau_nomeado, decreasing = TRUE), k))
  ndcg_grad <- if (idcg_grad > 0) dcg(g) / idcg_grad else 0
  
  data.frame(
    P_at_3 = round(precisao[min(3, length(precisao))], 3),
    AP = round(ap, 3),
    MRR = round(mrr, 3),
    nDCG_bin = round(ndcg_bin, 3),
    nDCG_grad = round(ndcg_grad, 3),
    R_total = R
  )
}

# -----------------------------------------------------------------------------
# 3. Execução para Todas as Consultas (Módulos 11 e 12)
# -----------------------------------------------------------------------------
cat("\n=======================================================\n")
cat("AVALIAÇÃO COMPARATIVA NO PRÓPRIO GABARITO (PARTE D)\n")
cat("=======================================================\n")

# Avaliação com Limiar Amplo (grau >= 1): cobre todas as 6 consultas
# Justificativa: na consulta q06 todos os parágrafos relevantes têm grau 1 (nenhum grau 2).
resultados_ge1 <- do.call(rbind, lapply(seq_len(nrow(necessidades)), function(i) {
  id_q <- necessidades$id[i]
  q_txt <- necessidades$texto_consulta[i]
  
  linhas_q <- qrels_completo[qrels_completo$consulta == id_q, ]
  grau_q <- setNames(linhas_q$grau, linhas_q$documento)
  
  # Rankings dos motores
  rk_bm25 <- names(head(rankear_bm25(q_txt, 10), 10))
  rk_cos  <- names(head(rankear_tfidf(q_txt, 10), 10))
  
  m_bm25 <- calcular_metricas_consulta(rk_bm25, grau_q, limiar = 1, k = 10)
  m_cos  <- calcular_metricas_consulta(rk_cos,  grau_q, limiar = 1, k = 10)
  
  rbind(
    data.frame(id = id_q, consulta = q_txt, modelo = "BM25", limiar = "grau >= 1", m_bm25),
    data.frame(id = id_q, consulta = q_txt, modelo = "TF-IDF", limiar = "grau >= 1", m_cos)
  )
}))

cat("\n--- Tabela de Resultados (Limiar grau >= 1) ---\n")
print(resultados_ge1)

# Avaliação com Limiar Estrito (grau >= 2) para q01 a q05
resultados_ge2 <- do.call(rbind, lapply(seq_len(nrow(necessidades)), function(i) {
  id_q <- necessidades$id[i]
  q_txt <- necessidades$texto_consulta[i]
  
  linhas_q <- qrels_completo[qrels_completo$consulta == id_q, ]
  grau_q <- setNames(linhas_q$grau, linhas_q$documento)
  
  rk_bm25 <- names(head(rankear_bm25(q_txt, 10), 10))
  rk_cos  <- names(head(rankear_tfidf(q_txt, 10), 10))
  
  m_bm25 <- calcular_metricas_consulta(rk_bm25, grau_q, limiar = 2, k = 10)
  m_cos  <- calcular_metricas_consulta(rk_cos,  grau_q, limiar = 2, k = 10)
  
  rbind(
    data.frame(id = id_q, consulta = q_txt, modelo = "BM25", limiar = "grau >= 2", m_bm25),
    data.frame(id = id_q, consulta = q_txt, modelo = "TF-IDF", limiar = "grau >= 2", m_cos)
  )
}))

cat("\n--- Tabela de Resultados (Limiar grau >= 2) ---\n")
cat("Nota: q06 apresentará NA porque não possui documentos com grau 2.\n")
print(resultados_ge2)

# -----------------------------------------------------------------------------
# 4. Cálculo de MAP e Comparativo Global (Módulo 12)
# -----------------------------------------------------------------------------
map_bm25 <- mean(resultados_ge1$AP[resultados_ge1$modelo == "BM25"], na.rm = TRUE)
map_cos  <- mean(resultados_ge1$AP[resultados_ge1$modelo == "TF-IDF"], na.rm = TRUE)

cat("\n=======================================================\n")
cat(sprintf("MAP GLOBAL (grau >= 1, 6 consultas):\n"))
cat(sprintf("  - BM25:   %.3f\n", map_bm25))
cat(sprintf("  - TF-IDF: %.3f\n", map_cos))
cat("=======================================================\n")

# Salvamento das métricas completas em CSV
todos_resultados <- rbind(resultados_ge1, resultados_ge2)
write.csv2(todos_resultados, file.path(dir_resultados, "2026-09-18-appa-05b-MetricasGabaritoProprio.csv"),
           row.names = FALSE)
cat("\nArquivo de métricas salvo em: estrutura/resultados/2026-09-18-appa-05b-MetricasGabaritoProprio.csv\n")
