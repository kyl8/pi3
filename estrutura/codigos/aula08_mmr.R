# Blocos R adaptados do guia Tema 5 da Aula 08, versao 1, para reproducao local.


motor09 <- "https://raw.githubusercontent.com/fractalarea/pi3-motor-de-busca/main/motor/motor09.R"
motor <- tryCatch({source(motor09); "motor09"}, error=function(e) {
  message("motor09 indisponivel: ", conditionMessage(e))
  source("estrutura/codigos/motor-professor/motor08.R", encoding="UTF-8")
  MOTOR_VERSAO
})
docs <- docs_aula()
cfg <- cfg_aula()
ix <- montar(docs, cfg)
cat("Motor:",motor,"; documentos do guia:",length(docs),"\n")


cat("\nModulo 1\n")

rb  <- ranking_bm25("modelo de recuperacao", ix, cfg)   # estagio 1: o BM25 da Aula 04
S   <- t(ix$wn) %*% ix$wn                               # cosseno de todos os pares de documentos
top <- names(rb)[1:4]                                   # os 4 primeiros candidatos
print(round(S[top, top], 3))

print(cosseno(ix$w[, "d3"], ix$w[, "d2"]))
print(max(S[top, top] - diag(1, nrow = 4)))

print(cosseno(ix$w[, "d3"], 2*ix$w[, "d3"]))
print(crossprod(ix$w)[ "d3","d3"])

cat("\nModulo 2\n")

rel <- rb / max(rb)                                     # relevancia entre 0 e 1
print(round(rel[top], 3))

lambda <- 0.5                                           # metade relevancia, metade diversidade
cand <- c("d2", "d4")                                   # passo 3: d3 e d1 ja escolhidos
pen  <- apply(S[cand, c("d3", "d1")], 1, max)           # o maior cosseno com os escolhidos
print(round(lambda * rel[cand] - (1 - lambda) * pen, 3))

source("estrutura/codigos/mmr.R", encoding="UTF-8")

print(round(.5*rel[c("d1","d2","d4")]-.5*S[c("d1","d2","d4"),"d3"],3))
print(mmr(rb,4,rel,S,.5))
print(mmr(rb,4,rel,S,0))
rkx <- c(A=10,B=9.5,C=6)
Sx <- matrix(c(1,.9,.1,.9,1,0,.1,0,1),3,dimnames=list(names(rkx),names(rkx)))
stopifnot(identical(mmr(rkx,3,rkx/max(rkx),Sx,.5),c("A","C","B")))

cat("\nModulo 3\n")

lambdas <- c(0.5, 0.6, 0.7, 0.8, 0.9, 1)                            # os valores testados
print(sapply(lambdas, function(l) paste(mmr(rb, 8, rel, S, l), collapse = " ")))
print(round(sapply(lambdas, function(l) metricas(mmr(rb, 8, rel, S, l), gabarito_aula(), 2)[["AP"]]), 3))

rkt <- c(A = 3, A2 = 2.9, B = 2.5, C = 1)                 # estagio 1: A2 e quase copia de A
St  <- matrix(c(1, 0.95, 0.1, 0,  0.95, 1, 0.1, 0,  0.1, 0.1, 1, 0,  0, 0, 0, 1), 4, byrow = TRUE)   # cossenos
rownames(St) <- colnames(St) <- names(rkt)                # nomes nas linhas e colunas
gt  <- c(A = 2, A2 = 2, B = 1, C = 0)                     # A2 diz o mesmo que A: mesmo grau
mt  <- mmr(rkt, 4, rkt / max(rkt), St, 0.7); print(mt)
print(round(rbind(estagio1 = metricas(rkt, gt, 2), mmr = metricas(mt, gt, 2)), 3))

print(mmr(rb,8,rel,S,0))
print(metricas(mmr(rb,8,rel,S,0),gabarito_aula(),2))
print(c(antes=St["A","A2"],depois=St["A","B"]))
write.csv(data.frame(AP=c(metricas(rkt,gt,2)[["AP"]],metricas(mt,gt,2)[["AP"]]),
  redundancia=c(St["A","A2"],St["A","B"])),
  "estrutura/codigos/resultados/aula08-mmr-exemplo.csv",row.names=FALSE)

gt2 <- c(A=2,A2=2,B=2,C=0)
print(rbind(estagio1=metricas(rkt,gt2,2),mmr=metricas(mt,gt2,2)))

cat("\nModulo 4\n")


# Mesmo corpus, consultas e julgamentos assistidos da Aula 08 do APPA.
source("estrutura/codigos/config.R", encoding="UTF-8")
docs <- readRDS("estrutura/corpus/banco-de-dados/docs.rds")
nec <- read.csv("estrutura/corpus/banco-de-dados/necessidades.csv", fileEncoding="UTF-8")
jud <- read.csv("estrutura/codigos/05-julgamento/csv/2026-11-06-appa-05-qrels-claude.csv", fileEncoding="UTF-8")
stopifnot(all(jud$documento %in% names(docs)), !anyDuplicated(jud[c("consulta","documento")]))
qrels <- lapply(split(jud, jud$consulta), function(x) setNames(x$grau,x$documento))
consultas <- setNames(nec$texto_consulta,nec$consulta)
usar <- names(qrels)[sapply(qrels,function(g) any(g>=cfg$limiar))]
ix <- montar(docs,cfg)
cat("Corpus APPA:",length(docs),"\n")


