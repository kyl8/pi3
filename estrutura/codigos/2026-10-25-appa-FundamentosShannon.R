# R | FundamentosShannon.R | executar na raiz de pi3.
source("estrutura/codigos/motor-appa.R", encoding = "UTF-8") # Carrega tokenizacao e funcoes basicas.
frases <- c(santos = "Santos joga na Vila Belmiro", portuguesa = "A Portuguesa Santista manda jogos no Ulrico Mursa", jabaquara = "O Jabaquara representa a Caneleira") # Define as tres frases da Parte D individual.
write.csv(data.frame(id = names(frases), frase = unname(frases), caracteres = nchar(frases), tokens = lengths(lapply(frases, tokenizar)), contem_estadio = grepl("Vila|Mursa", frases)), "estrutura/resultados/guias/aula00_tres_frases.csv", row.names = FALSE, fileEncoding = "UTF-8") # Executa a aplicacao individual, sem simular conversa.
cp <- read.csv("estrutura/codigos/05-julgamento/csv/2026-09-15-appa-05-corpus.csv", fileEncoding = "UTF-8", stringsAsFactors = FALSE) # Usa o corpus APPA congelado.
calcular <- function(docs, corpus) { # Calcula informacao por termo no corpus indicado.
  tok <- lapply(docs, tokenizar); vocab <- sort(unique(unlist(tok))); tf <- matriz_tf(tok, vocab); df <- rowSums(tf > 0); N <- length(docs) # Obtem frequencia documental sem confundir com ocorrencias.
  data.frame(corpus = corpus, termo = vocab, tf = rowSums(tf), df = df, p = df / N, informacao_bits = log2(N / df), idf_natural = log(N / df)) # Compara as duas bases do logaritmo.
} # Fecha as contas de Shannon.
tab <- rbind(calcular(docs_aula(), "curso_8"), calcular(setNames(cp$texto, cp$id), "APPA_141")) # Repete o procedimento na aula e no grupo.
stopifnot(abs(subset(tab, corpus == "curso_8" & termo == "de")$informacao_bits - log2(8 / 5)) < 1e-10) # Confere o termo canonico de frequencia cinco.
write.csv(tab, "estrutura/resultados/guias/aula01b_shannon_termos.csv", row.names = FALSE, fileEncoding = "UTF-8") # Entrega todos os pesos em bits e nats.
pares <- list(c("busca", "documentos"), c("aprendizado", "estatistico"), c("modelo", "vetorial")) # Explora pistas correlacionadas do corpus do curso.
tdm <- matriz_tf(lapply(docs_aula(), tokenizar)) # Prepara as presencas documentais.
tab_pares <- lapply(pares, function(par) { df1 <- sum(tdm[par[1], ] > 0); df2 <- sum(tdm[par[2], ] > 0); inter <- sum(tdm[par[1], ] > 0 & tdm[par[2], ] > 0); data.frame(termo1 = par[1], termo2 = par[2], documentos_intersecao = inter, soma_bits = log2(8 / df1) + log2(8 / df2), bits_conjuntos = if (inter > 0) log2(8 / inter) else Inf) }) # Mostra quando a soma superestima evidencia.
write.csv(do.call(rbind, tab_pares), "estrutura/resultados/guias/aula01b_shannon_pares.csv", row.names = FALSE, fileEncoding = "UTF-8") # Registra dependencia entre termos.
