# Execute na raiz do PI III. Mede o mesmo motor usado pela interface.
source("entregas/entrega-final/motor/busca.R", encoding = "UTF-8")
necessidades <- read.csv(file.path(pasta_corpus, "necessidades.csv"), fileEncoding = "UTF-8")
graus <- read.csv("estrutura/codigos/05-julgamento/csv/2026-11-06-appa-05-qrels-claude.csv",
                  fileEncoding = "UTF-8")
dev <- subset(necessidades, conjunto == "dev")
tabela <- do.call(rbind, lapply(seq_len(nrow(dev)), function(i) {
  consulta <- dev[i, ]
  r <- buscar(consulta$texto_consulta, "hibrido", "mmr", lambda = 0.7)
  g <- graus[graus$consulta == consulta$consulta, ]
  g <- setNames(g$grau, g$documento)
  data.frame(consulta = consulta$consulta,
    ap_antes = unname(metricas(r$inicial, g, cfg$limiar)[["AP"]]),
    ap_depois = unname(metricas(r$final, g, cfg$limiar)[["AP"]]),
    red_antes = unname(r$redundancia[["antes"]]),
    red_depois = unname(r$redundancia[["depois"]]),
    top_antes = paste(head(r$inicial, 5), collapse = " "),
    top_depois = paste(head(r$final, 5), collapse = " "))
}))
write.csv(tabela, "estrutura/codigos/resultados/aula08-mmr-motor-dev.csv", row.names = FALSE)
print(tabela)