# sem a decisao da Aula 07 ou da 08 no config.R: os valores padrao do curso
if (is.null(cfg$modelo)) cfg$modelo <- "bm25"   # estagio 1 = BM25 (quem nao fez a Aula 07)
if (is.null(cfg$lsa_k))  cfg$lsa_k  <- 2        # so usado com modelo "lsa" ou "hibrido"
if (is.null(cfg$rrf_c))  cfg$rrf_c  <- 60       # so usado com modelo "hibrido"
if (is.null(cfg$janela)) cfg$janela <- 3        # janela da proximidade (Aula 08)
estagio1 <- function(texto, ix, cfg, m) {                       # o ranking do motor do grupo
  rb <- ranking_bm25(texto, ix, cfg)                            # o BM25, com k1 e b do grupo
  if (cfg$modelo == "bm25") return(rb)                          # modelo "bm25": pronto
  rl <- ranking_lsa(texto, ix, cfg, m)                          # o LSA da Aula 07 (m = lsa(ix, k))
  if (cfg$modelo == "lsa") rl else rrf(rb, rl, c = cfg$rrf_c)   # "lsa", ou o hibrido pela RRF
}                                                               # fim da funcao
m <- if (cfg$modelo == "bm25") NULL else lsa(ix, cfg$lsa_k)     # o LSA so e calculado se usado

dev   <- intersect(usar, nec$consulta[nec$conjunto == "dev"])                 # aqui se escolhe
teste <- intersect(usar, nec$consulta[nec$conjunto == "teste"])               # so no fim, uma vez
rks   <- lapply(consultas[usar], function(texto) estagio1(texto, ix, cfg, m)) # o estagio 1 do grupo

medida <- function(r, grau, wn, limiar, qual)             # uma medida de UM ranking
  if (qual == "red") redund(r, wn) else metricas(r, grau, limiar)[[qual]]   # "red", "AP" ou "nDCG_grad"

lambdas <- c(1, 0.9, 0.7, 0.5)                            # os valores testados
grade <- sapply(c("AP", "nDCG_grad", "red"), function(qual) sapply(lambdas, function(l)   # cada medida...
  mean(sapply(dev, function(q) medida(rerank_mmr(rks[[q]], ix$wn, 10, l), qrels[[q]], ix$wn, cfg$limiar, qual)))))   # ...media no dev
rownames(grade) <- paste("lambda", lambdas); print(round(grade, 3))

# 0.7 e o exemplo proposto no guia. Teste conhecido, sem escolha do grupo.
l_esc <- 0.7
antes  <- sapply(dev, function(q) medida(names(rks[[q]]), qrels[[q]], ix$wn, cfg$limiar, "AP"))   # AP do estagio 1
depois <- sapply(dev, function(q) medida(rerank_mmr(rks[[q]], ix$wn, 10, l_esc), qrels[[q]], ix$wn, cfg$limiar, "AP"))   # AP com o MMR
print(dev[depois > antes]); print(dev[depois < antes])
ap_teste <- sapply(teste, function(q) sapply(c(antes=1, depois=l_esc), function(l)
  medida(rerank_mmr(rks[[q]], ix$wn, 10, l), qrels[[q]], ix$wn, cfg$limiar, "AP")))
print(round(ap_teste, 3))
write.csv(data.frame(consulta=colnames(ap_teste), antes=ap_teste[1,], depois=ap_teste[2,]),
  "estrutura/codigos/resultados/aula08-mmr-teste.csv", row.names=FALSE)
q <- "q01"
exemplo_top <- do.call(rbind, lapply(lambdas, function(l) {
  ids <- head(rerank_mmr(rks[[q]], ix$wn,10,l),5)
  data.frame(lambda=l, posicao=seq_along(ids), id=ids, texto=unname(docs[ids]))
}))
write.csv(exemplo_top,"estrutura/codigos/resultados/aula08-mmr-top.csv",row.names=FALSE,fileEncoding="UTF-8")

dir.create("estrutura/codigos/resultados",showWarnings=FALSE)
write.csv(data.frame(lambda=lambdas,grade),"estrutura/codigos/resultados/aula08-mmr-dev.csv",row.names=FALSE)
# Ler os textos do top-5 em uma consulta de cada tipo, quando houver.
for (q in c(head(dev[depois>antes],1),head(dev[depois<antes],1))) {
  cat("\nLeitura do top-5",q,"\n")
  for (ord in list(names(rks[[q]]),rerank_mmr(rks[[q]],ix$wn,10,l_esc)))
    print(docs[head(ord,5)])
}
stopifnot(which.max(c(.5*.8-.5*.2,.5*.7))==2)
