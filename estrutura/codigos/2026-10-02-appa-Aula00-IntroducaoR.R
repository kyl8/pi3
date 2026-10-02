# Execucao completa e geracao dos consolidados da Aula 00 (Teoria + Parte D)
setwd("C:/Users/Arthur/Documents/IA_workspace/drive_aula00")

# --- Modulo 1 ---
cat("=== Modulo 1 ===\n")
1 + 1

docs <- c(
  d1 = "recuperacao de informacao ordena documentos por relevancia",
  d2 = "o modelo de espaco vetorial representa documentos como vetores",
  d3 = "bm25 e um modelo probabilistico de ranqueamento de texto",
  d4 = "aprendizado estatistico fundamenta a recuperacao moderna",
  d5 = "o indice invertido acelera a busca em muitos documentos",
  d6 = "embeddings capturam a semantica de palavras e documentos",
  d7 = "a avaliacao mede a relevancia dos resultados da busca",
  d8 = "ciencia de dados combina estatistica e programacao"
)

cat("length(docs):", length(docs), "\n")
print(docs[1])
print(docs[0])
print(docs[c(1, 8)])
print(docs[9])
print(c(1, 2, 3) * 2)

# Checkpoint 1
cat("CP1:\n")
print(length(docs[c(2, 4, 6)]))
print(c(10, 20) * 3)

# --- Modulo 2 ---
cat("\n=== Modulo 2 ===\n")
print(docs["d5"])
print(docs[["d5"]])
print(names(docs))
print(docs[c("d1", "d8")])
print(names(docs)[3])
print(docs[["d1"]] == docs[1])

# Checkpoint 2
cat("CP2:\n")
print(names(docs)[c(1, 8)])

# --- Modulo 3 ---
cat("\n=== Modulo 3 ===\n")
print(nchar(docs))
print(toupper(docs[["d8"]]))
print(substr(docs[["d1"]], 1, 11))
print(paste0("d", 1:8))
print(paste("doc", names(docs)))
print(paste(c("a", "b", "c"), collapse = "-"))

# Checkpoint 3
cat("CP3:\n")
print(nchar(c("bm25", "de")))
print(length(c("bm25", "de")))

# --- Modulo 4 ---
cat("\n=== Modulo 4 ===\n")
frase <- substr(docs[["d1"]], 1, 25)
print(strsplit(frase, " "))
print(unlist(strsplit(frase, " ")))

# Checkpoint 4
cat("CP4:\n")
print(length(unlist(strsplit("bm25 e um", " "))))
print(class(strsplit("bm25 e um", " ")))

# --- Modulo 5 ---
cat("\n=== Modulo 5 ===\n")
tokenizar <- function(texto) {
  texto <- tolower(texto)
  unlist(strsplit(texto, " "))
}
print(tokenizar(frase))
print(tokenizar("Ciencia de DADOS"))

# Checkpoint 5
maiuscula <- function(texto) toupper(unlist(strsplit(texto, " "))[1])
cat("CP5:\n")
print(maiuscula(docs[["d3"]]))

# --- Modulo 6 ---
cat("\n=== Modulo 6 ===\n")
tokens <- lapply(docs, tokenizar)
cat("length(tokens):", length(tokens), "\n")
print(tokens[["d4"]])
print(sapply(tokens, length))
cat("Total tokens corpus:", sum(sapply(tokens, length)), "\n")

# Checkpoint 6
cat("CP6:\n")
print(sapply(list(a = 1:3, b = 1:5), sum))

# --- Modulo 7 ---
cat("\n=== Modulo 7 ===\n")
print(table(tokens[["d3"]])["de"])
print(sort(table(tokens[["d3"]]), decreasing = TRUE)[1:3])
vocab <- c("de", "modelo", "busca")
print(table(factor(tokens[["d3"]], levels = vocab)))
print(c("modelo", "busca") %in% tokens[["d3"]])
print(tokens[["d1"]][!tokens[["d1"]] %in% c("de", "por")])

# Checkpoint 7
cat("CP7:\n")
print(table(factor(tokens[["d2"]], levels = vocab)))

