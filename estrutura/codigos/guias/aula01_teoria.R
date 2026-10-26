# R | aula01_teoria.R | blocos literais do guia; executar pelo runner.

# Bloco 1
docs <- c(                                                          # vetor de caracteres, com nomes
  d1 = "recuperacao de informacao ordena documentos por relevancia", # 7 palavras
  d2 = "o modelo de espaco vetorial representa documentos como vetores", # 9
  d3 = "bm25 e um modelo probabilistico de ranqueamento de texto",   # 9
  d4 = "aprendizado estatistico fundamenta a recuperacao moderna",   # 6
  d5 = "o indice invertido acelera a busca em muitos documentos",    # 9
  d6 = "embeddings capturam a semantica de palavras e documentos",   # 8
  d7 = "a avaliacao mede a relevancia dos resultados da busca",      # 9
  d8 = "ciencia de dados combina estatistica e programacao"          # 7
)                                                                   # fecha o c(...)

# Bloco 2
tokenizar <- function(texto) {                    # (já carregada pelo motor01.R)
  t <- unlist(strsplit(tolower(texto), "\\s+"))   # minúsculas; quebra em um ou mais espaços
  t[nzchar(t)]                                    # tira o "" que sobra de espaço na ponta
}

# Bloco 3
tokens <- lapply(docs, tokenizar)   # aplica a cada documento -> lista de 8 vetores
tokens[["d1"]]                      # os termos de d1

# Bloco 4
vocab <- sort(unique(unlist(tokens)))   # junta tudo, tira repetidos, ordena
length(vocab)                           # quantos termos distintos

# Bloco 5
freq <- table(unlist(tokens))          # conta quantas vezes cada termo aparece no corpus todo
sort(freq, decreasing = TRUE)[1:6]     # do mais frequente ao menos; só os 6 primeiros

# Bloco 6
docs9 <- c(docs, d9 = "porto de santos")                     # uma cópia com um 9º documento
length(sort(unique(unlist(lapply(docs9, tokenizar)))))       # o vocabulário cresce quanto?

# Bloco 7
tdm <- sapply(tokens, function(tk) {              # para cada documento (tk = seus tokens)...
  as.integer(table(factor(tk, levels = vocab)))   # ...conta cada termo do vocab neste doc
})                                                # sapply empilha os 8 vetores em colunas
rownames(tdm) <- vocab                            # dá nome às linhas: os termos

# Bloco 8
busca_booleana <- function(termo, tdm) {                # recebe um termo e a matriz
  termo <- tolower(termo)                               # mesma normalização da tokenização
  if (!termo %in% rownames(tdm)) return(character(0))   # termo inexistente: devolve vazio
  colnames(tdm)[tdm[termo, ] > 0]                       # nomes das colunas com contagem > 0
}                                                       # fim da função

# Bloco 9
df <- 1:8                                    # em quantos docs o termo aparece: 1 a 8
plot(df, log(8 / df), type = "b",            # o idf de cada caso, pontos ligados por linha
     xlab = "df", ylab = "idf = log(8/df)")  # nomes dos eixos

# Bloco 10
N   <- ncol(tdm)             # 8 documentos
df  <- rowSums(tdm > 0)      # em quantos docs cada termo aparece (TRUE conta como 1)
idf <- log(N / df)           # um idf por termo: vetor de 45
tfidf <- tdm * idf           # cada linha da matriz vezes o seu idf

# Bloco 11
grep("recupera", docs)             # acha "recuperacao": casa PEDACO -> [1] 1 4
busca_booleana("recupera", tdm)    # o TERMO "recupera" nao existe -> character(0)
