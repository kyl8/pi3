# R | GuiasEstudo.R | R 4.3+ | executar na raiz de pi3.
source("estrutura/codigos/motor-appa.R", encoding = "UTF-8") # Carrega o motor local e a adaptacao do grupo.
source("estrutura/codigos/config.R", encoding = "UTF-8") # Le parametros canonicos APPA.
out <- "estrutura/resultados/guias" # Separa as evidencias dos guias.
dir.create(out, recursive = TRUE, showWarnings = FALSE) # Cria o diretorio das saidas.
salvar <- function(x, nome) write.csv(x, file.path(out, paste0(nome, ".csv")), row.names = FALSE, fileEncoding = "UTF-8") # Exporta tabelas.
docs_curso <- docs_aula(); cfg_curso <- cfg_aula(); ix_curso <- montar(docs_curso, cfg_curso) # Reproduz os oito textos sem stemming.
grau_curso <- gabarito_aula(); consulta_curso <- "modelo de recuperacao" # Usa o exemplo exato dos guias.
rk_cos <- ranking_cosseno(consulta_curso, ix_curso, cfg_curso) # Reproduz o ranking da teoria.
rk_bm <- ranking_bm25(consulta_curso, ix_curso, cfg_curso) # Reproduz o BM25 da teoria.
stopifnot(length(ix_curso$vocab) == 45, identical(names(rk_cos)[1:4], c("d1", "d3", "d4", "d2"))) # Confere o exemplo canonico.
stopifnot(abs(cosseno(c(1, 2), c(2, 1)) - .8) < 1e-10, cosseno(c(0, 0), c(1, 1)) == 0) # Confere as contas de cosseno e vetor nulo.
salvar(data.frame(documento = names(rk_cos), cosseno = unname(rk_cos)), "aula02_ranking_canonico") # Registra o ranking teorico.
ix_limpo <- montar(docs_curso, modifyList(cfg_curso, list(stopwords = stopwords_aula()))) # Remove as dez stopwords do guia.
stopifnot(length(ix_limpo$postings) == 37) # Confere o indice da teoria.
salvar(data.frame(termo = names(ix_limpo$postings), documentos = vapply(ix_limpo$postings, paste, character(1), collapse = " ")), "aula03_indice_canonico") # Salva o indice invertido.
salvar(data.frame(modelo = c("cosseno", "bm25"), rbind(metricas(rk_cos, grau_curso, 2), metricas(rk_bm, grau_curso, 2))), "aula05b_metricas_canonicas") # Recalcula as cinco metricas com limiar dois.
q0 <- vetor_consulta(preparar(consulta_curso, cfg_curso), ix_curso$vocab, ix_curso$idf_tfidf) # Representa a consulta em TF-IDF.
q_mod <- rocchio(q0, c("d2", "d3"), "d4", ix_curso) # Faz a realimentacao explicita do guia.
stopifnot(all(q_mod >= 0)) # Confere truncagem dos pesos negativos.
rk_mod <- ranking_vetor(q_mod, ix_curso) # Reordena os oito textos apos feedback.
salvar(data.frame(modelo = c("antes", "rocchio"), rbind(metricas(rk_cos, grau_curso, 2), metricas(rk_mod, grau_curso, 2))), "aula06_metricas_canonicas") # Confere a melhora do exemplo.
kappa_exemplo <- kappa_matriz(matrix(c(18, 3, 0, 2, 6, 2, 0, 2, 7), 3, byrow = TRUE)) # Reproduz a matriz de quarenta itens do guia, sem atribuir votos a pessoas.
salvar(data.frame(medida = names(kappa_exemplo), valor = as.numeric(kappa_exemplo)), "aula05_kappa_exemplo_didatico") # Identifica acordo observado, esperado e kappa.
cp <- read.csv("estrutura/codigos/05-julgamento/csv/2026-09-15-appa-05-corpus.csv", fileEncoding = "UTF-8", stringsAsFactors = FALSE) # Le o corpus congelado julgado.
stopifnot(!anyDuplicated(cp$id), nrow(cp) == 141, !anyNA(cp$texto)) # Mantem os identificadores historicos.
docs <- setNames(cp$texto, cp$id); ix <- montar(docs, cfg) # Monta o indice do grupo sobre o CSV congelado.
raw_tokens <- lapply(docs, tokenizar); raw_vocab <- unique(unlist(raw_tokens)) # Mede o corpus antes da limpeza.
longos <- order(sqrt(colSums(ix$w^2)), decreasing = TRUE) # Localiza documentos com maior norma.
salvar(data.frame(documento = names(docs), fonte = cp$fonte, tokens_brutos = lengths(raw_tokens), tokens_limpos = lengths(ix$tokens), norma_tfidf = sqrt(colSums(ix$w^2)), K = cfg$k1 * (1 - cfg$b + cfg$b * ix$dl / ix$avgdl)), "aula02_04_documentos") # Fundamenta as leituras de comprimento.
salvar(data.frame(n = ix$N, vocabulario_bruto = length(raw_vocab), vocabulario_limpo = length(ix$vocab), postings = length(ix$postings), tokens_media = mean(ix$dl), tokens_min = min(ix$dl), tokens_max = max(ix$dl)), "corpus_estatisticas") # Registra estatisticas atuais.
necessidades <- read.csv("estrutura/codigos/05-julgamento/csv/2026-09-15-appa-05-necessidades.csv", fileEncoding = "UTF-8", stringsAsFactors = FALSE) # Le as seis necessidades APPA.
qrels <- read.csv("estrutura/codigos/05-julgamento/csv/2026-10-25-appa-05-qrels-assistidos.csv", fileEncoding = "UTF-8", stringsAsFactors = FALSE) # Usa julgamento assistido identificado, separado dos votos humanos.
stopifnot(all(qrels$documento %in% names(docs)), !anyDuplicated(qrels[c("consulta", "documento")])) # Confere cobertura e unicidade.
graus <- lapply(split(qrels, qrels$consulta), function(d) setNames(d$grau, d$documento)) # Estrutura o gabarito por consulta.
conjunto <- ifelse(necessidades$id %in% c("q02", "q04"), "teste_retrospectivo", "dev") # Declara divisao fixa, sem fingir teste historicamente intocado.
necessidades$conjunto <- conjunto # Persiste o protocolo compartilhado.
salvar(necessidades, "consultas_conjuntos") # Salva a separacao auditavel.
linhas <- list(); tops <- list(); residuos <- list(); prfs <- list(); exploracoes <- list() # Prepara as tabelas dos modulos praticos.
for (i in seq_len(nrow(necessidades))) { # Percorre as consultas reais.
  id <- necessidades$id[i]; q <- necessidades$texto_consulta[i]; g <- graus[[id]] # Seleciona consulta e graus.
  cos <- ranking_cosseno(q, ix, cfg); bm <- ranking_bm25(q, ix, cfg) # Compara dois modelos com a mesma representacao.
  for (nome in c("cosseno", "bm25")) { # Mede as mesmas cinco metricas para os dois motores.
    rk <- if (nome == "cosseno") cos else bm # Escolhe o ranking corrente.
    linhas[[length(linhas) + 1]] <- data.frame(consulta = id, conjunto = conjunto[i], modelo = nome, R = sum(g >= cfg$limiar), as.list(metricas(rk, g, cfg$limiar))) # Calcula AP no ranking completo.
    top <- head(rk, 5); grau_top <- g[names(top)] # Localiza graus dos documentos do topo.
    tops[[length(tops) + 1]] <- data.frame(consulta = id, modelo = nome, posicao = seq_along(top), documento = names(top), score = unname(top), grau = unname(grau_top), texto = unname(docs[names(top)])) # Mantem texto para leitura qualitativa.
  } # Fecha as medidas dos modelos basicos.
  qw <- vetor_consulta(preparar(q, cfg), ix$vocab, ix$idf_tfidf) # Usa o IDF do corpus na consulta.
  vistos <- head(names(cos), 4); dr <- intersect(vistos, names(g)[g >= cfg$limiar]); dnr <- intersect(vistos, names(g)[g < cfg$limiar]) # Feedback usa apenas documentos vistos e julgados.
  feedback <- ranking_vetor(rocchio(qw, dr, dnr, ix), ix) # Reformula sem modificar os documentos.
  residuos[[i]] <- data.frame(consulta = id, vistos = paste(vistos, collapse = " "), Dr = paste(dr, collapse = " "), Dnr = paste(dnr, collapse = " "), AP_antes = metricas(cos, g, cfg$limiar)["AP"], AP_depois = metricas(feedback, g, cfg$limiar)["AP"], AP_residual_antes = residual(cos, g, vistos, cfg$limiar)["AP"], AP_residual_depois = residual(feedback, g, vistos, cfg$limiar)["AP"]) # Retira todos os documentos vistos da avaliacao residual.
  for (k in c(0, 1, 2, 3, 5)) { # Compara pseudo-feedback e a ausencia dele.
    rk <- if (k == 0) cos else prf(qw, k, ix, cfg$rocchio) # Nao consulta graus para expandir.
    prfs[[length(prfs) + 1]] <- data.frame(consulta = id, conjunto = conjunto[i], k = k, AP = metricas(rk, g, cfg$limiar)["AP"]) # Registra AP para selecionar no desenvolvimento.
  } # Conclui candidatos de pseudo-feedback.
  for (k1 in c(0, 1.2, 1.5, 2)) for (b in c(0, .75, 1)) { # Explora saturacao e normalizacao de tamanho.
    rk <- ranking_bm25(q, ix, modifyList(cfg, list(k1 = k1, b = b))) # Muda somente os parametros explorados.
    exploracoes[[length(exploracoes) + 1]] <- data.frame(consulta = id, k1 = k1, b = b, primeiro = names(rk)[1], AP = metricas(rk, g, cfg$limiar)["AP"]) # Guarda o efeito da configuracao.
  } # Termina a exploracao BM25.
} # Fecha as consultas do corpus.
salvar(do.call(rbind, linhas), "aula05b_metricas_grupo") # Exporta metricas sem truncar AP em dez posicoes.
salvar(do.call(rbind, tops), "aula02_04_top5_com_textos") # Entrega a leitura do topo.
salvar(do.call(rbind, residuos), "aula06_feedback_residual") # Registra avaliacao residual honesta.
prfs <- do.call(rbind, prfs); salvar(prfs, "aula06_prf_por_consulta") # Exporta candidatos por consulta.
medias_prf <- aggregate(AP ~ k + conjunto, prfs, mean) # Calcula MAP ignorando consultas sem relevante.
salvar(medias_prf, "aula06_prf_map") # Salva o desenvolvimento e o teste retrospectivo.
dev_prf <- subset(medias_prf, conjunto == "dev"); melhor_prf <- dev_prf$k[which.max(dev_prf$AP)] # Prefere menor k no empate.
salvar(data.frame(prf_k = melhor_prf, rocchio_a = 1, rocchio_b = .75, rocchio_g = .15), "aula06_escolha") # Registra a escolha antes do relato retrospectivo.
salvar(do.call(rbind, exploracoes), "aula04_exploracao_bm25") # Entrega a variacao dos parametros.
writeLines(capture.output(sessionInfo()), file.path(out, "sessionInfo.txt")) # Documenta versoes usadas.
print(read.csv(file.path(out, "corpus_estatisticas.csv"))); print(medias_prf) # Exibe evidencias essenciais.
