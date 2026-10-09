# Aula 02 - Parte D - Motor de Busca com Cosseno
# Grupo APPA

REPO <- "https://raw.githubusercontent.com/kyl8/pi3/main/"
source("https://raw.githubusercontent.com/fractalarea/pi3-motor-de-busca/main/motor/motor02.R")
download.file(paste0(REPO, "estrutura/codigos/config.R"), "config.R")
source("config.R")
docs   <- readRDS(gzcon(url(paste0(REPO, "estrutura/banco-de-dados/docs.rds"))))
origem <- readRDS(gzcon(url(paste0(REPO, "estrutura/banco-de-dados/origem.rds"))))
ix     <- montar(docs, cfg)
estado()

# M9 - Documento de maior norma (mais longo)
wn <- norm_cols(ix$w)
normas <- sqrt(colSums(ix$w^2))
mais_longo <- names(which.max(normas))
cat("Documento mais longo (maior norma):", mais_longo, "\n")

# M10 - 3 consultas de trabalho do projeto
q1 <- "fundacao primeiros titulos santos futebol clube"
q2 <- "estadio cores portugues santista"
q3 <- "trajetoria importancia jabaquara atletico clube"

# M11 - Consulta que erra
consulta_erra <- "o santos" # Stopword 'o' infla o calculo mas nao eh bom indicativo de relevancia
ranking_errado <- ranking_cosseno(vetor_consulta(tokenizar(consulta_erra), ix$vocab, ix$idf_tfidf), wn)
cat("\nRanking errado ('o santos'):\n")
print(round(ranking_errado[1:5], 3))

# Avaliando queries corretas
ranking_q1 <- ranking_cosseno(vetor_consulta(tokenizar(q1), ix$vocab, ix$idf_tfidf), wn)
cat("\nRanking Q1 ('fundacao primeiros titulos santos futebol clube'):\n")
print(round(ranking_q1[1:5], 3))

ranking_q2 <- ranking_cosseno(vetor_consulta(tokenizar(q2), ix$vocab, ix$idf_tfidf), wn)
cat("\nRanking Q2 ('estadio cores portugues santista'):\n")
print(round(ranking_q2[1:5], 3))

ranking_q3 <- ranking_cosseno(vetor_consulta(tokenizar(q3), ix$vocab, ix$idf_tfidf), wn)
cat("\nRanking Q3 ('trajetoria importancia jabaquara atletico clube'):\n")
print(round(ranking_q3[1:5], 3))
