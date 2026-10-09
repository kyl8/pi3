# Consolidado — PI III — Aula 02 — 2026-10-09
*guia versão 3 · tutora: Antigravity Lead Agent · sessão individual (teoria) · motor02*
**Aluno:** Grupo APPA (Arthur Galvão, Pedro Henrique, Ailana)

## 1. O que foi passado
- M1 — por que somar pesos não ordena
- M2 — termo = dimensão, documento = vetor
- M3 — a matriz TF-IDF $45 \times 8$ dentro de `ix`; a correspondência com a Aula 01
- M4 — cosseno: conta à mão em 2D; ignora o tamanho; a função `cosseno` e o vetor nulo
- M5 — normalização por coluna; vetores unitários
- M6 — a consulta como vetor, com o idf do corpus
- M7 — ranking $d_1 > d_3 > d_4 > d_2$; a conta de $d_4$ à mão
- M8 — termos independentes; sinônimos têm cosseno zero

## 2. Como foi o aprendizado — opinião da tutora
O grupo interagiu muito bem, executando as previsões de saída com bastante acurácia e sem medo de errar nas contas em 2D. A leitura do cosseno como medida de similaridade angular foi compreendida rapidamente e aplicada para prever e avaliar o ranking da consulta "modelo de recuperacao". Mostraram facilidade em interagir com o objeto `ix` no Colab, lidando com a mudança de escopo (tudo dentro do motor agora). Pediram o detalhamento da conta de $d_4$ à mão, percebendo a penalização da ausência do termo "modelo", o que cristalizou o entendimento de que os vetores sem os termos em comum zeram o produto escalar. A ideia da independência de dimensões também foi fixada ao analisarem casos de sinônimos ("carro" vs "automóvel").
