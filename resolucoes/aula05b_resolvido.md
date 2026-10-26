# Resolução — PI III — aula05b

**Apoio:** ChatGPT.
**Aluno:** Pedro Henrique · **Grupo:** APPA · **Data:** 2026-10-25.
**Solicitante:** Grupo APPA — Arthur Galvão, Pedro Henrique e Ailana.
Caderno de resoluções: checkpoints, respostas e exemplos da disciplina.
Fonte: [guia original](../tutoras/GUIA_ESTUDO_aula05b.md); exemplos e gabaritos da disciplina.

### Checkpoint 1

*O cosseno devolve `d1 d3 d4 d2 d6 d8 d5 d7`. Sem rodar, com limiar 2, qual é o `rel` do cosseno?*

**Minha resolução:** `0 1 0 1 0 0 0 0` — `d3` na posição 2, `d2` na 4. Depois ele confere:
```r
rel_cos <- as.integer(names(ranking_cosseno("modelo de recuperacao", ix, cfg)) %in% relevantes)  # o mesmo, para o cosseno
rel_cos                                                                                         # confira com a sua resposta
```
### Checkpoint 2

*Um sistema devolve 10 documentos, 4 são relevantes; o gabarito tem 8 relevantes ao todo. Precisão e recall?*

**Minha resolução:** $4/10 = 0{,}4$; $4/8 = 0{,}5$.
### Checkpoint 3

*Para o `rel_cos` do Módulo 1, `0 1 0 1 0 0 0 0`: quanto valem $\text{P@}3$ e $\text{R@}3$?*

**Minha resolução:** nas 3 primeiras, 1 relevante → $\text{P@}3 = 1/3 = 0{,}333$; $\text{R@}3 = 1/2 = 0{,}5$.
### Checkpoint 4

*No ranking do BM25, se `d2` estivesse na posição 2 e `d1` na 3, em quais $k$ a tabela mudaria?*

**Minha resolução:** só em $k = 2$ — $\text{P@}2$ passa de 0,5 para 1,0, e $\text{R@}2$ de 0,5 para 1,0. Em $k = 3$ os dois relevantes já estão dentro de qualquer jeito: $\text{P@}3$ continua $2/3$.
### Checkpoint 5

*O AP do cosseno: `rel_cos` é `0 1 0 1 0 0 0 0`, $R = 2$. Faça à mão.*

**Minha resolução:** relevantes nas posições 2 e 4 → $\text{P@}2 = 1/2$, $\text{P@}4 = 2/4$ → $\text{AP} = (0{,}5 + 0{,}5)/2 = 0{,}500$. Confere com `sum((cumsum(rel_cos) / seq_along(rel_cos))[rel_cos == 1]) / R`.
### Checkpoint 6

*RR do cosseno, com `rel_cos` = `0 1 0 1 0 0 0 0`?*

**Minha resolução:** `which(rel_cos == 1)` → `2 4`; $\text{RR} = 1/2 = 0{,}5$. A posição 4 não entra.
### Checkpoint 7

*nDCG binário do cosseno, `rel_cos` = `0 1 0 1 0 0 0 0`. À mão, parcela a parcela.*

**Minha resolução:** $\text{DCG} = 1/1{,}585 + 1/2{,}322 = 0{,}631 + 0{,}431 = 1{,}062$; $\text{IDCG} = 1{,}631$ (os mesmos dois relevantes no topo); $\text{nDCG} = 1{,}062/1{,}631 = 0{,}651$. Confere com `dcg(rel_cos) / dcg(sort(rel_cos, decreasing = TRUE))`.
### Checkpoint 8

*nDCG graduado do cosseno. O `g` do cosseno é `1 2 0 2 1 0 0 0` (d1 d3 d4 d2 d6 d8 d5 d7). Parcela a parcela.*

