# R | aula02_teoria.R | blocos literais do guia; executar pelo runner.

# Bloco 1
x <- c(d1 = 2.6, d2 = 0.9, q = 2.2)          # peso de cada vetor no "termo A" (dados inventados)
y <- c(d1 = 0.8, d2 = 2.2, q = 1.5)          # peso de cada vetor no "termo B"
plot(c(0, 6), c(0, 3), type = "n", asp = 1,  # quadro vazio; asp = 1: mesma escala nos dois eixos
     xlab = "termo A", ylab = "termo B")     # nomes dos eixos
arrows(0, 0, x, y)                           # uma seta da origem (0, 0) ate cada ponta
text(x, y, names(x), pos = 3)                # o nome de cada vetor, acima da ponta (pos = 3)

# Bloco 2
names(ix)                                  # o que montar() guardou na lista ix
dim(ix$tf)                                 # a matriz termo-documento: o tdm da Aula 01

# Bloco 3
round(ix$idf_tfidf[c("de", "documentos", "modelo")], 2)   # o idf de tres termos: o idf da Aula 01
round(ix$w[c("documentos", "modelo", "de", "a"), ], 2)    # TF-IDF de quatro termos: o tfidf da Aula 01

# Bloco 4
cosseno <- function(a, b) {                  # recebe dois vetores do mesmo tamanho
  den <- sqrt(sum(a^2)) * sqrt(sum(b^2))     # o produto das normas: o denominador
  if (den == 0) return(0)                    # vetor nulo: nada em comum (por que esta linha? abaixo)
  sum(a * b) / den                           # produto escalar dividido pelas normas
}                                            # fim da funcao
cosseno(c(1, 1), c(2, 1))                    # o exemplo feito a mao

# Bloco 5
norm_cols <- function(m) {                   # recebe uma matriz termos x documentos
  nrm <- sqrt(colSums(m^2))                  # a norma de cada coluna: a raiz da soma dos quadrados
  nrm[nrm == 0] <- 1                         # coluna toda zero: divide por 1 (sem isto, 0/0 = NaN)
  sweep(m, 2, nrm, "/")                      # divide cada coluna (2) pela sua norma
}                                            # fim da funcao
wn <- norm_cols(ix$w)                        # TF-IDF com cada coluna de comprimento 1
round(colSums(wn^2), 2)                      # o comprimento ao quadrado de cada documento

# Bloco 6
vetor_consulta <- function(termos, vocab, idf) {            # termos da consulta, o vocabulario, o idf
  q <- as.integer(table(factor(termos, levels = vocab)))    # 45 contagens, como um documento
  q * idf                                                   # os MESMOS idf do corpus (os nomes vem de idf)
}                                                           # fim da funcao
qw <- vetor_consulta(tokenizar("modelo de recuperacao"), ix$vocab, ix$idf_tfidf)   # a consulta da aula
round(qw[qw > 0], 2)                                        # so os termos presentes

# Bloco 7
ranking_cosseno <- function(consulta, ix) {                           # um texto e o indice
  qw <- vetor_consulta(tokenizar(consulta), ix$vocab, ix$idf_tfidf)   # a consulta no espaco do corpus
  s  <- apply(ix$w, 2, function(d) cosseno(qw, d))                    # um cosseno por coluna (documento)
  sort(s, decreasing = TRUE)                                          # do mais parecido ao menos
}                                                                     # fim da funcao
round(ranking_cosseno("modelo de recuperacao", ix), 3)               # o primeiro ranking do motor
