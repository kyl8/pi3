# Avaliação reproduzível dos dois rankings com um gabarito simples por clube.
# O gabarito deve ser revisado por pessoas antes de ser usado em um relatório final.

source("estrutura/codigos/2026-09-04-appa-MotorBuscaBm25.r")
dir.create("estrutura/resultados", showWarnings = FALSE, recursive = TRUE)

necessidades <- data.frame(
  id = c("q01", "q02", "q03", "q04", "q05", "q06"),
  consulta = c("historia santos futebol clube", "titulos santos", "portuguesa santista estadio", "jabaquara clube", "rivalidade santos", "estadio jabaquara"),
  clube_esperado = c("Santos FC", "Santos FC", "Portuguesa Santista", "Jabaquara", "Santos FC", "Jabaquara"),
  stringsAsFactors = FALSE
)

avaliar_ranking <- function(ranking, clube_esperado, k = 10) {
  ranking <- head(ranking, k)
  relevantes <- as.integer(doc_origem[names(ranking)] == clube_esperado)
  primeiro <- which(relevantes == 1)
  data.frame(
    p_at_k = mean(relevantes),
    recall_at_k = ifelse(sum(doc_origem == clube_esperado) > 0, sum(relevantes) / sum(doc_origem == clube_esperado), NA),
    reciprocal_rank = ifelse(length(primeiro), 1 / primeiro[1], 0)
  )
}

resultados <- do.call(rbind, lapply(seq_len(nrow(necessidades)), function(i) {
  q <- necessidades$consulta[i]
  bm <- avaliar_ranking(rankear_bm25(q, 10), necessidades$clube_esperado[i])
  tf <- avaliar_ranking(rankear_tfidf(q, 10), necessidades$clube_esperado[i])
  rbind(
    data.frame(consulta = q, modelo = "BM25", bm),
    data.frame(consulta = q, modelo = "TF-IDF", tf)
  )
}))

write.csv2(resultados, "estrutura/resultados/2026-09-15-appa-05-MetricasRanking.csv", row.names = FALSE)
write.csv2(necessidades, "estrutura/resultados/2026-09-15-appa-05-Necessidades.csv", row.names = FALSE)
print(resultados)
