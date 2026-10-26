# R | aula07_lsa.R | R 4.3+ | executar na raiz de pi3.
source("estrutura/codigos/motor-appa.R", encoding = "UTF-8") # Carrega funcoes locais da disciplina.
source("estrutura/codigos/config.R", encoding = "UTF-8") # Le parametros APPA.
cp <- read.csv("estrutura/codigos/05-julgamento/csv/2026-09-15-appa-05-corpus.csv", fileEncoding = "UTF-8", stringsAsFactors = FALSE) # Usa o corpus congelado.
docs <- setNames(cp$texto, cp$id); ix <- montar(docs, cfg) # Garante representacao identica a usada nos guias.
nec <- read.csv("estrutura/resultados/guias/consultas_conjuntos.csv", fileEncoding = "UTF-8", stringsAsFactors = FALSE) # Reutiliza a divisao declarada antes da selecao.
qr <- read.csv("estrutura/codigos/05-julgamento/csv/2026-10-25-appa-05-qrels-assistidos.csv", fileEncoding = "UTF-8", stringsAsFactors = FALSE) # Usa a referencia assistida identificada.
graus <- lapply(split(qr, qr$consulta), function(d) setNames(d$grau, d$documento)) # Organiza notas por necessidade.
s <- svd(ix$w) # Decompoe TF-IDF uma unica vez.
ks <- sort(unique(pmin(c(2, 10, 20, 50, 80, ix$N), length(s$d)))) # Explora dimensoes baixas e a dimensao completa.
resultados <- list(); ranks <- list() # Guarda candidatos e rankings.
for (k in ks) { # Testa as dimensoes declaradas, sem usar o teste para escolher.
  modelo <- list(U = s$u[, seq_len(k), drop = FALSE], D = sweep(s$v[, seq_len(k), drop = FALSE], 2, s$d[seq_len(k)], `*`)) # Projeta documentos em V vezes Sigma.
  rownames(modelo$D) <- names(docs) # Mantem identidade dos documentos.
  for (i in seq_len(nrow(nec))) { # Mede cada consulta com o mesmo gabarito.
    id <- nec$id[i]; q <- nec$texto_consulta[i]; g <- graus[[id]] # Seleciona a consulta.
    bm <- ranking_bm25(q, ix, cfg); ls <- ranking_lsa(q, ix, cfg, modelo); hib <- rrf(bm, ls, c = cfg$rrf_c) # Constroi esparso, denso e fusao.
    for (metodo in c("bm25", "lsa", "hibrido")) { # Aplica uma unica metrica aos tres candidatos.
      rk <- switch(metodo, bm25 = bm, lsa = ls, hibrido = hib) # Seleciona o ranking candidato.
      resultados[[length(resultados) + 1]] <- data.frame(consulta = id, conjunto = nec$conjunto[i], modelo = metodo, k = k, R = sum(g >= cfg$limiar), AP = metricas(rk, g, cfg$limiar)["AP"], energia = sum(s$d[seq_len(k)]^2) / sum(s$d^2)) # AP usa ranking completo e R do gabarito.
      ranks[[paste(k, id, metodo, sep = ":")]] <- rk # Retem os rankings para a leitura qualitativa.
    } # Termina modelos para a consulta.
  } # Termina consultas da dimensao.
} # Termina dimensoes candidatas.
tab <- do.call(rbind, resultados) # Consolida AP por consulta e candidato.
dev <- aggregate(AP ~ modelo + k, subset(tab, conjunto == "dev"), mean) # Escolhe exclusivamente por MAP no desenvolvimento.
dev <- dev[order(-dev$AP, match(dev$modelo, c("bm25", "lsa", "hibrido")), dev$k), ] # Resolve empates por simplicidade e menor dimensao.
escolha <- dev[1, ]; melhor_k <- escolha$k; cfg$modelo <- escolha$modelo; cfg$lsa_k <- as.integer(melhor_k) # Registra a escolha antes do relato.
cfg$prf_k <- read.csv("estrutura/resultados/guias/aula06_escolha.csv")$prf_k # Mantem a escolha de pseudo-feedback no dev.
writeLines(trimws(c("# Configuracao APPA; selecao assistida de 2026-10-25, ver sincronizacao.", "cfg <-", capture.output(dput(cfg))), which = "right"), "estrutura/codigos/config.R") # Persiste os parametros sem espacos finais.
file.copy("estrutura/codigos/config.R", "estrutura/codigo/config.R", overwrite = TRUE) # Mantem o caminho exigido pelos guias sincronizado.
prefixo <- "estrutura/resultados/2026-10-25-appa-07-" # Centraliza as saidas da aula sete.
salvar <- function(x, nome) write.csv(x, paste0(prefixo, nome, ".csv"), row.names = FALSE, fileEncoding = "UTF-8") # Grava evidencias sem arredondamento interno.
salvar(dev, "LsaMapPorKDev"); salvar(tab, "LsaPorConsultaTodosK") # Entrega candidatos e numeros por consulta.
selecionados <- subset(tab, k == melhor_k) # Congela a dimensao selecionada.
placar <- aggregate(AP ~ conjunto + modelo, selecionados, mean) # Relata desenvolvimento e teste retrospectivo uma vez apos escolha.
salvar(placar, "LsaPlacarDevTeste"); salvar(escolha, "LsaEscolha") # Documenta a escolha reproduzivel.
top <- list() # Prepara a leitura textual dos documentos.
for (i in seq_len(nrow(nec))) for (metodo in c("bm25", "lsa", "hibrido")) { # Mostra cinco resultados por necessidade e metodo.
  id <- nec$id[i]; rk <- head(ranks[[paste(melhor_k, id, metodo, sep = ":")]], 5) # Le o ranking selecionado.
  top[[length(top) + 1]] <- data.frame(consulta = id, metodo = metodo, posicao = seq_along(rk), documento = names(rk), score = unname(rk), texto = unname(docs[names(rk)]), grau = unname(graus[[id]][names(rk)])) # Inclui textos para confrontar a necessidade.
} # Fecha a leitura qualitativa.
salvar(do.call(rbind, top), "LsaRrfTop5") # Mantem o nome conhecido pelo repositorio.
wide <- reshape(selecionados[c("consulta", "modelo", "AP")], idvar = "consulta", timevar = "modelo", direction = "wide") # Resume as tres AP por consulta.
salvar(wide, "LsaRrfMetricas") # Atualiza a tabela historica com a metodologia corrigida.
png(paste0(prefixo, "LsaMapDev.png"), width = 1050, height = 700, res = 120) # Abre figura de selecao.
plot(range(ks), range(dev$AP), type = "n", xlab = "Dimensao k", ylab = "MAP no desenvolvimento", main = "APPA: escolher k no desenvolvimento") # Define os eixos.
for (metodo in c("bm25", "lsa", "hibrido")) { # Desenha as curvas dos candidatos.
  d <- dev[dev$modelo == metodo, ]; d <- d[order(d$k), ]; cor <- c(bm25 = "gray40", lsa = "steelblue", hibrido = "firebrick")[[metodo]] # Ordena dimensoes e define cor.
  lines(d$k, d$AP, type = "b", col = cor, lwd = 2) # Liga MAP por dimensao.
} # Termina curvas.
legend("bottomright", c("BM25", "LSA", "RRF"), col = c("gray40", "steelblue", "firebrick"), lty = 1, pch = 1); dev.off() # Fecha figura com legenda.
print(escolha); print(placar) # Mostra a escolha e as limitacoes documentadas no consolidado.
