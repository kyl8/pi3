# R | aula03_teoria.R | blocos literais do guia; executar pelo runner.

# Bloco 1
brutos <- c(                                                            # o corpus como chega: vetor nomeado
  d1 = "Recuperacao de Informacao: ORDENA documentos, por relevancia!",  # maiúsculas, dois-pontos, vírgula, !
  d2 = "O modelo de espaco-vetorial representa documentos (como vetores).", # hífen, parênteses
  d3 = "BM25 e um modelo probabilistico de ranqueamento de texto.",      # ponto final
  d4 = "Aprendizado estatistico fundamenta a recuperacao moderna.",      # ponto final
  d5 = "O indice invertido acelera a busca em muitos documentos.",       # ponto final
  d6 = "Embeddings capturam a semantica de palavras e documentos.",      # ponto final
  d7 = "A avaliacao mede a relevancia dos resultados da busca.",         # ponto final
  d8 = "Ciencia de dados combina estatistica e programacao."             # ponto final
)                                                                       # fecha o c(...)

# Bloco 2
tokenizar(brutos[["d1"]])   # a tokenizar do motor, sobre o texto sujo

# Bloco 3
limpar <- function(x) {             # recebe um texto (ou um vetor de textos)
  x <- tolower(x)                   # 1) tudo minúsculo
  x <- gsub("[^a-z0-9 ]", " ", x)   # 2) troca por espaço tudo que NÃO for letra, dígito ou espaço
  x <- gsub("\\s+", " ", x)         # 3) colapsa 2+ espaços em um só
  trimws(x)                         # 4) remove espaços das pontas
}                                   # fim da função
limpar(brutos[["d1"]])              # o d1 sujo, limpo

# Bloco 4
limpos <- limpar(brutos)   # os 8 documentos de uma vez; os nomes d1..d8 são preservados
head(limpos, 3)            # só os 3 primeiros

# Bloco 5
round(ranking_cosseno("modelo de recuperacao", ix), 3)   # a consulta da Aula 02, com o "de"
round(ranking_cosseno("modelo recuperacao", ix), 3)      # a mesma, sem o "de"

# Bloco 6
stopwords <- c("de","o","a","e","um","por","como","que","da","do")   # nossa lista, curta
tok <- function(x) unlist(strsplit(limpar(x), " "))                   # limpa e quebra em termos
sem_stop <- function(x) { t <- tok(x); t[!t %in% stopwords] }         # fica quem NÃO está na lista
sem_stop(brutos[["d2"]])                                              # o d2 sujo, limpo e filtrado

# Bloco 7
stem <- function(t) sub("(cao|mento|dade|ais|s)$", "", t)          # apaga UM destes sufixos, no FIM
sapply(c("documentos","ranqueamento","relevancia","modelos"), stem)  # aplica a cada palavra

# Bloco 8
install.packages("SnowballC")     # instala o pacote (o Colab esquece a cada sessão)
library(SnowballC)                # carrega o pacote
wordStem(c("documentos", "documento", "documentação"), language = "portuguese")   # três formas

# Bloco 9
wordStem("documentacao", language = "portuguese")   # a mesma palavra, sem ç e sem ã

# Bloco 10
freq <- c(praias = 5, ilhas = 4, ruas = 3, praia = 2)               # quantas vezes cada palavra aparece
simbolos <- lapply(names(freq), function(p) strsplit(p, "")[[1]])   # cada palavra vira seus caracteres
names(simbolos) <- names(freq)                                       # devolve os nomes
simbolos[["praias"]]                                                 # os símbolos de "praias"

# Bloco 11
contar_pares <- function(simb, freq) {    # recebe os símbolos e as frequências
  pares <- integer(0)                     # placar vazio
  for (p in names(simb)) {                # para cada palavra...
    s <- simb[[p]]                        # ...pegue seus símbolos
    for (i in seq_len(length(s) - 1)) {   # ...e cada par vizinho
      k <- paste0(s[i], s[i + 1])         # nome do par: "pr", "ra"...
      pares[k] <- ifelse(is.na(pares[k]), 0, pares[k]) + freq[[p]]   # par novo começa em 0; soma a FREQUÊNCIA da palavra
    }                                     # fim do laço dos pares
  }                                       # fim do laço das palavras
  sort(pares, decreasing = TRUE)          # do mais comum ao mais raro
}                                         # fim da função
head(contar_pares(simbolos, freq), 4)     # os 4 primeiros do placar

# Bloco 12
palavras <- c(praias = "p r a i a s", ilhas = "i l h a s",   # símbolos separados por espaço
              ruas   = "r u a s",     praia = "p r a i a")   # (continuação do mesmo vetor)
gsub("a s", "as", palavras)                                  # "a s" (dois símbolos) -> "as" (um só)

# Bloco 13
prep <- function(x) sem_stop(x)                   # limpa + tokeniza + tira stopwords: o pipeline inteiro
postings <- list()                                # o índice começa vazio
for (d in names(brutos)) {                        # 1) para cada documento...
  for (termo in unique(prep(brutos[[d]]))) {      # 2) ...cada termo DISTINTO dele...
    postings[[termo]] <- c(postings[[termo]], d)  # 3) ...anexa o documento à lista do termo
  }                                               # fim do laço dos termos
}                                                 # fim do laço dos documentos

# Bloco 14
postings[["documentos"]]   # a lista de postagens de "documentos"
postings[["modelo"]]       # e a de "modelo"

# Bloco 15
p_sem <- list()                                  # outro índice, só para comparar
for (d in names(brutos)) {                       # o mesmo laço...
  for (termo in tok(brutos[[d]])) {              # ...com tok (sem tirar stopwords) e sem unique
    p_sem[[termo]] <- c(p_sem[[termo]], d)       # anexa o documento
  }                                              # fim do laço dos termos
}                                                # fim do laço dos documentos
p_sem[["de"]]                                    # quem tem "de"?

# Bloco 16
busca_AND <- function(consulta) {                                # recebe a consulta como texto
  termos <- prep(consulta)                                       # a MESMA limpeza usada na indexação
  if (!all(termos %in% names(postings))) return(character(0))   # algum termo fora do dicionário: nenhum documento
  Reduce(intersect, postings[termos])                            # intersecta as listas, duas a duas
}                                                                # fim da função
busca_AND("modelo documentos")                                   # os dois termos
busca_AND("busca documentos")                                    # outros dois

# Bloco 17
length(postings)                                    # termos indexados
sort(lengths(postings), decreasing = TRUE)[1:4]     # os termos com mais documentos
