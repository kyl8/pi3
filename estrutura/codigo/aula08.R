# Aula 08: proximidade ordenada no corpus APPA; avaliacao assistida.
source("estrutura/codigos/motor-appa.R", local = TRUE, encoding = "UTF-8")
source("estrutura/codigos/aula07_funcoes.R", local = TRUE, encoding = "UTF-8")
source("estrutura/codigos/config.R", local = TRUE, encoding = "UTF-8")
corpus <- read.csv("estrutura/codigos/05-julgamento/csv/2026-09-15-appa-05-corpus.csv", fileEncoding = "UTF-8")
nec <- read.csv("estrutura/banco-de-dados/necessidades.csv", fileEncoding = "UTF-8")
qrels <- read.csv("estrutura/codigos/05-julgamento/csv/2026-11-06-appa-05-qrels-claude.csv", fileEncoding = "UTF-8")
ix <- montar(setNames(corpus$texto, corpus$id), cfg); m <- lsa(ix, cfg$lsa_k)
reordenar <- function(rk, qt, k, janela) {
  names(reordenar_appa(rk, qt, ix, k, janela))
}
stopifnot(proximidade(c("a","b"),c("a","x","b"),3)==0.5, proximidade(c("a","b"),c("b","a"),3)==0)
stopifnot(identical(reordenar_appa(c(a=3,b=2), c("a","b"), list(tokens=list(a=c("b","a"),b=c("a","b"))), 0, 2), c(a=3,b=2)), identical(names(reordenar_appa(c(a=3,b=2), c("a","b"), list(tokens=list(a=c("b","a"),b=c("a","b"))), 2, 2)), c("b","a")))
result <- list()
for (i in seq_len(nrow(nec))) {
  q <- nec[i, ]; bm <- ranking_bm25(q$texto_consulta, ix, cfg); ls <- ranking_lsa(q$texto_consulta, ix, cfg, m)
  rk <- rrf(bm, ls, c = cfg$rrf_c); qt <- preparar(q$texto_consulta, cfg)
  gs <- qrels[qrels$consulta == q$consulta, ]; g <- setNames(gs$grau, gs$documento)
  for (k in c(0,3,5,10)) for (w in if (k == 0) 0 else c(2,3,5)) {
    if (q$conjunto != "dev" && k != 0) next
    ord <- if (k == 0) names(rk) else reordenar(rk, qt, k, w)
    result[[length(result)+1]] <- data.frame(consulta=q$consulta, conjunto=q$conjunto, k=k, janela=w, AP=unname(metricas(ord,g,2)["AP"]))
  }
}
tab <- do.call(rbind,result); dev <- aggregate(AP ~ k + janela, subset(tab, conjunto == "dev"), mean)
dev <- dev[order(-dev$AP,dev$k,dev$janela), ]; choice <- dev[1, ]
for (i in which(nec$conjunto != "dev")) {
  q <- nec[i, ]; rk <- rrf(ranking_bm25(q$texto_consulta,ix,cfg),ranking_lsa(q$texto_consulta,ix,cfg,m),c=cfg$rrf_c)
  gs <- qrels[qrels$consulta == q$consulta, ]; g <- setNames(gs$grau,gs$documento)
  ord <- if(choice$k == 0) names(rk) else reordenar(rk,preparar(q$texto_consulta,cfg),choice$k,choice$janela)
  tab <- rbind(tab,data.frame(consulta=q$consulta,conjunto=q$conjunto,k=choice$k,janela=choice$janela,AP=unname(metricas(ord,g,2)["AP"])))
}
write.csv(tab,"estrutura/resultados/aula08-avaliacao-assistida.csv",row.names=FALSE)
write.csv(dev,"estrutura/resultados/aula08-grade-dev.csv",row.names=FALSE)
comparacao <- do.call(rbind, lapply(which(nec$consulta %in% c("q01", "q04")), function(i) {
  q <- nec[i, ]; rk <- rrf(ranking_bm25(q$texto_consulta, ix, cfg), ranking_lsa(q$texto_consulta, ix, cfg, m), c=cfg$rrf_c)
  antes <- names(rk); depois <- reordenar(rk, preparar(q$texto_consulta, cfg), 10, 2)
  ids <- unique(c(head(antes, 10), head(depois, 10)))
  data.frame(consulta=q$consulta, documento=ids, pos_antes=match(ids, antes), pos_depois=match(ids, depois), texto=corpus$texto[match(ids, corpus$id)])
}))
write.csv(comparacao, "estrutura/resultados/aula08-comparacao-textos.csv", row.names=FALSE, fileEncoding="UTF-8")
print(dev); print(subset(tab,conjunto != "dev"))
memoria <- list2env(list(MOTOR_VERSAO=MOTOR_VERSAO, cfg=cfg, ix=ix, nec=nec, qrels=qrels, dev=dev, choice=choice, tab=tab, proximidade=proximidade, reordenar_appa=reordenar_appa))
anexar_estado("consolidados/aula08_parteD_consolidado.md", env=memoria)
