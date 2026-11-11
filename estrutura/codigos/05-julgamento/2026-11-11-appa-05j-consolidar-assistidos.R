# Consolida referencias de IA; nao gera votos de pessoas nem kappa humano.
source("estrutura/codigos/motor-appa.R", local=TRUE, encoding="UTF-8")
source("estrutura/codigos/aula07_funcoes.R", local=TRUE, encoding="UTF-8")
source("estrutura/codigos/config.R", local=TRUE, encoding="UTF-8")
base <- "estrutura/codigos/05-julgamento/csv"
cl <- read.csv(file.path(base,"2026-11-06-appa-05-qrels-claude.csv"), fileEncoding="UTF-8")
cx <- read.csv(file.path(base,"2026-10-25-appa-05-qrels-assistidos.csv"), fileEncoding="UTF-8")
pool <- read.csv(file.path(base,"2026-11-06-appa-05-pool-v2.csv"), fileEncoding="UTF-8")
chave <- function(d) paste(d$consulta, d$documento, sep="/")
stopifnot(!anyDuplicated(chave(cl)), !anyDuplicated(chave(cx)), all(chave(pool) %in% chave(cl)))
compar <- merge(cl[,c("consulta","documento","grau")], cx[,c("consulta","documento","grau")], by=c("consulta","documento"), suffixes=c("_claude","_codex"))
ajuste <- data.frame(consulta=c("q01","q05","q05"), documento=c("d70","d107","d26"), grau=c(1L,2L,1L), justificativa=c("Contexto historico de confronto do Santos, sem tratar de sua formacao.","Descreve confronto do Santos e Olympiacos e sua repercussao.","Jogo amistoso de contexto, sem rivalidade entre clubes identificada."))
discord <- compar[compar$grau_claude != compar$grau_codex, ]
stopifnot(setequal(chave(discord), chave(ajuste)))
out <- cl[,c("consulta","documento","grau")]
out <- rbind(out, cx[!chave(cx) %in% chave(out),c("consulta","documento","grau")])
out$grau[match(chave(ajuste),chave(out))] <- ajuste$grau
out$origem <- ifelse(chave(out) %in% chave(ajuste), "revisao_chatgpt", ifelse(chave(out) %in% chave(cl) & chave(out) %in% chave(cx), "acordo_assistido", ifelse(chave(out) %in% chave(cl), "claude_leitura", "codex_assistido")))
out <- out[order(out$consulta,as.integer(sub("d","",out$documento))), ]
stopifnot(!anyDuplicated(chave(out)), all(out$grau %in% 0:2), all(chave(pool) %in% chave(out)))
write.csv(out,file.path(base,"2026-11-11-appa-05-qrels-consolidado-assistido.csv"),row.names=FALSE,fileEncoding="UTF-8")
write.csv(merge(discord, ajuste, by=c("consulta","documento")),"estrutura/resultados/2026-11-11-appa-divergencias-assistidas.csv",row.names=FALSE,fileEncoding="UTF-8")
kap <- function(a,b,niveis) { tab <- table(factor(a,levels=niveis),factor(b,levels=niveis)); n <- sum(tab); po <- sum(diag(tab))/n; pe <- sum(rowSums(tab)*colSums(tab))/n^2; c(n=n,acordo=po,kappa=if(pe==1) NA else (po-pe)/(1-pe)) }
com_pool <- compar[chave(compar) %in% chave(pool), ]
k <- rbind(tres_niveis_geral=kap(compar$grau_claude,compar$grau_codex,0:2), binario_geral=kap(compar$grau_claude>=2,compar$grau_codex>=2,c(FALSE,TRUE)), tres_niveis_pool=kap(com_pool$grau_claude,com_pool$grau_codex,0:2))
write.csv(data.frame(escala=rownames(k),k,row.names=NULL),"estrutura/resultados/2026-11-11-appa-kappa-assistido.csv",row.names=FALSE)
corpus <- read.csv(file.path(base,"2026-09-15-appa-05-corpus.csv"),fileEncoding="UTF-8")
nec <- read.csv("estrutura/banco-de-dados/necessidades.csv",fileEncoding="UTF-8")
ix <- montar(setNames(corpus$texto,corpus$id),cfg); mod <- lsa(ix,cfg$lsa_k)
res <- do.call(rbind,lapply(seq_len(nrow(nec)),function(i) {
 q <- nec[i,]; g <- out[out$consulta==q$consulta,]; graus <- setNames(g$grau,g$documento)
 b <- ranking_bm25(q$texto_consulta,ix,cfg); l <- ranking_lsa(q$texto_consulta,ix,cfg,mod)
 modelos <- list(bm25=b,cosseno=ranking_cosseno(q$texto_consulta,ix,cfg),lsa=l,hibrido=rrf(b,l,c=cfg$rrf_c))
 do.call(rbind,lapply(names(modelos),function(m) data.frame(consulta=q$consulta,conjunto=q$conjunto,modelo=m,AP=unname(metricas(modelos[[m]],graus,2)["AP"]),relevantes=sum(g$grau>=2))))
}))
placar <- aggregate(AP ~ conjunto+modelo,res,mean)
write.csv(res,"estrutura/resultados/2026-11-11-appa-modelos-assistidos.csv",row.names=FALSE)
write.csv(placar,"estrutura/resultados/2026-11-11-appa-placar-assistido.csv",row.names=FALSE)
print(k); print(placar); cat("Pares consolidados:",nrow(out),"\n")
