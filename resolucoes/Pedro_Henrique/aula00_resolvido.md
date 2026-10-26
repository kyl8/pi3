# Resolução — PI III — aula00

**Aluno:** Pedro Henrique · **Grupo:** APPA · **Data:** 2026-10-25.
Respostas preparadas com apoio de Codex a pedido do aluno. Este arquivo é um caderno
de resolução, não um registro de presença nem prova de desempenho individual.
Fonte: [guia original](../../tutoras/GUIA_ESTUDO_aula00.md); exemplos e gabaritos da disciplina.

### Checkpoint 1

*Sem rodar: `length(docs[c(2, 4, 6)])` e `c(10, 20) * 3` — o que sai de cada um?*

**Minha resolução:** `[1] 3` (três elementos); `[1] 30 60` (cada um vezes 3).
### Checkpoint 2

*Sem rodar: o que sai de `names(docs)[c(1, 8)]`? E `docs[["d2"]]` aparece com ou sem o `d2` em cima?*

**Minha resolução:** `[1] "d1" "d8"`; sem — o colchete duplo tira o nome.
### Checkpoint 3

*Sem rodar: `nchar(c("bm25", "de"))` e `length(c("bm25", "de"))`?*

**Minha resolução:** `4 2`; `2`.
### Checkpoint 4

*Sem rodar: `unlist(strsplit("bm25 e um", " "))` tem quantos elementos, e `strsplit("bm25 e um", " ")` é de que tipo?*

**Minha resolução:** 3 elementos; lista.
### Checkpoint 5

*Escreva `maiuscula`, que recebe um texto e devolve a primeira palavra dele em maiúsculas. Teste com `docs[["d3"]]`.*

**Minha resolução:** `maiuscula <- function(texto) toupper(unlist(strsplit(texto, " "))[1])`; sai `"BM25"`. Só ferramentas dos Módulos 3 e 4.
### Checkpoint 6

*Sem rodar: `sapply(list(a = 1:3, b = 1:5), sum)` — o que sai?*

**Minha resolução:** `a 6`, `b 15` — um vetor nomeado.
### Checkpoint 7

*Sem rodar: `table(factor(tokens[["d2"]], levels = vocab))` — o que sai, e em que ordem?*

**Minha resolução:** `de 1`, `modelo 1`, `busca 0` — na ordem de `vocab`.
### Checkpoint 8

*Sem rodar: `m * c(2, 3)` — o que sai?*

**Minha resolução:** `de: 2 2`; `modelo: 0 3`. A linha `de` pega o 2, a linha `modelo` pega o 3.
### Checkpoint 9

*Sem rodar: `grep("documentos$", docs)`? E `grep("^e", docs)`?*

**Minha resolução:** `5 6` — d1 e d2 também têm "documentos", mas não no fim; `6` — só d6 começa com "e" ("embeddings").
### Checkpoint 10

*Sem rodar: `gsub("o", "0", docs[["d5"]])`? E `sub(" .*$", "", docs[["d3"]])`?*

**Minha resolução:** `"0 indice invertid0 acelera a busca em muit0s d0cument0s"`; `"bm25"`.
### Checkpoint 11

*Leia em voz alta, passo a passo, o que `names(docs)[grepl("busca", docs)]` faz — e diga o que sai.*

**Minha resolução:** `grepl` dá 8 `TRUE`/`FALSE`; o colchete filtra os nomes onde é `TRUE`; sai `"d5" "d7"`.

## Verificação final resolvida

| módulo | pergunta | minha resposta |
|---|---|---|
| **1** | O primeiro elemento de um vetor em R é `docs[0]` ou `docs[1]`? O que `docs[0]` devolve? | `docs[1]`; `docs[0]` devolve um vetor vazio (`named character(0)`) |
| **2** | Por que `docs["d5"]` mostra `d5` em cima do texto, e `docs[["d5"]]` não? | colchete simples preserva o nome; duplo extrai só o valor |
| **3** | `length("bm25")` e `nchar("bm25")` — quanto dá cada um, e por quê? | 1 e 4: uma string é um vetor de um elemento; `nchar` conta caracteres |
| **4** | Por que `strsplit` precisa de `unlist` depois? | devolve lista (pode receber vários textos); `unlist` achata para vetor |
| **5** | Numa função em R sem `return`, o que é devolvido? | o valor da última expressão do corpo |
| **6** | Quando usar `lapply` e quando `sapply`? | `lapply` quando quer lista (tamanhos diferentes); `sapply` quando quer vetor ou matriz (tamanhos iguais) |
| **7** | O que `factor(x, levels = vocab)` acrescenta ao `table`? | categorias fixas na ordem de `vocab`, inclusive as de contagem zero — todos os vetores ficam do mesmo tamanho |
| **8** | Em `m * peso`, com `m` de 2 linhas e `peso` de 2 elementos, qual linha pega qual peso — e por quê? | a linha 1 pega o primeiro, a linha 2 o segundo: o R percorre por coluna e recicla `peso` a cada coluna |
| **9** | Por que `grep("de", docs)` acha d4 ("aprendizado … moderna")? | regex casa pedaço: "de" está dentro de "moderna" |
| **10** | Qual é a diferença entre `sub` e `gsub`, e o que `[^a-z ]` significa? | `sub` troca a primeira ocorrência, `gsub` todas; `[^a-z ]` é qualquer caractere que **não** é letra minúscula nem espaço |
| **11** | Na Aula 01, `lapply(docs, tokenizar)` devolve o quê? | uma lista com 8 vetores de tokens, um por documento |

## Execução

O script `estrutura/codigos/2026-10-25-appa-GuiasEstudo.R` executa os exemplos
canônicos e a aplicação ao corpus congelado. As saídas ficam em `estrutura/resultados/guias/`.
