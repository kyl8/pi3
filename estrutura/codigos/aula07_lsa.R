# R | aula07_lsa.R | R 4.3+ | executar na raiz de pi3.
source("estrutura/codigos/motor-appa.R", local = TRUE, encoding = "UTF-8") # Mantem o preparo no mesmo ambiente das funcoes ao executar em lote.
preparar_appa <- preparar # Guarda a extensao de stemming usada no corpus congelado.
source("estrutura/codigos/motor-professor/motor07.R", local = TRUE, encoding = "UTF-8") # Inicia no motor anterior a esta aula, no ambiente corrente.
preparar <- preparar_appa # Mantem o mesmo preparo APPA ja usado nos julgamentos e nas metricas.
source("estrutura/codigos/aula07_funcoes.R", local = TRUE, encoding = "UTF-8") # Usa as funcoes entregues com os novos guias.
source("estrutura/codigos/config.R", local = TRUE, encoding = "UTF-8") # Le parametros APPA no mesmo ambiente.
cp <- read.csv("estrutura/codigos/05-julgamento/csv/2026-09-15-appa-05-corpus.csv", fileEncoding = "UTF-8", stringsAsFactors = FALSE) # Usa o corpus congelado.
docs <- setNames(cp$texto, cp$id); ix <- montar(docs, cfg) # Garante representacao identica a usada nos guias.
nec <- read.csv("estrutura/banco-de-dados/necessidades.csv", fileEncoding = "UTF-8", stringsAsFactors = FALSE) # Le as necessidades e a divisao persistida no caminho do guia.
stopifnot(all(c("consulta", "texto_consulta", "conjunto") %in% names(nec)), all(nec$conjunto %in% c("dev", "teste"))) # Exige a divisao antes de medir candidatos.
nec$id <- nec$consulta; nec$conjunto[nec$conjunto == "teste"] <- "teste_retrospectivo" # Preserva a ressalva: consultas ja foram vistas em versoes anteriores.
qr <- read.csv("estrutura/codigos/05-julgamento/csv/2026-10-25-appa-05-qrels-assistidos.csv", fileEncoding = "UTF-8", stringsAsFactors = FALSE) # Usa a referencia assistida identificada.
graus <- lapply(split(qr, qr$consulta), function(d) setNames(d$grau, d$documento)) # Organiza notas por necessidade.
s <- svd(ix$w) # Decompoe TF-IDF uma unica vez.
ks <- sort(unique(pmin(c(2, 10, 20, 50, 80, ix$N), length(s$d)))) # Explora dimensoes baixas e a dimensao completa.
resultados <- list(); ranks <- list() # Guarda candidatos e rankings.
for (k in ks) { # Testa as dimensoes declaradas, sem usar o teste para escolher.
  modelo <- list(U = s$u[, seq_len(k), drop = FALSE], D = sweep(s$v[, seq_len(k), drop = FALSE], 2, s$d[seq_len(k)], `*`)) # Projeta documentos em V vezes Sigma.
  rownames(modelo$D) <- names(docs) # Mantem identidade dos documentos.
  for (i in which(nec$conjunto == "dev")) { # Avalia candidatos somente no desenvolvimento.
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
modelo_teste <- list(U = s$u[, seq_len(melhor_k), drop = FALSE], D = sweep(s$v[, seq_len(melhor_k), drop = FALSE], 2, s$d[seq_len(melhor_k)], `*`)) # Congela a dimensao escolhida no desenvolvimento.
rownames(modelo_teste$D) <- names(docs) # Preserva ids na representacao de teste.
linhas_teste <- list() # Registra somente a referencia e o escolhido no teste.
for (i in which(nec$conjunto == "teste_retrospectivo")) { # Abre o teste depois da escolha, sem varrer k nele.
  id <- nec$id[i]; q <- nec$texto_consulta[i]; g <- graus[[id]] # Seleciona a necessidade de teste.
  for (metodo in unique(c("bm25", cfg$modelo))) { # Compara BM25 e a configuracao congelada.
    rk <- ranking_modelo(q, metodo, ix, cfg, modelo_teste, c = cfg$rrf_c) # Executa o metodo uma vez por consulta de teste.
    linhas_teste[[length(linhas_teste) + 1]] <- data.frame(consulta = id, conjunto = nec$conjunto[i], modelo = metodo, k = melhor_k, R = sum(g >= cfg$limiar), AP = metricas(rk, g, cfg$limiar)["AP"], energia = sum(s$d[seq_len(melhor_k)]^2) / sum(s$d^2)) # Mede o resultado sem realimentar a escolha.
    ranks[[paste(melhor_k, id, metodo, sep = ":")]] <- rk # Guarda apenas os rankings testados.
  } # Termina a referencia e o escolhido.
} # Termina o relato retrospectivo.
if (length(linhas_teste)) tab <- rbind(tab, do.call(rbind, linhas_teste)) # Mantem dev completo e teste da unica escolha.
cfg$prf_k <- read.csv("estrutura/resultados/guias/aula06_escolha.csv")$prf_k # Mantem a escolha de pseudo-feedback no dev.
writeLines(trimws(c("# Configuracao APPA; parametros escolhidos no desenvolvimento; ver consolidados/00_FICHA_PROJETO.md.", "cfg <-", capture.output(dput(cfg))), which = "right"), "estrutura/codigos/config.R") # Persiste os parametros sem espacos finais.
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
  if (!length(rk)) next # Nao cria avaliacao adicional de um metodo nao escolhido no teste.
  top[[length(top) + 1]] <- data.frame(consulta = id, metodo = metodo, posicao = seq_along(rk), documento = names(rk), score = unname(rk), texto = unname(docs[names(rk)]), grau = unname(graus[[id]][names(rk)])) # Inclui textos para confrontar a necessidade.
} # Fecha a leitura qualitativa.
salvar(do.call(rbind, top), "LsaRrfTop5") # Mantem o nome conhecido pelo repositorio.
comparacoes <- list(); termos_top <- list() # Fundamenta a leitura dos documentos exclusivos de cada top-5.
for (i in which(nec$conjunto == "dev")) { # Compara LSA e BM25 sem acrescentar candidatos no teste.
  id <- nec$id[i]; bm <- head(names(ranks[[paste(melhor_k, id, "bm25", sep = ":")]]), 5); ls <- head(names(ranks[[paste(melhor_k, id, "lsa", sep = ":")]]), 5) # Le os dois conjuntos do topo.
  comparacoes[[length(comparacoes) + 1]] <- data.frame(consulta = id, comuns = length(intersect(bm, ls)), so_bm25 = paste(setdiff(bm, ls), collapse = " "), so_lsa = paste(setdiff(ls, bm), collapse = " ")) # Quantifica coincidencias e diferencas.
  tq <- preparar(nec$texto_consulta[i], cfg) # Usa o mesmo preparo da busca para contar termos em comum.
  termos_top[[length(termos_top) + 1]] <- do.call(rbind, lapply(union(bm, ls), function(d) data.frame(consulta = id, documento = d, origem_top5 = if (d %in% bm && d %in% ls) "ambos" else if (d %in% bm) "so_bm25" else "so_lsa", termos_comuns = paste(intersect(tq, ix$tokens[[d]]), collapse = " "), n_termos_comuns = length(intersect(tq, ix$tokens[[d]])), grau = unname(graus[[id]][d])))) # Nao confunde ausencia de julgamento com grau zero real.
} # Termina as evidencias da leitura qualitativa.
salvar(do.call(rbind, comparacoes), "ComparacaoTop5"); salvar(do.call(rbind, termos_top), "TermosTop5") # Entrega os numeros usados no checkpoint sete.
ranking_atual <- do.call(rbind, lapply(seq_len(nrow(nec)), function(i) { rk <- head(ranking_motor(nec$texto_consulta[i], ix, cfg), 5); data.frame(consulta = nec$id[i], modelo = cfg$modelo, k = cfg$lsa_k, posicao = seq_along(rk), documento = names(rk), score = unname(rk)) })) # Confere a integracao operacional sem recalcular metricas.
salvar(ranking_atual, "RankingMotorTop5") # Entrega o top-5 efetivamente usado pelo motor configurado.
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
memoria <- list2env(list(MOTOR_VERSAO = MOTOR_VERSAO, docs = docs, cfg = cfg, ix = ix, modelo_teste = modelo_teste, nec = nec, graus = graus, tab_dev = dev, placar = placar, escolha = escolha, lsa = lsa, ranking_lsa = ranking_lsa, rrf = rrf, ranking_modelo = ranking_modelo, ap_modelo = ap_modelo, ranking_motor = ranking_motor)) # Seleciona os objetos reais relevantes para continuar a proxima aula.
for (arquivo in c("consolidados/00_FICHA_PROJETO.md", "consolidados/aula07_parteD_consolidado.md")) if (file.exists(arquivo)) anexar_estado(arquivo, env = memoria) # O motor gera o estado a partir dos objetos calculados.
