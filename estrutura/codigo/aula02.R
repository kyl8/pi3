# R | aula02.R | executar na raiz de pi3 ou nesta pasta.
if (.Platform$OS.type == "windows") invisible(Sys.setlocale("LC_CTYPE", "English_United States.utf8")) # Le fontes UTF-8 no Windows.
if (!file.exists("estrutura/codigos/motor-appa.R")) setwd("../..") # Aceita o caminho usado na demonstracao.
source("estrutura/codigos/motor-appa.R", encoding = "UTF-8") # Carrega funcoes do curso sem rede.
source("estrutura/codigos/config.R", encoding = "UTF-8") # Le as decisoes registradas na ficha.
docs <- readRDS("estrutura/banco-de-dados/docs.rds") # Le os paragrafos reconstituidos por coletar.R.
ix <- montar(docs, cfg) # Representa o corpus com as mesmas decisoes das consultas.
consultas <- c("santos fundado primeiros titulos", "portuguesa santista estadio cores", "jabaquara historia santos") # Usa as tres perguntas canonicas da ficha.
topos <- list(); contribuicoes <- list() # Guarda rankings e termos que puxaram o topo.
for (q in consultas) { # Executa a demonstracao em tres consultas.
  rk <- ranking_cosseno(q, ix, cfg); qw <- vetor_consulta(preparar(q, cfg), ix$vocab, ix$idf_tfidf) # Calcula ranking e vetor da consulta.
  top <- head(rk, 5); melhor <- names(top)[1] # Identifica o vencedor de cada busca.
  contrib <- qw * ix$w[, melhor] / (sqrt(sum(qw^2)) * sqrt(sum(ix$w[, melhor]^2))) # Decompoe o cosseno por termo.
  contrib <- sort(contrib[contrib > 0], decreasing = TRUE) # Destaca apenas termos que contribuiram.
  topos[[length(topos) + 1]] <- data.frame(consulta = q, posicao = seq_along(top), documento = names(top), cosseno = unname(top), texto = unname(docs[names(top)])) # Mantem o texto para conferencia ao vivo.
  contribuicoes[[length(contribuicoes) + 1]] <- data.frame(consulta = q, documento = melhor, termo = names(contrib), contribuicao_cosseno = unname(contrib)) # Fundamenta a explicacao com termo e numero.
  cat("\nConsulta:", q, "\n"); print(round(top, 4)); print(round(head(contrib, 3), 4)) # Exibe o roteiro de demonstracao.
} # Termina a demonstracao.
write.csv(do.call(rbind, topos), "estrutura/resultados/guias/entrega1_tres_consultas.csv", row.names = FALSE, fileEncoding = "UTF-8") # Grava o ranking esperado na ficha.
write.csv(do.call(rbind, contribuicoes), "estrutura/resultados/guias/entrega1_contribuicoes.csv", row.names = FALSE, fileEncoding = "UTF-8") # Grava a explicacao quantitativa.
