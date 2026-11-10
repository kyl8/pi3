# Aula 02 - Parte D - Motor de Busca com Cosseno
# Grupo APPA
# Executar na raiz do repositorio (ou em estrutura/codigos). Usa apenas arquivos locais.

if (!file.exists("estrutura/codigos/motor-appa.R")) setwd("../..") # Aceita execucao a partir de estrutura/codigos.
source("estrutura/codigos/motor-appa.R", encoding = "UTF-8") # Funcoes do curso (cosseno, norm_cols, ranking_cosseno...) e preparo APPA.
source("estrutura/codigos/config.R", encoding = "UTF-8")     # cfg: decisoes do grupo.
docs   <- readRDS("estrutura/banco-de-dados/docs.rds")
origem <- readRDS("estrutura/banco-de-dados/origem.rds")
ix     <- montar(docs, cfg)
estado()

# M9 - Documento de maior norma (mais longo)
normas <- sqrt(colSums(ix$w^2))
mais_longo <- names(which.max(normas))
cat("Documento mais longo (maior norma):", mais_longo, "\n")

# M10 - 3 consultas de trabalho do projeto
q1 <- "fundacao primeiros titulos santos futebol clube"
q2 <- "estadio cores portuguesa santista"
q3 <- "trajetoria importancia jabaquara atletico clube"

# M11 - Consulta que erra
# Com stopwords removidas pelo preparo, "o" some; o ranking depende so de "santos",
# que aparece em quase todo paragrafo do Santos FC: consulta pouco discriminante.
consulta_erra <- "o santos"
ranking_errado <- ranking_cosseno(consulta_erra, ix, cfg)
cat("\nRanking errado ('o santos'):\n")
print(round(ranking_errado[1:5], 3))

# Avaliando consultas de trabalho
for (q in c(q1, q2, q3)) {
  rk <- ranking_cosseno(q, ix, cfg)
  cat("\nRanking ('", q, "'):\n", sep = "")
  print(round(rk[1:5], 3))
}