**Minha resolução:** $\text{DCG} = 1/1 + 2/1{,}585 + 0 + 2/2{,}322 + 1/2{,}585 = 1 + 1{,}262 + 0{,}861 + 0{,}387 = 3{,}510$; o IDCG é o mesmo do BM25, $4{,}193$ (mesmos graus); $\text{nDCG} = 3{,}510/4{,}193 = 0{,}837$. Agora ele tem as cinco do cosseno: $0{,}333 \cdot 0{,}500 \cdot 0{,}500 \cdot 0{,}651 \cdot 0{,}837$.
### Checkpoint 9

*Um grupo tem 3 consultas. O BM25 tem AP 0,9, 0,9 e 0,1; o cosseno tem 0,6 nas três. Qual tem o MAP maior? E o que o grupo deveria escrever sobre "qual é melhor"?*

**Minha resolução:** MAP do BM25 $= 1{,}9/3 = 0{,}633$; do cosseno, $0{,}600$ — o BM25 vence na média. Mas são 3 consultas (armadilha 1), a diferença é pequena (armadilha 3), e o BM25 desaba numa — essa consulta merece ser olhada antes de qualquer conclusão.

## Verificação final resolvida

| módulo | pergunta | minha resposta |
|---|---|---|
| **1** | Um terceiro sistema devolve `d6 d2 d8 d3 d1 d4 d5 d7`. Qual é o `rel` com limiar 2? E com limiar 1? | limiar 2: `0 1 0 1 0 0 0 0`; limiar 1: `1 1 0 1 1 0 0 0` |
| **2** | Um buscador mostra 20 resultados, 5 relevantes; o gabarito tem 25 relevantes. Precisão e recall? Qual dos dois daria para estimar sem gabarito? | $5/20 = 0{,}25$; $5/25 = 0{,}2$; a precisão — basta olhar o que foi mostrado |
| **3** | Para `rel` = `0 0 1 1 0 0 0 0` ($R = 2$): $\text{P@}2$, $\text{P@}4$ e $\text{R@}4$? | $0$; $2/4 = 0{,}5$; $2/2 = 1$ |
| **4** | Para `rel` = `0 1 1 0 0 0 0 0`, escreva P@$k$ para $k = 1 \ldots 4$ e diga onde está o dente. | $0$; $0{,}5$; $0{,}667$; $0{,}5$ — sobe em $k = 2$ e $3$ (relevantes), desce em $k = 4$ |
| **5** | `rel` = `0 1 1 0 0 0 0 0`, $R = 2$. AP? E se o gabarito tivesse $R = 4$? | $(1/2 + 2/3)/2 = 0{,}583$; com $R = 4$, $1{,}167/4 = 0{,}292$ — os dois não recuperados valem zero |
| **6** | Duas consultas: o primeiro relevante está na posição 3 numa e na posição 1 na outra. MRR? | $(1/3 + 1)/2 = 0{,}667$ |
| **7** | `rel` binário = `0 0 1 1 0 0 0 0`, $R = 2$. nDCG? | $\text{DCG} = 1/2 + 1/2{,}322 = 0{,}931$; $\text{IDCG} = 1{,}631$; $\text{nDCG} = 0{,}571$ |
| **8** | Se `d1` tivesse grau 2 em vez de 1, o nDCG graduado do BM25 sobe ou desce? Calcule. | `g` = `2 2 2 0 0 1 0 0`; $\text{DCG} = 2 + 1{,}262 + 1 + 0{,}356 = 4{,}618$; ideal `2 2 2 1 0 0 0 0` → $\text{IDCG} = 2 + 1{,}262 + 1 + 0{,}431 = 4{,}693$; $\text{nDCG} = 0{,}984$ — sobe: os três grau-2 no topo, só `d6` fora do lugar |
| **9** | Um grupo avaliou 3 consultas e escreveu: "o cosseno é melhor: MAP 0,71 contra 0,69". Duas objeções. | três consultas são poucas; diferença pequena sem teste (Aula 16); olhar consulta a consulta — quaisquer duas |

## Execução

O script `estrutura/codigos/2026-10-25-appa-GuiasEstudo.R` executa os exemplos
canônicos e a aplicação ao corpus congelado. As saídas ficam em `estrutura/resultados/guias/`.
