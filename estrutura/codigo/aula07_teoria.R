# R | aula07_teoria.R | executar na raiz de pi3.
if (.Platform$OS.type == "windows") invisible(Sys.setlocale("LC_CTYPE", "English_United States.utf8")) # Habilita UTF-8 no Windows.
source("estrutura/codigos/motor-professor/motor07.R", local = TRUE, encoding = "UTF-8") # Carrega apenas as aulas anteriores, como pede o guia.
source("estrutura/codigos/aula07_funcoes.R", local = TRUE, encoding = "UTF-8") # Acrescenta as funcoes construidas na Aula 07.
docs <- docs_aula(); cfg <- cfg_aula(); ix <- montar(docs, cfg) # Reproduz o corpus canonico de oito frases.
s <- svd(ix$w); m2 <- lsa(ix, 2); m4 <- lsa(ix, 4) # Prepara os exemplos do guia.
q0 <- vetor_consulta(preparar("modelo de recuperacao", cfg), ix$vocab, ix$idf_tfidf) # Cria os 45 pesos da consulta canonica.
qk <- drop(t(m2$U) %*% q0) # Dobra a consulta nas duas coordenadas.
rc <- ranking_cosseno("modelo de recuperacao", ix, cfg); rb <- ranking_bm25("modelo de recuperacao", ix, cfg) # Reproduz os modelos lexicais.
r2 <- ranking_lsa("modelo de recuperacao", ix, cfg, m2); rh <- rrf(rb, r2) # Ranqueia no LSA e na fusao.
stopifnot(identical(dim(ix$w), c(45L, 8L)), max(abs(s$u %*% diag(s$d) %*% t(s$v) - ix$w)) < 1e-10) # Confere dimensoes e reconstrucao da matriz.
stopifnot(identical(names(r2), c("d2", "d3", "d8", "d6", "d5", "d1", "d4", "d7"))) # Confere o ranking denso do texto da aula.
stopifnot(identical(names(rh), c("d3", "d2", "d1", "d8", "d6", "d4", "d5", "d7"))) # Confere a ordem da fusao RRF.
out <- "estrutura/resultados/guias/aula07"; dir.create(out, recursive = TRUE, showWarnings = FALSE) # Separa as evidencias da nova teoria.
salvar <- function(x, nome) write.csv(x, file.path(out, paste0(nome, ".csv")), row.names = FALSE, fileEncoding = "UTF-8") # Exporta numeros completos.
salvar(data.frame(k = seq_along(s$d), singular = s$d, energia_acumulada = cumsum(s$d^2) / sum(s$d^2)), "teoria_energia") # Fundamenta o checkpoint tres.
salvar(data.frame(coordenada = seq_along(qk), valor = qk), "teoria_consulta_dobrada") # Guarda a projecao sem depender do sinal da SVD.
salvar(data.frame(documento = rownames(m2$D), m2$D), "teoria_documentos_lsa2") # Guarda as coordenadas densas.
salvar(data.frame(modelo = c("cosseno", "bm25", "lsa2", "rrf"), rbind(metricas(rc, gabarito_aula(), 2), metricas(rb, gabarito_aula(), 2), metricas(r2, gabarito_aula(), 2), metricas(rh, gabarito_aula(), 2))), "teoria_metricas_canonicas") # Reproduz o placar do modulo seis.
busca <- list(cosseno = ranking_cosseno("busca", ix, cfg), lsa2 = ranking_lsa("busca", ix, cfg, m2), lsa4 = ranking_lsa("busca", ix, cfg, m4)) # Executa a tarefa individual com consulta de uma palavra.
busca$rrf2 <- rrf(ranking_bm25("busca", ix, cfg), busca$lsa2); busca$rrf4 <- rrf(ranking_bm25("busca", ix, cfg), busca$lsa4) # Funde os dois candidatos da tarefa com BM25.
salvar(do.call(rbind, lapply(names(busca), function(nome) { rk <- busca[[nome]]; data.frame(modelo = nome, posicao = seq_along(rk), documento = names(rk), score = unname(rk), texto = unname(docs[names(rk)])) })), "tarefa_individual_busca") # Permite ler ganho e ruido nos textos.
png(file.path(out, "teoria_documentos_lsa2.png"), width = 1000, height = 750, res = 120) # Abre a figura opcional dos oito pontos.
plot(m2$D, type = "n", asp = 1, xlab = "Coordenada latente 1", ylab = "Coordenada latente 2", main = "Aula 07: os oito documentos no LSA"); text(m2$D, labels = rownames(m2$D)); dev.off() # Mostra proximidades sem rotular eixos como temas.
if (file.exists("consolidados/aula07_consolidado.md")) anexar_estado("consolidados/aula07_consolidado.md", env = environment()) # Anexa estado real ao consolidado individual existente.
print(read.csv(file.path(out, "teoria_metricas_canonicas.csv"))) # Exibe os numeros da conferencia.
