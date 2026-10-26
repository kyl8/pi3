if (!requireNamespace("SnowballC", quietly = TRUE)) stop("Instale SnowballC para executar esta atividade.")
arquivo_docs <- "estrutura/banco-de-dados/docs.rds"; if (!file.exists(arquivo_docs)) arquivo_docs <- "estrutura/corpus/docs.rds"
base <- readRDS(arquivo_docs)
if (is.data.frame(base)) { ids <- as.character(base[[which(names(base) %in% c("id", "ID"))[1]]]); col <- which(names(base) %in% c("texto", "text", "documento"))[1]; docs <- setNames(as.character(base[[col]]), ids) } else { docs <- as.character(base); if (is.null(names(docs))) names(docs) <- paste0("d", seq_along(docs)) }
preparar <- function(x) { x <- iconv(tolower(x), to = "ASCII//TRANSLIT"); x[is.na(x)] <- ""; x <- gsub("[^a-z0-9 ]", " ", x); t <- unlist(strsplit(gsub("\\s+", " ", x), " ")); t <- t[nzchar(t)]; t <- t[!t %in% c("a","o","e","de","do","da","dos","das","em","no","na","para","por","com","que","um","uma")]; SnowballC::wordStem(t, language="portuguese") }
tokens <- lapply(docs, preparar); vocab <- sort(unique(unlist(tokens))); tf <- sapply(tokens, function(t) as.integer(table(factor(t, levels=vocab)))); rownames(tf) <- vocab
idf <- log(ncol(tf)/pmax(1,rowSums(tf>0))); w <- tf*idf
cosseno <- function(a,b) { z <- sqrt(sum(a^2))*sqrt(sum(b^2)); if(z==0) 0 else sum(a*b)/z }
vetor_consulta <- function(q) as.integer(table(factor(preparar(q),levels=vocab)))*idf
rankear_bm25 <- function(q) { termos <- names(q)[q>0]; dl <- colSums(tf); media <- mean(dl); s <- sapply(colnames(tf), function(doc) sum(vapply(termos, function(t) { f <- tf[t,doc]; K <- 1.5*(1-.75+.75*dl[doc]/media); log((ncol(tf)-sum(tf[t,]>0)+.5)/(sum(tf[t,]>0)+.5)+1)*(f*2.5)/(f+K) }, numeric(1)))); sort(s,decreasing=TRUE) }
s <- svd(w, nu=min(30,nrow(w),ncol(w)), nv=min(30,nrow(w),ncol(w))); k_lsa <- min(12,length(s$d)); u <- s$u[,seq_len(k_lsa),drop=FALSE]; d <- s$d[seq_len(k_lsa)]; v <- s$v[,seq_len(k_lsa),drop=FALSE]; rownames(v) <- colnames(w)
rankear_lsa <- function(q) { q_lat <- drop(crossprod(u,q)); docs_lat <- sweep(v, 2, d, `*`); scores <- apply(docs_lat,1,function(z)cosseno(q_lat,z)); names(scores)<-rownames(docs_lat); sort(scores,decreasing=TRUE) }
rrf <- function(a,b) { total <- setNames(rep(0,length(docs)),names(docs)); total[names(a)] <- total[names(a)] + 1/(60+seq_along(a)); total[names(b)] <- total[names(b)] + 1/(60+seq_along(b)); sort(total,decreasing=TRUE) }
ap <- function(r,grau) { rel <- r %in% names(grau)[grau>=1]; R <- sum(grau>=1); if(!R) return(NA_real_); sum(cumsum(rel)[rel]/which(rel))/R }
necessidades <- read.csv("estrutura/codigos/05-julgamento/csv/2026-09-15-appa-05-necessidades.csv",stringsAsFactors=FALSE,fileEncoding="UTF-8")
qrels <- read.csv("estrutura/codigos/05-julgamento/csv/2026-09-15-appa-05-qrels.csv",stringsAsFactors=FALSE,fileEncoding="UTF-8")
linhas<-list(); top<-list()
for(i in seq_len(nrow(necessidades))) { id <- necessidades$id[i]; q <- vetor_consulta(necessidades$texto_consulta[i]); bm25<-rankear_bm25(q); lsa<-rankear_lsa(q); combinado<-rrf(bm25,lsa); g<-qrels[qrels$consulta==id,c("documento","grau")]; grau<-setNames(g$grau,g$documento); linhas[[i]]<-data.frame(consulta=id,AP_bm25=ap(names(bm25),grau),AP_lsa=ap(names(lsa),grau),AP_rrf=ap(names(combinado),grau)); for(nome in c("bm25","lsa","combinado")){r<-get(nome);top[[length(top)+1]]<-data.frame(consulta=id,metodo=nome,posicao=1:5,documento=names(r)[1:5],score=unname(r[1:5]))} }
resultado<-do.call(rbind,linhas); resultado<-rbind(resultado,data.frame(consulta="MAP",AP_bm25=mean(resultado$AP_bm25,na.rm=TRUE),AP_lsa=mean(resultado$AP_lsa,na.rm=TRUE),AP_rrf=mean(resultado$AP_rrf,na.rm=TRUE)))
dir.create("estrutura/resultados",showWarnings=FALSE,recursive=TRUE);write.csv(resultado,"estrutura/resultados/2026-10-25-appa-07-LsaRrfMetricas.csv",row.names=FALSE,fileEncoding="UTF-8");write.csv(do.call(rbind,top),"estrutura/resultados/2026-10-25-appa-07-LsaRrfTop5.csv",row.names=FALSE,fileEncoding="UTF-8")
cat("Corpus:",length(docs),"| vocab:",nrow(w),"| LSA:",k_lsa,"\n");print(resultado)
