source("estrutura/codigos/motor-professor/motor08.R", local = TRUE, encoding = "UTF-8")
source("estrutura/codigos/aula07_funcoes.R", local = TRUE, encoding = "UTF-8")
docs <- docs_aula(); cfg <- cfg_aula(); ix <- montar(docs, cfg)
consultas <- c("modelo vetorial", "documentos busca")
saida <- do.call(rbind, lapply(consultas, function(q) {
  rk <- ranking_bm25(q, ix, cfg); qt <- preparar(q, cfg)
  do.call(rbind, lapply(c(0,2,4), function(k) {
    ids <- names(reordenar_appa(rk, qt, ix, k, 3))
    data.frame(consulta=q, k=k, posicao=seq_along(ids), documento=ids, texto=unname(docs[ids]))
  }))
}))
write.csv(saida, "estrutura/resultados/aula08-tarefa-teoria.csv", row.names=FALSE, fileEncoding="UTF-8")
print(saida[,1:4])
