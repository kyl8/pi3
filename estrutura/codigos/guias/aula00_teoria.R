# R | aula00_teoria.R | blocos literais do guia; executar pelo runner.

# Bloco 1
1 + 1   # o R calcula e mostra o resultado

# Bloco 2
docs <- c(                                                          # c() = "combine": cria um vetor; <- atribui
  d1 = "recuperacao de informacao ordena documentos por relevancia", # nome = texto
  d2 = "o modelo de espaco vetorial representa documentos como vetores", # cada linha:
  d3 = "bm25 e um modelo probabilistico de ranqueamento de texto",   #   um documento,
  d4 = "aprendizado estatistico fundamenta a recuperacao moderna",   #   com o seu nome
  d5 = "o indice invertido acelera a busca em muitos documentos",    #   (d1 a d8)
  d6 = "embeddings capturam a semantica de palavras e documentos",   # a virgula separa
  d7 = "a avaliacao mede a relevancia dos resultados da busca",      #   um do outro
  d8 = "ciencia de dados combina estatistica e programacao"          # o ultimo, sem virgula
)                                                                   # fecha o c(...)

# Bloco 3
length(docs)   # quantos elementos tem o vetor?
docs[1]        # o primeiro — R começa em 1
docs[0]        # e o "zero"?

# Bloco 4
docs["d5"]      # pelo NOME, colchete simples: vem COM o nome em cima
docs[["d5"]]    # colchete duplo: SÓ o valor
names(docs)     # todos os nomes

# Bloco 5
nchar(docs)                    # quantos caracteres tem cada documento (espaços contam)
toupper(docs[["d8"]])          # tudo maiúsculo; tolower faz o inverso
substr(docs[["d1"]], 1, 11)    # do caractere 1 ao 11, inclusive

# Bloco 6
paste0("d", 1:8)                          # cola sem separador: é como os nomes de docs nasceram
paste("doc", names(docs))                 # cola com espaço entre os pedaços
paste(c("a", "b", "c"), collapse = "-")   # junta um VETOR numa string só

# Bloco 7
frase <- substr(docs[["d1"]], 1, 25)   # os 25 primeiros caracteres de d1: três palavras
strsplit(frase, " ")                   # quebra no espaço -> devolve uma LISTA

# Bloco 8
unlist(strsplit(frase, " "))   # "achata" a lista: vira um vetor simples

# Bloco 9
tokenizar <- function(texto) {     # function(argumentos) { corpo }
  texto <- tolower(texto)          # minúsculas: "Modelo" e "modelo" viram o mesmo
  unlist(strsplit(texto, " "))     # a ÚLTIMA expressão é o valor devolvido
}                                  # fim da função
tokenizar(frase)                   # testa na frase do Módulo 4

# Bloco 10
tokens <- lapply(docs, tokenizar)   # tokenizar em cada documento -> LISTA de 8 vetores
length(tokens)                      # quantos elementos tem a lista?
tokens[["d4"]]                      # o vetor de tokens de d4

# Bloco 11
sapply(tokens, length)   # quantos tokens em cada documento -> vetor NOMEADO

# Bloco 12
table(tokens[["d3"]])["de"]                           # quantas vezes "de" aparece em d3
sort(table(tokens[["d3"]]), decreasing = TRUE)[1:3]   # os 3 mais frequentes de d3

# Bloco 13
vocab <- c("de", "modelo", "busca")               # um vocabulário de 3 termos, fixado por nós
table(factor(tokens[["d3"]], levels = vocab))     # conta SÓ esses, NESSA ordem, com zeros

# Bloco 14
c("modelo", "busca") %in% tokens[["d3"]]              # está em d3? um TRUE/FALSE por termo
tokens[["d1"]][!tokens[["d1"]] %in% c("de", "por")]   # os tokens de d1 que NÃO são "de" nem "por"

# Bloco 15
m <- matrix(c(1, 0, 1, 1), nrow = 2)   # 4 números, em 2 linhas
rownames(m) <- c("de", "modelo")       # nomes das linhas: os termos
colnames(m) <- c("d1", "d2")           # nomes das colunas: os documentos
m                                      # mostra a matriz

# Bloco 16
peso <- c(1, 10)   # um peso por LINHA: "de" vale 1, "modelo" vale 10
m * peso           # reciclagem: o vetor se repete ao longo das colunas

# Bloco 17
grep("modelo", docs)                 # em QUAIS documentos aparece "modelo"? posições
grepl("modelo", docs)                # o mesmo, como TRUE/FALSE por documento
names(docs)[grepl("modelo", docs)]   # os NOMES dos que têm — o filtro do Módulo 7

# Bloco 18
grep("^o ", docs)            # começam com "o "
grep("busca$", docs)         # terminam em "busca"
grep("busca|modelo", docs)   # têm "busca" OU "modelo"
grep("[0-9]", docs)          # têm algum dígito

# Bloco 19
grep("de", docs)     # quem tem "de"?
grep(" de ", docs)   # e "de" entre espaços?

# Bloco 20
sub("de", "DE", docs[["d3"]])    # troca a PRIMEIRA ocorrência
gsub("de", "DE", docs[["d3"]])   # troca TODAS

# Bloco 21
gsub("[aeiou]", "", docs[["d1"]])   # apaga todas as vogais
gsub("[0-9]+", "", docs[["d3"]])    # apaga sequências de dígitos
grep("[a-z]{12}", docs)             # tem uma palavra com 12 letras seguidas?

# Bloco 22
sub(" .*$", "", docs[["d1"]])   # do primeiro espaço até o fim: apaga -> sobra a primeira palavra
sub("^.* ", "", docs[["d1"]])   # do início até o ÚLTIMO espaço: apaga -> sobra a última palavra

# Bloco 23
sujo <- "  O Modelo   de Espaco   Vetorial!! "   # espaços sobrando, caixa mista, pontuação
x <- trimws(sujo)                # tira os espaços das pontas
x <- tolower(x)                  # minúsculas
x <- gsub("[^a-z ]", "", x)      # apaga tudo que NÃO é letra minúscula nem espaço
x <- gsub("\\s+", " ", x)        # um ou mais espaços -> um só
x                                # o texto limpo