# --- Modulo 8 ---
cat("\n=== Modulo 8 ===\n")
m <- matrix(c(1, 0, 1, 1), nrow = 2)
rownames(m) <- c("de", "modelo")
colnames(m) <- c("d1", "d2")
print(m)
peso <- c(1, 10)
print(m * peso)
cat("rowSums:\n")
print(rowSums(m))
cat("colSums:\n")
print(colSums(m))

# Checkpoint 8
cat("CP8:\n")
print(m * c(2, 3))

# --- Modulo 9 ---
cat("\n=== Modulo 9 ===\n")
print(grep("modelo", docs))
print(grepl("modelo", docs))
print(names(docs)[grepl("modelo", docs)])
print(grep("^o ", docs))
print(grep("busca$", docs))
print(grep("busca|modelo", docs))
print(grep("[0-9]", docs))
print(grep("de", docs))
print(grep(" de ", docs))

# Checkpoint 9
cat("CP9:\n")
print(grep("documentos$", docs))
print(grep("^e", docs))

# --- Modulo 10 ---
cat("\n=== Modulo 10 ===\n")
print(sub("de", "DE", docs[["d3"]]))
print(gsub("de", "DE", docs[["d3"]]))
print(gsub("[aeiou]", "", docs[["d1"]]))
print(gsub("[0-9]+", "", docs[["d3"]]))
print(grep("[a-z]{12}", docs))
print(sub(" .*$", "", docs[["d1"]]))
print(sub("^.* ", "", docs[["d1"]]))

sujo <- "  O Modelo   de Espaco   Vetorial!! "
x <- trimws(sujo)
x <- tolower(x)
x <- gsub("[^a-z ]", "", x)
x <- gsub("\\s+", " ", x)
cat("Texto limpo:", x, "\n")

# Tokenizar definitiva
tokenizar <- function(texto) unlist(strsplit(tolower(texto), "\\s+"))
print(tokenizar(sujo))

# Checkpoint 10
cat("CP10:\n")
print(gsub("o", "0", docs[["d5"]]))
print(sub(" .*$", "", docs[["d3"]]))

# --- Modulo 11 ---
cat("\n=== Modulo 11 ===\n")
# Checkpoint 11
cat("CP11:\n")
print(names(docs)[grepl("busca", docs)])

# --- Parte D: Modulos 12 a 14 ---
cat("\n=== Parte D - Modulo 12 ===\n")
# 3 frases próprias contextuais da Baixada Santista e Ciencia de Dados
f <- c(
  f1 = "  O Porto   de Santos bateu recorde de movimentacao de cargas em 2026!! ",
  f2 = "A operacao portuaria de Santos movimenta cargas, conteineres e navios... ",
  f3 = "Santos planeja novos investimentos na infraestrutura de logistica portuaria! "
)

print(f)
x_f <- trimws(f)
x_f <- tolower(x_f)
x_f <- gsub("[^a-z ]", "", x_f)
x_f <- gsub("\\s+", " ", x_f)
print(x_f)

tokens_f <- lapply(x_f, tokenizar)
print(tokens_f)
freq_f   <- table(unlist(tokens_f))
print(sort(freq_f, decreasing = TRUE))
cat("Total de tokens:", length(unlist(tokens_f)), "\n")
cat("Tokens unicos:", length(unique(unlist(tokens_f))), "\n")

# --- Parte D - Modulo 13 ---
cat("\n=== Parte D - Modulo 13 ===\n")
cat("1. Comeca com maiuscula:\n")
print(grepl("^\\s*[A-Z]", f))

cat("2. Contem digito:\n")
print(grepl("[0-9]", f))

cat("3. Termina em pontuacao:\n")
print(grepl("[^a-z ]$", trimws(f)))

cat("4. Primeira palavra de cada frase limpa:\n")
print(sub(" .*$", "", x_f))

cat("5. Troca espacos por _:\n")
print(gsub(" ", "_", x_f))

# Checkpoint 13
cat("CP13:\n")
print(grepl("^[A-Z].*a$", trimws(f)))

# Carrega estado.R localmente
source("C:/Users/Arthur/Documents/IA_workspace/drive_aula00/estado.R")
cat("\n=== Estado() no R ===\n")
estado()
