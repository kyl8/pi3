# R | aula05_teoria.R | blocos literais do guia; executar pelo runner.

# Bloco 1
round(ranking_cosseno("modelo de recuperacao", ix, cfg), 3)   # cosseno (Aula 02), 3 casas
round(ranking_bm25("modelo de recuperacao", ix, cfg), 3)      # BM25 (Aula 04), 3 casas

# Bloco 2
bm   <- names(ranking_bm25("modelo de recuperacao", ix, cfg))[1:3]     # top-3 do BM25
co   <- names(ranking_cosseno("modelo de recuperacao", ix, cfg))[1:3]  # top-3 do cosseno
pool <- union(bm, co)      # une os dois e tira os repetidos: a pool desta consulta
pool                       # quais documentos alguém vai julgar

# Bloco 3
gab <- c(d1 = 1, d2 = 2, d3 = 2, d4 = 0, d5 = 0, d6 = 1, d7 = 0, d8 = 0)  # o gabarito da aula
gab[names(ranking_bm25("modelo de recuperacao", ix, cfg))]                # os graus, na ordem do BM25

# Bloco 4
m <- matrix(c(18, 3, 0,     # A deu 0: B deu 0 em 18 itens, 1 em 3, 2 em nenhum
               2, 6, 2,     # A deu 1
               0, 2, 7),    # A deu 2
            nrow = 3, byrow = TRUE)   # 3 linhas, preenchidas linha a linha
m                                     # confira contra a tabela

# Bloco 5
n  <- sum(m)               # total de itens: 40
diag(m)                    # os acordos: 18 6 7
po <- sum(diag(m)) / n     # observada: 31 / 40
po                         # 0.775

# Bloco 6
pe <- sum(rowSums(m) * colSums(m)) / n^2   # totais de A vezes totais de B, nota a nota, sobre n^2
pe                                         # 0.381875
(po - pe) / (1 - pe)                       # o kappa: 0.635996

# Bloco 7
kappa_matriz <- function(m) {                       # recebe a matriz de concordância
  n  <- sum(m)                                      # total de itens
  po <- sum(diag(m)) / n                            # observada: a diagonal
  pe <- sum(rowSums(m) * colSums(m)) / n^2          # esperada por acaso: as marginais
  k  <- if (pe < 1) (po - pe) / (1 - pe) else NA    # pe = 1: indefinido (sem isto, NaN)
  c(po = po, pe = pe, kappa = k)                    # as três medidas, com nome
}                                                   # fim da função

# Bloco 8
round(kappa_matriz(m), 3)   # as três medidas da matriz da aula, 3 casas

# Bloco 9
m0 <- matrix(c(10, 0, 0, 0, 0, 0, 0, 0, 0), nrow = 3)   # os dois deram 0 aos 10 itens
round(kappa_matriz(m0), 3)                              # po e pe valem 1

# Bloco 10
outro <- c(d1 = 2, d2 = 2, d3 = 2, d4 = 0, d5 = 0, d6 = 1, d7 = 0, d8 = 0)  # um juiz que deu 2 ao d1
mt <- table(factor(gab, levels = 0:2), factor(outro, levels = 0:2))         # a matriz dos dois
mt                                                                          # linhas: gab; colunas: outro

# Bloco 11
library(ggplot2)                                      # pacote de gráficos (já vem no Colab)
d <- expand.grid(A = 0:2, B = 0:2)                    # as 9 combinações de notas (A, B)
d$n <- c(18, 2, 0,  3, 6, 2,  0, 2, 7)                # as contagens, na ordem do expand.grid (A varia primeiro)
ggplot(d, aes(x = B, y = A, fill = n)) +              # x = nota de B, y = nota de A, cor = contagem
  geom_tile() +                                       # um quadrado por célula
  geom_text(aes(label = n), size = 6) +               # escreve o número dentro
  scale_y_reverse() +                                 # A = 0 em cima, como na tabela
  labs(x = "juiz B deu", y = "juiz A deu")            # nomes dos eixos

# Bloco 12
round(kappa_matriz(matrix(c(27, 2, 0, 1, 0, 0, 0, 0, 0), nrow = 3, byrow = TRUE)), 3)  # a matriz do exercício
